local nm = require("neo-minimap")

-- Rust

nm.set({ "zi", "zo" }, "*.rs", {
    events = { "BufEnter" },
    query = {
        [[
        ;; query
(enum_item (type_identifier) @cap)
(trait_item (type_identifier) @cap)
(struct_item (type_identifier) @cap)
;; (impl_item (type_identifier) @cap)
((impl_item) @cap)
(function_item (identifier) @cap)
(mod_item (identifier) @cap)
(macro_definition (identifier) @cap)
        ]],
        1,
    },
    regex = {},
    search_patterns = {
        { "impl", "<C-j>", true },
        { "impl", "<C-k>", false },
        { "mod", "<C-l>", false },
    },
    height_toggle = { 20, 25 },
})

-- Latex

nm.set({ "zo", "zu" }, "*.tex", {
    events = { "BufEnter" },
    query = {},
    regex = {
        { [[\\section]], [[\\subsection]], [[\\subsubsection]] },
        { [[\\begin{.*}]] },
    },
})

-- Lua
nm.set({ "zi", "zo", "zu" }, "*.lua", {
    events = { "BufEnter" },

    query = {
        [[
    ;; query
    ;; ((function_declaration name: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
    ;; ((function_call name: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
    ;; ((dot_index_expression field: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ]]   ,
        1,
        [[
    ;; query
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ((field (identifier) @cap) (#eq? @cap "keymaps"))
    ]]   ,
        [[
    ;; query
    ((for_statement) @cap)
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))

    ((function_call (identifier)) @cap (#vim-match? @cap "^__*" ))
    ((function_call (dot_index_expression) @field (#eq? @field "vim.keymap.set")) @cap)
    ]]   ,
        [[
    ;; query
    ((for_statement) @cap)
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ]]   ,
    },

    regex = {
        {},
        { [[^\s*---*\s\+\w\+]], [[--\s*=]] },
        { [[^\s*---*\s\+\w\+]], [[--\s*=]] },
        {},
    },

    search_patterns = {
        { "function", "<C-j>", true },
        { "function", "<C-k>", false },
        { "keymap", "<A-j>", true },
        { "keymap", "<A-k>", false },
    },

    -- auto_jump = false,
    -- open_win_opts = { border = "double" },
    win_opts = { scrolloff = 1 },

    disable_indentaion = true,
})

-- Python
nm.set({ "zi", "zo", "zu" }, "*.py", {
    events = { "BufEnter" },

    query = {
        [[
    ;; query
    ;; ((function_declaration name: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
    ;; ((function_call name: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
    ;; ((dot_index_expression field: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ]]   ,
        1,
        [[
    ;; query
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ((field (identifier) @cap) (#eq? @cap "keymaps"))
    ]]   ,
        [[
    ;; query
    ((for_statement) @cap)
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))

    ((function_call (identifier)) @cap (#vim-match? @cap "^__*" ))
    ((function_call (dot_index_expression) @field (#eq? @field "vim.keymap.set")) @cap)
    ]]   ,
        [[
    ;; query
    ((for_statement) @cap)
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ]]   ,
    },

    regex = {
        {},
        { [[^\s*---*\s\+\w\+]], [[#\s*=]] },
        { [[^\s*---*\s\+\w\+]], [[#\s*=]] },
        {},
    },

    search_patterns = {
        { "function", "<C-j>", true },
        { "function", "<C-k>", false },
        { "keymap", "<A-j>", true },
        { "keymap", "<A-k>", false },
    },

    -- auto_jump = false,
    -- open_win_opts = { border = "double" },
    win_opts = { scrolloff = 1 },

    disable_indentaion = true,
})

-- javascript
nm.set({ "zi", "zo", "zu" }, { "javascript", "typescript" }, {
    events = { "BufEnter" },

    query = {
        [[
    ;; query
    ;; ((function_declaration name: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
    ;; ((function_call name: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
    ;; ((dot_index_expression field: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ]]   ,
        1,
        [[
    ;; query
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ((field (identifier) @cap) (#eq? @cap "keymaps"))
    ]]   ,
        [[
    ;; query
    ((for_statement) @cap)
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))

    ((function_call (identifier)) @cap (#vim-match? @cap "^__*" ))
    ((function_call (dot_index_expression) @field (#eq? @field "vim.keymap.set")) @cap)
    ]]   ,
        [[
    ;; query
    ((for_statement) @cap)
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ]]   ,
    },

    regex = {
        {},
        { [[^\s*---*\s\+\w\+]], [[//\s*=]] },
        { [[^\s*---*\s\+\w\+]], [[//\s*=]] },
        {},
    },

    search_patterns = {
        { "function", "<C-j>", true },
        { "function", "<C-k>", false },
        { "keymap", "<A-j>", true },
        { "keymap", "<A-k>", false },
    },

    -- auto_jump = false,
    -- open_win_opts = { border = "double" },
    win_opts = { scrolloff = 1 },

    disable_indentaion = true,
})

-- Typescript React
nm.set("zi", { "typescriptreact", "javascriptreact" }, {
    query = [[
;; query
((function_declaration) @cap)
((arrow_function) @cap)
((identifier) @cap (#vim-match? @cap "^use.*"))
  ]] ,
})
