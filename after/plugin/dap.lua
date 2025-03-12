local global = require("rolfst.global")

local dapui_status_ok, dapui = pcall(require, "dapui")
if not dapui_status_ok then
    return
end
local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
    return
end
dapui.setup({
    icons = {
        expanded = "▾",
        collapsed = "▸",
    },
    mappings = {
        expand = {
            "<CR>",
            "<2-LeftMouse>",
        },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
    },
    layouts = {
        {
            elements = {
                { id = "scopes",      size = 0.33 },
                { id = "breakpoints", size = 0.17 },
                { id = "stacks",      size = 0.25 },
                { id = "watches",     size = 0.25 },
            },
            size = 0.33,
            position = "left",
        },
        {
            elements = {
                { id = "repl",    size = 0.45 },
                { id = "console", size = 0.55 },
            },
            size = 0.27,
            position = "bottom",
        },
    },
    floating = {
        max_height = nil,
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = single, -- Border style. Can be 'single', 'double' or 'rounded'
        mappings = {
            ["close"] = { "q", "<Esc>" },
        },
    },
    windows = {
        indent = 1,
    },
    controls = {
        enabled = true,
        element = "repl",
        icons = {
            pause = "",
            play = "",
            step_over = "",
            step_into = "",
            step_back = "",
            step_out = "",
            run_last = "",
            terminate = "",
        },
    },
    render = {
        max_type_length = nil,
        max_value_lines = 100,
        indent = 1,
    },
})
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close({})
end
vim.fn.sign_define("DapBreakpoint", {
    text = "",
    texthl = "",
    linehl = "",
    numhl = "",
})
vim.fn.sign_define("DapStopped", {
    text = "",
    texthl = "",
    linehl = "",
    numhl = "",
})
vim.fn.sign_define("DapLogPoint", {
    text = "▶",
    texthl = "",
    linehl = "",
    numhl = "",
})
vim.api.nvim_create_user_command(
    "LuaDapLaunch",
    'lua require"osv".run_this()',
    {}
)
vim.api.nvim_create_user_command(
    "DapToggleBreakpoint",
    'lua require("dap").toggle_breakpoint()',
    {}
)
vim.api.nvim_create_user_command(
    "DapContinue",
    'lua require"dap".continue()',
    {}
)
vim.api.nvim_create_user_command(
    "DapStepInto",
    'lua require"dap".step_into()',
    {}
)
vim.api.nvim_create_user_command(
    "DapStepOver",
    'lua require"dap".step_over()',
    {}
)
vim.api.nvim_create_user_command(
    "DapStepOut",
    'lua require"dap".step_out()',
    {}
)
vim.api.nvim_create_user_command("DapUp", 'lua require"dap".up()', {})
vim.api.nvim_create_user_command("DapDown", 'lua require"dap".down()', {})
vim.api.nvim_create_user_command("DapPause", 'lua require"dap".pause()', {})
vim.api.nvim_create_user_command("DapClose", 'lua require"dap".close()', {})
vim.api.nvim_create_user_command(
    "DapDisconnect",
    'lua require"dap".disconnect()',
    {}
)
vim.api.nvim_create_user_command("DapRestart", 'lua require"dap".restart()', {})
vim.api.nvim_create_user_command(
    "DapToggleRepl",
    'lua require"dap".repl.toggle()',
    {}
)
vim.api.nvim_create_user_command(
    "DapGetSession",
    'lua require"dap".session()',
    {}
)
vim.api.nvim_create_user_command(
    "DapUIClose",
    'lua require"dap".close(); require"dap".disconnect(); require"dapui".close()',
    {}
)
vim.keymap.set("n", "<A-1>", function()
    dap.toggle_breakpoint()
end, { noremap = true, silent = true, desc = "DapToggleBreakpoint" })
vim.keymap.set("n", "<A-2>", function()
    dap.continue()
end, { noremap = true, silent = true, desc = "DapContinue" })
vim.keymap.set("n", "<A-3>", function()
    dap.step_into()
end, { noremap = true, silent = true, desc = "DapStepInto" })
vim.keymap.set("n", "<A-4>", function()
    dap.step_over()
end, { noremap = true, silent = true, desc = "DapStepOver" })
vim.keymap.set("n", "<A-5>", function()
    dap.step_out()
end, { noremap = true, silent = true, desc = "DapStepOut" })
vim.keymap.set("n", "<A-6>", function()
    dap.up()
end, { noremap = true, silent = true, desc = "DapUp" })
vim.keymap.set("n", "<A-7>", function()
    dap.down()
end, { noremap = true, silent = true, desc = "DapDown" })
vim.keymap.set("n", "<A-8>", function()
    dap.close()
    dap.disconnect()
    dapui.close()
end, { noremap = true, silent = true, desc = "DapUIClose" })
vim.keymap.set("n", "<A-9>", function()
    dap.restart()
end, { noremap = true, silent = true, desc = "DapRestart" })
vim.keymap.set("n", "<A-0>", function()
    dap.repl.toggle()
end, { noremap = true, silent = true, desc = "DapToggleRepl" })

