local neotest_status_ok, neotest = pcall(require, "neotest")
if not neotest_status_ok then
	return
end
local neotest_ns = vim.api.nvim_create_namespace("neotest")
vim.diagnostic.config({
	virtual_text = {
		format = function(diagnostic)
			local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
			return message
		end,
		prefix = "●",
	},
	severity_sort = true,
	float = { source = "always" }, -- of "if_many" },
}, neotest_ns)
neotest.setup({
	adapters = {
		require("neotest-rust"),
		require("neotest-python")({
			dap = { justMyCode = false },
			args = { "--log-level", "DEBUG" },
			runner = "pytest",
		}),
		require("neotest-jest"),
		require("neotest-haskell"),
		-- require("neotest-elixir"),
		-- require("neotest-go"),
		-- require("neotest-phpunit"),
	},
})
vim.api.nvim_create_user_command("NeotestRun", require("neotest").run.run, {})
vim.api.nvim_create_user_command("NeotestOutput", require("neotest").output.open, {})
vim.api.nvim_create_user_command("NeotestSummary", require("neotest").summary.toggle, {})
vim.keymap.set("n", "<leader>nr", function()
	require("neotest").run.run()
end, { noremap = true, desc = "NeotestRun" })
vim.keymap.set("n", "<leader>no", function()
	require("neotest").output.open()
end, { noremap = true, desc = "NeotestOutput" })
vim.keymap.set("n", "<leader>ns", function()
	require("neotest").summary.toggle()
end, { noremap = true, desc = "NeotestSummary" })
