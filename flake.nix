{
  description = "Neovim config with ai-cage sandboxed OpenCode";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    ai-cage.url = "github:rolfst/ai-cage";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ai-cage,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ ai-cage.overlays.default ];
        };

        # Tools the caged agent is allowed to use.
        # Each package gets --rox (execute permission) in the Landlock sandbox
        # and its bin/ dir is added to PATH inside the cage.
        agentPkgs = with pkgs; [
          bashInteractive
          coreutils
          findutils
          gnugrep
          gnused
          gawk
          diffutils
          git
          openssh
          curl
          wget
          jq
          ripgrep
          fd
          gnutar
          gzip
          unzip
          nodejs_24
          lua5_1
          luarocks
        ];

        # Wrapper that executes the npm-installed OpenCode binary.
        # Keeps you on the newer npm release instead of the nixpkgs version.
        # The Go binary shipped by npm needs its ELF interpreter patched on NixOS.
        opencode-npm = pkgs.writeShellScriptBin "opencode-npm" ''
          set -euo pipefail

          OPENCODE_NPM_BIN="$HOME/.cache/npm/bin/opencode"
          OPENCODE_NPM_NATIVE="$HOME/.cache/npm/lib/node_modules/opencode-ai/bin/.opencode"
          OPENCODE_PATCHED_DIR="$HOME/.cache/opencode"
          OPENCODE_PATCHED_BIN="$OPENCODE_PATCHED_DIR/.opencode-patched"

          if [ ! -x "$OPENCODE_NPM_BIN" ]; then
            echo "error: npm OpenCode not found at $OPENCODE_NPM_BIN" >&2
            echo "install with: npm i -g opencode-ai" >&2
            exit 1
          fi

          if [ ! -x "$OPENCODE_NPM_NATIVE" ]; then
            echo "error: npm OpenCode native binary not found at $OPENCODE_NPM_NATIVE" >&2
            exit 1
          fi

          mkdir -p "$OPENCODE_PATCHED_DIR"

          # Patch interpreter away from /lib64/ld-linux-x86-64.so.2 so the binary
          # runs on NixOS where /lib64 does not exist.
          if [ ! -x "$OPENCODE_PATCHED_BIN" ] || [ "$OPENCODE_NPM_NATIVE" -nt "$OPENCODE_PATCHED_BIN" ]; then
            cp "$OPENCODE_NPM_NATIVE" "$OPENCODE_PATCHED_BIN"
            chmod +x "$OPENCODE_PATCHED_BIN"
            ${pkgs.patchelf}/bin/patchelf --set-interpreter ${pkgs.stdenv.cc.bintools.dynamicLinker} "$OPENCODE_PATCHED_BIN"
          fi

          # npm launcher uses #!/usr/bin/env node which may not resolve inside
          # the cage. Run via the Nix-provided node directly.
          OPENCODE_BIN_PATH="$OPENCODE_PATCHED_BIN" exec node "$OPENCODE_NPM_BIN" "$@"
        '';

        # The Landlock-sandboxed OpenCode wrapper
        caged-opencode = ai-cage.lib.cage { inherit pkgs; } {
          name = "opencode";
          profile = "aiAgent";
          argv = [ "${opencode-npm}/bin/opencode-npm" ];

          packages = agentPkgs ++ [ opencode-npm pkgs.patchelf ];

          filesystem = {
            # Git config (read-only)
            ro = [ "$ORIG_HOME/.gitconfig" ];

            # Copilot auth needs read-write so token refresh can persist.
            # OpenCode config, state, cache, and npm cache all need read-write.
            rw = [
              "$ORIG_HOME/.config/github-copilot"
              "$ORIG_HOME/.config/opencode"
              "$ORIG_HOME/workspaces/.opencode"
              "$ORIG_HOME/.local/share/opencode"
              "$ORIG_HOME/.local/state/opencode"
              "$ORIG_HOME/.cache/opencode"
              "$ORIG_HOME/.cache/npm"
            ];
          };

          env = {
            pass = [
              "TERM"
              "LANG"
              # API keys — add whichever providers you use
              "ANTHROPIC_API_KEY"
              "OPENAI_API_KEY"
              "GEMINI_API_KEY"
              "GITHUB_TOKEN"
            ];
          };
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            caged-opencode
          ];

          shellHook = ''
            echo "ai-cage sandboxed OpenCode available as: opencode-cage"
            echo "   Workspace:   $(pwd) (read-write)"
            echo "   SSH agent:   forwarded (key files blocked)"
            echo "   Copilot:     ~/.config/github-copilot (read-write)"
            echo "   Network:     ports 443, 22 only"
            echo ""
            echo "   Run: opencode-cage"
          '';
        };
      }
    );
}