local dap_vscode_js_status_ok, dap_vscode_js = pcall(require, "dap-vscode-js")
if not dap_vscode_js_status_ok then
    return
end
dap_vscode_js.setup({
    node_path = "node",                                      -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    debugger_path = global.mason_path .. "/vscode-js-debug", -- Path to vscode-js-debug installation.
    -- debugger_cmd = { "js-debug-adapter" },                                                    -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    adapters = {
        "pwa-node",
        "pwa-chrome",
        "pwa-msedge",
        "node-terminal",
        "pwa-extensionHost",
    }, -- which adapters to register in nvim-dap
})
local exts = {
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    -- using pwa-chrome
    "vue",
    "svelte",
}

for i, ext in ipairs(exts) do
    dap.configurations[ext] = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch Current File (pwa-node)",
            cwd = vim.fn.getcwd(),
            args = { "${file}" },
            sourceMaps = true,
            protocol = "inspector",
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch Current File (pwa-node with ts-node)",
            cwd = vim.fn.getcwd(),
            runtimeArgs = { "-r", "ts-node/register" },
            runtimeExecutable = "node",
            args = { "${file}" },
            sourceMaps = true,
            protocol = "inspector",
            -- skipFiles = { "<node_internals>/**", "node_modules/**" },
            resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**",
            },
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch Current File (pwa-node with deno)",
            cwd = vim.fn.getcwd(),
            runtimeArgs = { "run", "--inspect-brk", "--allow-all", "${file}" },
            runtimeExecutable = "deno",
            attachSimplePort = 9229,
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch Test Current File (pwa-node with jest)",
            cwd = vim.fn.getcwd(),
            runtimeArgs = { "${workspaceFolder}/node_modules/.bin/jest" },
            runtimeExecutable = "node",
            args = { "${file}", "--coverage", "false" },
            rootPath = "${workspaceFolder}",
            sourceMaps = true,
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch Test Current File (pwa-node with vitest)",
            cwd = vim.fn.getcwd(),
            program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
            args = { "--inspect-brk", "--threads", "false", "run", "${file}" },
            autoAttachChildProcesses = true,
            smartStep = true,
            console = "integratedTerminal",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach to Docker",
            cwd = vim.fn.getcwd(),
            program = "${workspaceFolder}",
            remoteRoot = "/",
            websocketAddress = function()
                return string.match(
                    vim.api.nvim_exec('!docker logs [container-name] |& grep -oE "ws.*" | tail -1', true), "ws://.*")
            end,
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch Test Current File (pwa-node with deno)",
            cwd = vim.fn.getcwd(),
            runtimeArgs = { "test", "--inspect-brk", "--allow-all", "${file}" },
            runtimeExecutable = "deno",
            attachSimplePort = 9229,
        },
        {
            type = "pwa-chrome",
            request = "attach",
            name = "Attach Program (pwa-chrome = { port: 9222 })",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            port = 9222,
            webRoot = "${workspaceFolder}",
        },
        {
            type = "node2",
            request = "attach",
            name = "Attach Program (Node2)",
            processId = require("dap.utils").pick_process,
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach Program (pwa with ts-node)",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            skipFiles = { "<node_internals>/**" },
            port = 9229,
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach Program (pwa-node)",
            cwd = vim.fn.getcwd(),
            processId = require("dap.utils").pick_process,
            skipFiles = { "<node_internals>/**" },
        },
    }
end
-- dap.configurations.javascript = {
--     {
--         type = "pwa-node",
--         request = "launch",
--         name = "Launch file",
--         program = "${file}",
--         cwd = "${workspaceFolder}",
--     },
--     {
--         type = "pwa-node",
--         request = "launch",
--         name = "Choose file",
--         program = function()
--             return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
--         end,
--         cwd = "${workspaceFolder}",
--     },
--     {
--         type = "pwa-node",
--         request = "launch",
--         name = "Debug Jest Tests",
--         -- trace = true, -- include debugger info
--         runtimeExecutable = "node",
--         runtimeArgs = {
--             "./node_modules/jest/bin/jest.js",
--             "--runInBand",
--         },
--         rootPath = "${workspaceFolder}",
--         cwd = "${workspaceFolder}",
--         console = "integratedTerminal",
--         internalConsoleOptions = "neverOpen",
--     },
--     {
--         type = "pwa-node",
--         request = "launch",
--         name = "Debug Mocha Tests",
--         -- trace = true, -- include debugger info
--         runtimeExecutable = "node",
--         runtimeArgs = {
--             "./node_modules/mocha/bin/mocha.js",
--         },
--         rootPath = "${workspaceFolder}",
--         cwd = "${workspaceFolder}",
--         console = "integratedTerminal",
--         internalConsoleOptions = "neverOpen",
--     },
--     {
--         type = "pwa-node",
--         request = "attach",
--         name = "Attach",
--         processId = require("dap.utils").pick_process,
--         cwd = "${workspaceFolder}",
--     },
--     {
--         type = "pwa-node",
--         request = "launch",
--         name = "Debug Jest Tests",
--         trace = true,
--         runtimeExecutable = "node",
--         runtimeArgs = {
--             "./node_modules/jest/bin/jest.js",
--             "--runInBand",
--         },
--         rootPath = "${workspaceFolder}",
--         cwd = "${workspaceFolder}",
--         console = "integratedTerminal",
--         internalConsoleOptions = "neverOpen",
--     },
--     {
--         type = "pwa-node",
--         request = "launch",
--         name = "Debug Mocha Tests",
--         trace = true,
--         runtimeExecutable = "node",
--         runtimeArgs = {
--             "./node_modules/mocha/bin/mocha.js",
--         },
--         rootPath = "${workspaceFolder}",
--         cwd = "${workspaceFolder}",
--         console = "integratedTerminal",
--         internalConsoleOptions = "neverOpen",
--     },
-- }
-- dap.configurations.typescript = {
--     {
--         type = "pwa-node",
--         request = "launch",
--         name = "Launch file",
--         program = "${file}",
--         cwd = "${workspaceFolder}",
--     },
--     {
--         type = "pwa-node",
--         request = "launch",
--         name = "Choose file",
--         program = function()
--             return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
--         end,
--         cwd = "${workspaceFolder}",
--     },
--     {
--         type = "pwa-node",
--         request = "attach",
--         name = "Attach",
--         processId = require("dap.utils").pick_process,
--         cwd = "${workspaceFolder}",
--     },
--     {
--         type = "pwa-node",
--         request = "launch",
--         name = "Debug Jest Tests",
--         trace = true, -- include debugger info
--         runtimeExecutable = "node",
--         runtimeArgs = {
--             "./node_modules/jest/bin/jest.js",
--             "--runInBand",
--         },
--         rootPath = "${workspaceFolder}",
--         cwd = "${workspaceFolder}",
--         console = "integratedTerminal",
--         internalConsoleOptions = "neverOpen",
--     },
--     {
--         type = "pwa-node",
--         request = "launch",
--         name = "Debug Mocha Tests",
--         trace = true, -- include debugger info
--         runtimeExecutable = "node",
--         runtimeArgs = {
--             "./node_modules/mocha/bin/mocha.js",
--         },
--         rootPath = "${workspaceFolder}",
--         cwd = "${workspaceFolder}",
--         console = "integratedTerminal",
--         internalConsoleOptions = "neverOpen",
--     },
-- }
dap.adapters.python = {
    type = "executable",
    command = global.mason_path .. "/packages/debugpy/venv/bin/python",
    args = { "-m", "debugpy.adapter" },
}
dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Debug",
        program = "${file}",
        pythonPath = function()
            local venv_path = os.getenv("VIRTUAL_ENV")
            if venv_path then
                return venv_path .. "/bin/python"
            end
            if
                vim.fn.executable(
                    global.mason_path
                    .. "/packages/debugpy/venv/"
                    .. "bin/python"
                ) == 1
            then
                return global.mason_path
                    .. "/packages/debugpy/venv/"
                    .. "bin/python"
            else
                return "python"
            end
        end,
    },
    {
        type = "python",
        request = "launch",
        name = "Launch",
        program = function()
            return vim.fn.input(
                "Path to executable: ",
                vim.fn.getcwd() .. "/",
                "file"
            )
        end,
        pythonPath = function()
            local venv_path = os.getenv("VIRTUAL_ENV")
            if venv_path then
                return venv_path .. "/bin/python"
            end
            if
                vim.fn.executable(
                    global.mason_path
                    .. "/packages/debugpy/venv/"
                    .. "bin/python"
                ) == 1
            then
                return global.mason_path
                    .. "/packages/debugpy/venv/"
                    .. "bin/python"
            else
                return "python"
            end
        end,
    },
}

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = global.mason_path .. "/packages/codelldb/codelldb",
        args = { "--port", "${port}" },
    },
}
dap.configurations.rust = {
    {
        name = "debug file",
        type = "codelldb",
        request = "launch",
        program = "${file}",
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        sourceLanguages = { "rust" },
    },
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input(
                "Path to executable: ",
                vim.fn.getcwd() .. "/",
                "file"
            )
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        sourceLanguages = { "rust" },
    },
}

dap.adapters.mix_task = {
    type = "executable",
    command = global.mason_path .. "/bin/elixir-ls-debugger",
    args = {},
}
dap.configurations.elixir = {
    {
        type = "mix_task",
        name = "mix test",
        task = "test",
        taskArgs = { "--trace" },
        request = "launch",
        startApps = true,
        projectDir = "${workspaceFolder}",
        requireFiles = {
            "test/**/test_helper.exs",
            "test/**/*_test.exs",
        },
    },
}
dap.adapters.haskell = {
    type = "executable",
    command = "haskell-debug-adapter",
    args = { "--hackage-version=0.0.33.0" },
}
dap.configurations.haskell = {
    {
        type = "haskell",
        request = "launch",
        name = "Debug",
        workspace = "${workspaceFolder}",
        startup = "${file}",
        stopOnEntry = true,
        logFile = vim.fn.stdpath("data") .. "/haskell-dap.log",
        logLevel = "WARNING",
        ghciEnv = vim.empty_dict(),
        ghciPrompt = "λ: ",
        -- Adjust the prompt to the prompt you see when you invoke the stack ghci command below
        ghciInitialPrompt = "λ: ",
        ghciCmd = "stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show",
    },
}

