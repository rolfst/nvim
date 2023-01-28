local global = require("rolfst.global")
local languages_setup = require("rolfst.utils")
-- local nvim_lsp_util = require("lspconfig/util")
local navic = require("nvim-navic")
local default_debouce_time = 150
local dap = require("dap")

local language_configs = {}

local function start_server_tools(config)
	local rust_tools = require("rust-tools")
	rust_tools.setup({
		tools = {
			inlay_hints = {
				auto = true,
			},
			hover_actions = {
				border = {
					{ "┌", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "┐", "FloatBorder" },
					{ "│", "FloatBorder" },
					{ "┘", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "└", "FloatBorder" },
					{ "│", "FloatBorder" },
				},
			},
		},
		server = {
			flags = {
				debounce_text_changes = default_debouce_time,
			},
			autostart = true,
			filetypes = { "rust" },
			on_attach = function(client, bufnr)
				-- languages_setup.keymaps(client, bufnr)
				languages_setup.omni(client, bufnr)
				languages_setup.tag(client, bufnr)
				languages_setup.document_highlight(client, bufnr)
				languages_setup.document_formatting(client, bufnr)
				navic.attach(client, bufnr)
			end,
			capabilities = languages_setup.get_capabilities(),
			-- root_dir = function(fname)
			-- 	return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
			-- end,
		},
		dap = {
			adapter = require("rust-tools.dap").get_codelldb_adapter(
				global.mason_path .. "/packages/codelldb/extension/adapter/codelldb",
				global.mason_path .. "/packages/codelldb/extension/adapter/libcodelldb.so"
			),
		},
	})
end

language_configs["dependencies"] = { "rust-analyzer", "codelldb" }

language_configs["lsp"] = function(server_configs)
	local server = {
		checkOnSave = "clippy",
		cargo = {
			allFeatures = true,
		},
		inlayHints = {
			lifetimeElisionHints = {
				enable = true,
				useParameterNames = true,
			},
		},
		assist = {
			importEnforceGranularity = true,
			importPrefix = true,
		},
	}
	vim.tbl_extend("force", server_configs, server)
	return {
		["language"] = "rust",
		["dap"] = { "codelldb" },
		["language-server"] = { "rust_analyzer", server_configs },
		["callback"] = start_server_tools,
	}
end

language_configs["dap"] = function()
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
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			sourceLanguages = { "rust" },
		},
	}
end

return language_configs
