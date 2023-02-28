local M = {}

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
	},
	severity_sort = true,
	float = { source = "always" }, -- of "if_many" },
})

M.config_diagnostic = {
	virtual_text = false,
	update_in_insert = true,
	underline = true,
	severity_sort = true,
}

M.file_types = {
	["emmet"] = { "html", "css", "typescriptreact", "javascriptreact" },
	["stylelint"] = {
		"css",
		"less",
		"postcss",
		"sass",
		"scss",
		"sugarss",
	},
	["eslint"] = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
	},
	-- ["angular"] = { "typescript", "html", "typescriptreact", "typescript.tsx" },
	-- ["clojure"] = { "clojure", "edn" },
	-- ["cmake"] = { "cmake" },
	-- ["cpp"] = { "c", "cpp", "objc", "objcpp" },
	-- ["cs"] = { "cs", "vb" },
	-- ["css"] = { "css", "scss", "less" },
	-- ["d"] = { "d" },
	-- ["dart"] = { "dart" },
	-- ["elixir"] = { "elixir", "eelixir" },
	-- ["elm"] = { "elm" },
	-- ["ember"] = { "handlebars", "typescript", "javascript" },
	-- ["erlang"] = { "erlang" },
	-- ["fortran"] = { "fortran" },
	-- ["go"] = { "go", "gomod" },
	["graphql"] = { "graphql" },
	-- ["groovy"] = { "groovy" },
	-- ["haskell"] = { "haskell", "lhaskell" },
	["html"] = { "html" },
	-- ["java"] = { "java" },
	["json"] = { "json" },
	["jsts"] = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
	-- ["julia"] = { "julia" },
	-- ["kotlin"] = { "kotlin" },
	-- ["latex"] = { "bib", "tex" },
	["lua"] = { "lua" },
	["markdown"] = { "markdown" },
	-- ["ocaml"] = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
	-- ["org"] = { "org" },
	-- ["perl"] = { "perl" },
	-- ["php"] = { "php" },
	["python"] = { "python" },
	-- ["ruby"] = { "ruby" },
	-- ["r"] = { "r", "rmd" },
	["rust"] = { "rust" },
	-- ["scala"] = { "scala", "sbt" },
	["shell"] = { "sh", "bash", "zsh", "csh", "ksh" },
	["sql"] = { "sql", "mysql" },
	-- ["vim"] = { "vim" },
	["toml"] = { "toml" },
	-- ["vue"] = { "vue" },
	["xml"] = { "xml", "xsd", "xsl", "xslt", "svg" },
	["yaml"] = { "yaml" },
	-- ["zig"] = { "zig", "zir" },
}

local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
M.null_ls_builtins = {
	lua = { diagnostics.luacheck, formatting.stylua },
	luacheck = diagnostics.luacheck,
	stylua = formatting.stylua,
	eslint = {},
	cpplint = diagnostics.cpplint,
	python = { diagnostics.flake8, formatting.yapf, formatting.isort },
	black = formatting.black,
	flake8 = diagnostics.flake8,
	golangci_lint = diagnostics.golangci_lint,
	rubocop = diagnostics.rubocop,
	vint = diagnostics.vint,
	yaml = { diagnostics.yamllint },
	yamllint = diagnostics.yamllint,
	cbfmt = formatting.cbfmt,
	rust = { formatting.rustfmt },
	jsts = {
		formatting.prettierd.with({
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"css",
				"scss",
				"less",
				"html",
				"yaml",
				"markdown",
				"markdown.mdx",
				"graphql",
				"handlebars",
			},
			env = {
				PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("$HOME/.config/nvim/.configs/formatters/.prettierrc.json"),
			},
			options = {
				args = { "$FILENAME", "--no-progress" },
			},
		}),
	},
	shell = { formatting.shfmt, diagnostics.shellcheck },
	shellcheck = diagnostics.shellcheck,
}

return M