dap.adapters.go = function(callback)
    local handle
    local port = 38697
    handle = vim.loop.spawn("dlv", {
        args = { "dap", "-l", "127.0.0.1:" .. port },
        detached = true,
    }, function(code)
        handle:close()
    end)
    vim.defer_fn(function()
        callback({ type = "server", host = "127.0.0.1", port = port })
    end, 100)
end
dap.configurations.go = {
    {
        type = "go",
        name = "Launch",
        request = "launch",
        program = function()
            return vim.fn.input(
                "Path to executable: ",
                vim.fn.getcwd() .. "/",
                "file"
            )
        end,
    },
    {
        type = "go",
        name = "Launch test",
        request = "launch",
        mode = "test",
        program = function()
            return vim.fn.input(
                "Path to executable: ",
                vim.fn.getcwd() .. "/",
                "file"
            )
        end,
    },
}

dap.configurations.lua = {
    {
        type = "nlua",
        request = "attach",
        name = "attach to running Neovim instance",
    },
}
dap.adapters.nlua = function(callback, config)
    callback({
        type = "server",
        host = config.host or "127.0.0.1",
        port = config.port or 8086,
    })
end

dap.adapters.netcoredbg = {
    type = "executable",
    command = global.mason_path .. "/packages/netcoredbg/netcoredbg",
    args = { "--interpreter=vscode" },
}
dap.configurations.cs = {
    {
        type = "netcoredbg",
        request = "launch",
        name = "Launch",
        program = function()
            return vim.fn.input(
                global.mason_path
                .. "/packages/netcoredbg/build/ManagedPart.dll",
                vim.fn.input(
                    "Path to executable: ",
                    vim.fn.getcwd() .. "/",
                    "file"
                )
            )
        end,
    },
}

dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = global.mason_path
        .. "/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
}
dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
            return vim.fn.input(
                "Path to executable: ",
                vim.fn.getcwd() .. "/",
                "file"
            )
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = true,
    },
    {
        name = "Attach to gdbserver :1234",
        type = "cppdbg",
        request = "launch",
        MIMode = "gdb",
        miDebuggerServerAddress = "localhost:1234",
        miDebuggerPath = "/usr/bin/gdb",
        cwd = "${workspaceFolder}",
        program = function()
            return vim.fn.input(
                "Path to executable: ",
                vim.fn.getcwd() .. "/",
                "file"
            )
        end,
    },
}
