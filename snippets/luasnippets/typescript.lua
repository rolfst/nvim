local ls = require("luasnip") --{{{
local s = ls.s                --> snippet
local i = ls.i                --> insert node
local t = ls.t                --> text node

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {} --}}}

local group = vim.api.nvim_create_augroup("Typescript Snippets", { clear = true })
local file_pattern = { "*.ts" }

local function cs(trigger, nodes, opts) --{{{ create snippets helper
    local snippet = s(trigger, nodes)
    local target_table = snippets

    local pattern = file_pattern
    local keymaps = {}

    if opts ~= nil then
        -- check for custom pattern
        if opts.pattern then
            pattern = opts.pattern
        end

        -- if opts is a string
        if type(opts) == "string" then
            if opts == "auto" then
                target_table = autosnippets
            else
                table.insert(keymaps, { "i", opts })
            end
        end

        -- if opts is a table
        if opts ~= nil and type(opts) == "table" then
            for _, keymap in ipairs(opts) do
                if type(keymap) == "string" then
                    table.insert(keymaps, { "i", keymap })
                else
                    table.insert(keymaps, keymap)
                end
            end
        end

        -- set autocmd for each keymap
        if opts ~= "auto" then
            for _, keymap in ipairs(keymaps) do
                vim.api.nvim_create_autocmd("BufEnter", {
                    pattern = pattern,
                    group = group,
                    callback = function()
                        vim.keymap.set(keymap[1], keymap[2], function()
                            ls.snip_expand(snippet)
                        end, { noremap = true, silent = true, buffer = true })
                    end,
                })
            end
        end
    end

    table.insert(target_table, snippet) -- insert snippet into appropriate table
end                                  --}}}

-- Place snippets here --

cs(
    "export interface",
    fmt(
        [[
export interface {} {{
    {}
}}]],
        {
            i(1, "name"),
            i(2, "field"),
        }
    ),
    "ein"
)
cs(
    "export constant",
    fmt([[export const {} = {}]], {
        i(1, "name"),
        i(2, "target"),
    }),
    "eco"
)
cs(
    "const arrow function assignment",
    fmt(
        [[
const {} = ({}) => {{
    {}
}}]],
        {
            i(1, "name"),
            i(2, "arguments"),
            i(3, "body"),
        }
    ),
    "cf"
)
cs(
    "arrow function",
    fmt([[({}) => {}]], {
        i(1, "arguments"),
        i(2, "body"),
    }),
    "af"
)
cs(
    "generator function",
    fmt(
        [[
function* ({}) {{
    {}
}}
    ]],
        {
            i(1, "arguments"),
            i(2, "body"),
        }
    ),
    "gf"
)

cs(
    "constant effect yield",
    fmt(
        [[
const {} = yield* _({})
    ]],
        {
            i(1, "name"),
            i(2, "generator"),
        }
    ),
    "cey"
)

cs(
    "constant declaration",
    fmt(
        [[
const {} = {}
    ]],
        {
            i(1, "name"),
            i(2, "impl"),
        }
    ),
    "cdl"
)

cs(
    "class method",
    fmt(
        [[
{}({}) {{
    {}
}}
    ]],
        {
            i(1, "name"),
            i(2, "arguments"),
            i(3, "impl"),
        }
    ),
    "cme"
)

-- End snippets --

-- {{{ return
return snippets, autosnippets
-- }}}
