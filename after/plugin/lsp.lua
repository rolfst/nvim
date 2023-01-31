local lsp = require("lsp-zero")
local global = require("rolfst.global")
local configs = require("rolfst.configs")
local utils = require("rolfst.utils")
local funcs = require("rolfst.funcs")

local opts = { buffer = bufnr, remap = false }
local describe = funcs.describe(opts)

vim.api.nvim_create_user_command("LspHover", "lua vim.lsp.buf.hover()", {})
vim.api.nvim_create_user_command("LspRename", "lua vim.lsp.buf.rename()", {})
vim.api.nvim_create_user_command("LspAddToWorkspaceFolder", "lua vim.lsp.buf.add_workspace_folder()", {})
vim.api.nvim_create_user_command("LspListWorkspaceFolders", "lua vim.lsp.buf.list_workspace_folders()", {})
vim.api.nvim_create_user_command("LspRemoveWorkspaceFolder", "lua vim.lsp.buf.remove_workspace_folder()", {})
vim.api.nvim_create_user_command("LspWorkspaceSymbol", "lua vim.lsp.buf.workspace_symbol()", {})
vim.api.nvim_create_user_command("LspDocumentSymbol", "lua vim.lsp.buf.document_symbol()", {})
vim.api.nvim_create_user_command("LspCodeAction", "lua vim.lsp.buf.code_action()", {})
vim.api.nvim_create_user_command("LspCodeLensRefresh", "lua vim.lsp.codelens.refresh()", {})
vim.api.nvim_create_user_command("LspCodeLensRun", "lua vim.lsp.codelens.run()", {})
vim.api.nvim_create_user_command("LspDeclaration", "lua vim.lsp.buf.declaration()", {})
vim.api.nvim_create_user_command("LspDefinition", "lua vim.lsp.buf.definition()", {})
vim.api.nvim_create_user_command("LspTypeDefinition", "lua vim.lsp.buf.type_definition()", {})
vim.api.nvim_create_user_command("LspReferences", "lua vim.lsp.buf.references()", {})
vim.api.nvim_create_user_command("LspClearReferences", "lua vim.lsp.buf.clear_references()", {})
vim.api.nvim_create_user_command("LspDocumentHighlight", "lua vim.lsp.buf.document_highlight()", {})
vim.api.nvim_create_user_command("LspImplementation", "lua vim.lsp.buf.implementation()", {})
vim.api.nvim_create_user_command("LspIncomingCalls", "lua vim.lsp.buf.incoming_calls()", {})
vim.api.nvim_create_user_command("LspOutgoingCalls", "lua vim.lsp.buf.outgoing_calls()", {})
vim.api.nvim_create_user_command("LspFormat", "lua vim.lsp.buf.format {async = true}", {})
vim.api.nvim_create_user_command("LspSignatureHelp", "lua vim.lsp.buf.signature_help()", {})
vim.api.nvim_create_user_command("LspShowDiagnosticCurrent", "lua require('rolfst.utils.show_diagnostic').line()", {})
local icons = require("rolfst.icons")
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end
local cmp_config_compare_status_ok, cmp_config_compare = pcall(require, "cmp.config.compare")
if not cmp_config_compare_status_ok then
	return
end
local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").lazy_load({ paths = { global.snippets_path .. "/luasnippets" } })
vim.api.nvim_create_user_command("LuaSnipEdit", "lua require'luasnip.loaders.from_lua'.edit_snippet_files()", {})
vim.keymap.set("n", "<space>sne", ":LuaSnipEdit<cr>", { desc = "Edit lua snippet" })
local check_backspace = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local lsp_symbols = icons.cmp

local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
	return
end
mason.setup({
	ui = {
		icons = {
			package_installed = " ",
			package_pending = " ",
			package_uninstalled = " ",
		},
	},
})
vim.diagnostic.config(configs.config_diagnostic)
vim.fn.sign_define("DiagnosticSignError", {
	text = icons.error,
	texthl = "DiagnosticError",
})
vim.fn.sign_define("DiagnosticSignWarn", {
	text = icons.warn,
	texthl = "DiagnosticWarn",
})
vim.fn.sign_define("DiagnosticSignHint", {
	text = icons.hint,
	texthl = "DiagnosticHint",
})
vim.fn.sign_define("DiagnosticSignInfo", {
	text = icons.info,
	texthl = "DiagnosticInfo",
})

lsp.preset("recommended")

lsp.ensure_installed({
	"tsserver",
	"rust_analyzer",
	"sumneko_lua",
	"pyright",
	"eslint",
})
local cmp_select = { behavior = cmp.SelectBehavior.Select }
lsp.setup_nvim_cmp({
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-space>"] = cmp.mapping.complete(cmp_select),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-c>"] = cmp.mapping.close(),
		["<C-l>"] = cmp.mapping({
			i = function(fallback)
				if luasnip.choice_active() then
					luasnip.change_choice(1)
				else
					fallback()
				end -- code
			end,
		}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			-- elseif luasnip.expandable() then
			-- 	luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif require("neogen").jumpable() then
				require("neogen").jump_next()
			elseif check_backspace() then
				fallback()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			elseif require("neogen").jumpable() then
				require("neogen").jump_prev()
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
})

