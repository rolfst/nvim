local codecompanion_status_ok, cc = pcall(require, "codecompanion")
if not codecompanion_status_ok then
    print("no codecompanion")
    return
end
-- local vc_status_ok, vc = pcall(require, "vectorcode")
-- if vc_status_ok then
--     vc.setup({
--         cli_cmds = {
--             vectorcode = "vectorcode",
--         },
--         ---@type VectorCode.RegisterOpts
--         async_opts = {
--             debounce = 10,
--             events = { "BufWritePost", "InsertEnter", "BufReadPost" },
--             exclude_this = true,
--             n_query = 1,
--             notify = false,
--             query_cb = require("vectorcode.utils").make_surrounding_lines_cb(
--                 -1
--             ),
--             run_on_register = false,
--         },
--         async_backend = "lsp", -- or "lsp"
--         exclude_this = true,
--         n_query = 1,
--         notify = true,
--         timeout_ms = 5000,
--         on_setup = {
--             update = true, -- set to true to enable update when `setup` is called.
--             lsp = true,
--         },
--         sync_log_env_var = false,
--     })
-- end
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
        cc.setup({
            -- your configuration comes here
            -- or leave it empty to use the default settings
            extensions = {
                mcphub = {
                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        make_vars = true,
                        make_slash_commands = true,
                        show_result_in_chat = true,
                    },
                },
                -- vectorcode = {
                --     ---@type VectorCode.CodeCompanion.ExtensionOpts
                --     opts = {
                --         tool_group = {
                --             -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
                --             enabled = true,
                --             -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
                --             -- if you use @vectorcode_vectorise, it'll be very handy to include
                --             -- `file_search` here.
                --             extras = {},
                --             collapse = false, -- whether the individual tools should be shown in the chat
                --         },
                --         tool_opts = {
                --             ---@type VectorCode.CodeCompanion.ToolOpts
                --             ["*"] = {},
                --             ---@type VectorCode.CodeCompanion.LsToolOpts
                --             ls = {},
                --             ---@type VectorCode.CodeCompanion.VectoriseToolOpts
                --             vectorise = {},
                --             ---@type VectorCode.CodeCompanion.QueryToolOpts
                --             query = {
                --                 max_num = { chunk = -1, document = -1 },
                --                 default_num = { chunk = 50, document = 10 },
                --                 include_stderr = false,
                --                 use_lsp = false,
                --                 no_duplicate = true,
                --                 chunk_mode = false,
                --                 ---@type VectorCode.CodeCompanion.SummariseOpts
                --                 summarise = {
                --                     ---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
                --                     enabled = false,
                --                     adapter = nil,
                --                     query_augmented = true,
                --                 },
                --             },
                --             files_ls = {},
                --             files_rm = {},
                --         },
                --     },
                -- },
            },
            adapters = {
                gemini = function()
                    return require("codecompanion.adapters").extend("gemini", {
                        env = {
                            api_key = os.getenv("GEMINI_API_KEY"),
                        },
                        schema = {
                            model = {
                                default = "gemini-2.5-pro",
                            },
                        },
                    })
                end,
                copilot = {
                    -- Optional settings for copilot
                    accept_keymap = "<Tab>", -- Keymap to accept suggestions
                    next_keymap = "<C-]>",
                    prev_keymap = "<C-[>",
                    dismiss_keymap = "<C-/>",
                    suggestion_color = "#6CC644", -- Color for suggestions
                },
            },
            -- Set up keymaps for CodeCompanion. You can customize these as you wish.
            sources = {
                per_filetype = {
                    codecompanion = { "codecompanion" },
                },
            },
            strategies = {
                chat = {
                    adapter = {
                        name = "gemini",
                        model = "gemini-2.5-pro",
                    },
                },
                inline = {
                    adapter = "copilot",
                },
                cmd = {
                    adapter = { name = "gemini", model = "gemini-2.5-pro" },
                },
            },
        })
    end,
})

-- Open the chat window in a vertical split
vim.keymap.set(
    "n",
    "<leader>ac",
    "<cmd>CodeCompanionChat<CR>",
    { desc = "[A]i [C]hat" }
)
-- Run an inline assistant command on the current line or selection
vim.keymap.set(
    "n",
    "<leader>ai",
    "<cmd>CodeCompanionInline<CR>",
    { desc = "[A]i [I]nline Assistant" }
)
