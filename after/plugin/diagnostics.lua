require("diaglist").init({
    -- optional settings
    -- below are defaults
    debug = false,
    -- increase for noisy servers
    debounce_ms = 150,
})
vim.api.nvim_create_user_command("OpenAllDiagnostics", "lua require'diaglist'.open_all_diagnostics()", {})
vim.api.nvim_create_user_command("OpenBufferDiagnostics", "lua require'diaglist'.open_buffer_diagnostics()", {})