lsp.setup_nvim_cmp({
	formatting = {
		format = function(entry, item)
			item.kind = lsp_symbols[item.kind]
			item.menu = ({
				nvim_lsp = "[LSP]",
				luasnip = "[Snippet]",
				buffer = "[Buffer]",
				path = "[Path]",
				crates = "[Crates]",
				latex_symbols = "[LaTex]",
			})[entry.source.name]
			return item
		end,
	},
	expand = function(args)
		luasnip.lsp_expand(args.body)
	end,
	sources = {
		{
			name = "nvim_lsp",
		},
		{
			name = "luasnip",
		},
		{
			name = "buffer",
		},
		{
			name = "path",
		},
		{
			name = "crates",
		},
		{
			name = "latex_symbols",
		},
		{
			name = "orgmode",
		},
	},
	comparators = {
		cmp_config_compare.exact,
		cmp_config_compare.length,
	},
})

-- local ih_status_ok, ih = pcall(require, "inlay-hints")
lsp.on_attach(function(client, bufnr)
	-- if ih_status_ok then
	--    ih.on_attach(client, bufnr)
	-- end

	vim.keymap.set("n", "gt", function()
		vim.lsp.buf.type_definition()
	end, describe("LspTypeDefinition"))
	-- vim.keymap.set("n", "gws", function()
	-- 	vim.lsp.buf.workspace_symbol()
	-- end, opts)
	-- vim.keymap.set("n", "gds", function()
	-- 	vim.lsp.buf.document_symbol()
	-- end, opts)
	vim.keymap.set("n", "dc", function()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set("n", "ga", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "gR", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("n", "gf", vim.cmd.LspZeroFormat, opts)
	vim.keymap.set("v", "gf", function()
		local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
		local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
		vim.lsp.buf.format({
			range = {
				["start"] = { start_row, 0 },
				["end"] = { end_row, 0 },
			},
			async = true,
		})
	end, describe("range format"))
	vim.keymap.set("n", "gL", function()
		vim.lsp.codelens.refresh()
	end, describe("LspCodeLensRefresh"))
	vim.keymap.set("n", "gl", function()
		vim.lsp.codelens.run()
	end, describe("LspCodeLensRun"))
	vim.keymap.set("i", "<c-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)
end)

lsp.set_preferences({
	set_lsp_keymaps = { omit = { "<F2>", "<F4>", "gl", "go" } },
})
local rust_server = lsp.build_options("rust_analyzer")

local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end
local null_ls_options = lsp.build_options("null-ls", {})
null_ls.setup({
	debug = false,
	on_attach = function(client, bufnr)
		null_ls_options.on_attach(client, bufnr)
		if client.server_capabilities.documentFormattingProvider then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format()
				end,
				group = "NvimIDE",
			})
		end
	end,
})
local lsp_configs = {
	rust = rust_server,
	__index = function(value, key)
		return {}
	end,
}
local mason_registry = require("mason-registry")
local function setup_language(config)
	if pcall(next, config["language-server"]) then
		lsp.configure(config["language-server"][1], config["language-server"][2])
	else
		print("language-server config went wrong: " .. config["language-server"][1])
	end
	null_ls.register(configs.null_ls_builtins[config["language"]])
end

local not_installed = {}
local function check_dependencies(dependencies)
	for _, v in pairs(dependencies) do
		if not mason_registry.is_installed(v) then
			table.insert(not_installed, config["language-server"][1])
		end
	end
end

local file_types = configs.file_types
for k, _ in pairs(file_types) do
	local language_configs_global = dofile(global.nvim_path .. "/lua/rolfst/languages/" .. k .. ".lua")

	for name, func in pairs(language_configs_global) do
		if name == "dependencies" then
			if not pcall(check_dependencies, func) then
				print("error finding dependencies for: " .. k)
			end
		elseif name == "lsp" then
			local config = func(lsp_configs)
			local status_ok, _ = pcall(setup_language, func(lsp_configs[k]))
			if status_ok then
				if funcs.has_value(config, "callback") then
					config["callback"](config)
				end
			end
		else
			if not pcall(func) then
				print("error setting up " .. name)
			end
		end
	end
end
if next(not_installed) ~= nil then
	print("current Mason services are not installed: " .. vim.inspect(not_installed))
end

local lsp_inlayhints_status_ok, lsp_inlayhints = pcall(require, "lsp-inlayhints")
if not lsp_inlayhints_status_ok then
	return
end
lsp_inlayhints.setup({
	inlay_hints = {
		highlight = "Comment",
	},
})

vim.api.nvim_create_augroup("LspAttachInlayHints", {})
vim.api.nvim_create_autocmd("LspAttach", {
	group = "LspAttachInlayHints",
	callback = function(args)
		if not (args.data and args.data.client_id) then
			print("not setting inlay_hints ")
			return
		end
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		lsp_inlayhints.on_attach(client, bufnr)
	end,
})

lsp.setup()
