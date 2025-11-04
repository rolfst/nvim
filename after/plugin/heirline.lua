local funcs = require("rolfst.funcs")
local icons = require("rolfst.icons")

local heirline_status_ok, heirline = pcall(require, "heirline")
if heirline_status_ok then
    return
end

local CodeCompanion = {
    static = {
        processing = false,
    },
    update = {
        "User",
        pattern = "CodeCompanionRequest*",
        callback = function(self, args)
            if args.match == "CodeCompanionRequestStarted" then
                self.processing = true
            elseif args.match == "CodeCompanionRequestFinished" then
                self.processing = false
            end
            vim.cmd("redrawstatus")
        end,
    },
    {
        condition = function(self)
            return self.processing
        end,
        provider = " ",
        hl = { fg = "yellow" },
    },
}

local IsCodeCompanion = function()
    return package.loaded.codecompanion and vim.bo.filetype == "codecompanion"
end

local CodeCompanionCurrentContext = {
    static = {
        enabled = true,
    },
    condition = function(self)
        return IsCodeCompanion()
            and _G.codecompanion_current_context ~= nil
            and self.enabled
    end,
    provider = function()
        local bufname = vim.fn.fnamemodify(
            vim.api.nvim_buf_get_name(_G.codecompanion_current_context),
            ":t"
        )
        return "[  " .. bufname .. " ] "
    end,
    hl = { fg = "gray", bg = "bg" },
    update = {
        "User",
        pattern = { "CodeCompanionRequest*", "CodeCompanionContextChanged" },
        callback = vim.schedule_wrap(function(self, args)
            if args.match == "CodeCompanionRequestStarted" then
                self.enabled = false
            elseif args.match == "CodeCompanionRequestFinished" then
                self.enabled = true
            end
            vim.cmd("redrawstatus")
        end),
    },
}

local CodeCompanionStats = {
    condition = function(self)
        return IsCodeCompanion()
    end,
    static = {
        chat_values = {},
    },
    init = function(self)
        local bufnr = vim.api.nvim_get_current_buf()
        self.chat_values = _G.codecompanion_chat_metadata[bufnr]
    end,
    -- Tokens block
    {
        condition = function(self)
            return self.chat_values.tokens > 0
        end,
        RightSlantStart,
        {
            provider = function(self)
                return "   " .. self.chat_values.tokens .. " "
            end,
            hl = { fg = "gray", bg = "statusline_bg" },
            update = {
                "User",
                pattern = {
                    "CodeCompanionChatOpened",
                    "CodeCompanionRequestFinished",
                },
                callback = vim.schedule_wrap(function()
                    vim.cmd("redrawstatus")
                end),
            },
        },
        RightSlantEnd,
    },
    -- Cycles block
    {
        condition = function(self)
            return self.chat_values.cycles > 0
        end,
        RightSlantStart,
        {
            provider = function(self)
                return "  " .. self.chat_values.cycles .. " "
            end,
            hl = { fg = "gray", bg = "statusline_bg" },
            update = {
                "User",
                pattern = {
                    "CodeCompanionChatOpened",
                    "CodeCompanionRequestFinished",
                },
                callback = vim.schedule_wrap(function()
                    vim.cmd("redrawstatus")
                end),
            },
        },
        RightSlantEnd,
    },
}

local heirline_conditions_status_ok, heirline_conditions =
    pcall(require, "heirline.conditions")
if not heirline_conditions_status_ok then
    return
end
local heirline_utils_status_ok, heirline_utils =
    pcall(require, "heirline.utils")
if not heirline_utils_status_ok then
    return
end
local theme_colors =
    _G.NVIM_SETTINGS.colorschemes.colors[_G.NVIM_SETTINGS.colorschemes.theme]
local align = { provider = "%=" }
local space = { provider = " " }
local mode
local vi_mode = {
    init = function(self)
        self.mode = vim.fn.mode(1)
        if not self.once then
            vim.api.nvim_create_autocmd("ModeChanged", {
                pattern = "*:*o",
                command = "redrawstatus",
            })
            self.once = true
        end
    end,
    static = {
        mode_names = {
            n = "N",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no\22"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "Nt",
            v = "V",
            vs = "Vs",
            V = "V_",
            Vs = "Vs",
            ["\22"] = "^V",
            ["\22s"] = "^V",
            s = "S",
            S = "S_",
            ["\19"] = "^S",
            i = "I",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "C",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
        },
        mode_colors = {
            n = theme_colors.pine,
            i = theme_colors.rose,
            v = theme_colors.gold,
            V = theme_colors.gold,
            ["\22"] = theme_colors.iris,
            c = theme_colors.iris,
            s = theme_colors.iris,
            S = theme_colors.iris,
            ["\19"] = theme_colors.iris,
            R = theme_colors.love,
            r = theme_colors.love,
            ["!"] = theme_colors.love,
            t = theme_colors.bg_01,
        },
    },
    provider = function(self)
        return "   %(" .. self.mode_names[self.mode] .. "%)  "
    end,
    hl = function(self)
        mode = self.mode:sub(1, 1)
        return {
            bg = self.mode_colors[mode],
            fg = theme_colors.bg_01,
            bold = true,
        }
    end,
    update = {
        "ModeChanged",
        "MenuPopup",
        "CmdlineEnter",
        "CmdlineLeave",
    },
}
local file_name_block = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,
}
local work_dir = {
    provider = function()
        local icon = "    "
        local cwd = vim.fn.getcwd(0)
        cwd = vim.fn.fnamemodify(cwd, ":~")
        if not heirline_conditions.width_percent_below(#cwd, 0.25) then
            cwd = vim.fn.pathshorten(cwd)
        end
        local trail = cwd:sub(-1) == "/" and "" or "/"
        return icon .. cwd .. trail
    end,
    hl = { fg = theme_colors.fg_05, bold = true },
    -- on_click = {
    --     callback = function()
    --         vim.cmd("Neotree position=left")
    --     end,
    --     name = "heirline_browser",
    -- },
}
local file_icon = {
    init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon = require("nvim-web-devicons").get_icon_color(
            filename,
            extension,
            { default = true }
        )
    end,
    provider = function(self)
        local is_filename = vim.fn.fnamemodify(self.filename, ":.")
        if is_filename ~= "" then
            return self.icon and self.icon .. " "
        end
    end,
    hl = function()
        return {
            fg = vi_mode.static.mode_colors[mode],
            bold = true,
        }
    end,
}
local file_name = {
    provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then
            return
        end
        if not heirline_conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
        end
        return filename .. " "
    end,
    hl = function()
        return {
            fg = vi_mode.static.mode_colors[mode],
            bold = true,
        }
    end,
}
local file_size = {
    provider = function()
        local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
        fsize = (fsize < 0 and 0) or fsize
        if fsize <= 0 then
            return
        end
        local file_size = require("rolfst.funcs").file_size(fsize)
        return " " .. file_size
    end,
    hl = { fg = theme_colors.foam },
}
local file_flags = {
    {
        provider = function()
            if vim.bo.modified then
                return "  "
            end
        end,
        hl = { fg = theme_colors.rose },
    },
    {
        provider = function()
            if not vim.bo.modifiable or vim.bo.readonly then
                return "  "
            end
        end,
        hl = { fg = theme_colors.rose },
    },
}
file_name_block = heirline_utils.insert(
    file_name_block,
    space,
    space,
    file_icon,
    file_name,
    file_size,
    unpack(file_flags),
    { provider = "%<" }
)
local git = {
    condition = heirline_conditions.is_git_repo,
    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0
            or self.status_dict.removed ~= 0
            or self.status_dict.changed ~= 0
    end,
    hl = { fg = theme_colors.love },
    {
        provider = function(self)
            return "   " .. self.status_dict.head .. " "
        end,
        hl = { bold = true },
    },
    {
        provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("  " .. count)
        end,
        hl = { fg = theme_colors.pine },
    },
    {
        provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("  " .. count)
        end,
        hl = { fg = theme_colors.rose },
    },
    {
        provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("  " .. count)
        end,
        hl = { fg = theme_colors.gold },
    },
    on_click = {
        callback = function()
            vim.defer_fn(function()
                vim.cmd("Neogit")
            end, 100)
        end,
        name = "heirline_git",
    },
}
-- local noice_mode = {
--     condition = require("noice").api.status.mode.has,
--     provider = require("noice").api.status.mode.get,
--     hl = { fg = theme_colors.red_02, bold = true },
-- }
local diagnostics = {
    condition = heirline_conditions.has_diagnostics,
    static = {
        error_icon = " ",
        warn_icon = " ",
        info_icon = " ",
        hint_icon = " ",
    },
    update = { "DiagnosticChanged", "BufEnter" },
    init = function(self)
        self.errors =
            #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings =
            #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints =
            #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info =
            #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,
    {
        provider = function(self)
            return self.errors > 0 and (self.error_icon .. self.errors .. " ")
        end,
        hl = { fg = theme_colors.rose },
    },
    {
        provider = function(self)
            return self.warnings > 0
                and (self.warn_icon .. self.warnings .. " ")
        end,
        hl = { fg = theme_colors.love },
    },
    {
        provider = function(self)
            return self.info > 0 and (self.info_icon .. self.info .. " ")
        end,
        hl = { fg = theme_colors.foam },
    },
    {
        provider = function(self)
            return self.hints > 0 and (self.hint_icon .. self.hints .. " ")
        end,
        hl = { fg = theme_colors.pine },
    },
    on_click = {
        callback = function()
            vim.cmd("OpenAllDiagnostics")
        end,
        name = "heirline_diagnostics",
    },
}
local lsp_active = {
    condition = heirline_conditions.lsp_attached,
    update = { "LspAttach", "LspDetach", "BufWinEnter" },
    provider = function()
        local names = {}
        local null_ls = {}
        for _, server in pairs(vim.lsp.get_clients(0)) do
            if server.name == "null-ls" then
                local sources = require("null-ls.sources")
                local ft = vim.api.nvim_buf_get_option(
                    vim.api.nvim_win_get_buf(0),
                    "filetype"
                )
                for _, source in ipairs(sources.get_available(ft)) do
                    table.insert(null_ls, source.name)
                end
                null_ls = funcs.remove_duplicate(null_ls)
            else
                table.insert(names, server.name)
            end
        end
        if next(null_ls) == nil then
            return "  LSP [" .. table.concat(names, ", ") .. "]"
        else
            return "  LSP ["
                .. table.concat(names, ", ")
                .. "] | NULL-LS ["
                .. table.concat(null_ls, ", ")
                .. "]"
        end
    end,
    hl = { fg = theme_colors.iris, bold = true },
    on_click = {
        callback = function()
            vim.defer_fn(function()
                vim.cmd("LspInfo")
            end, 100)
        end,
        name = "heirline_LSP",
    },
}
local file_type = {
    provider = function()
        local filetype = vim.bo.filetype
        if filetype ~= "" then
            return "  " .. string.upper(filetype)
        end
    end,
    hl = { fg = theme_colors.rose, bold = true },
}
local file_encoding = {
    provider = function()
        local enc = vim.opt.fileencoding:get()
        if enc ~= "" then
            return " " .. enc:upper()
        end
    end,
    hl = { fg = theme_colors.rose, bold = true },
}
local file_format = {
    provider = function()
        local format = vim.bo.fileformat
        if format ~= "" then
            local symbols = {
                unix = "  ",
                dos = "  ",
                mac = "  ",
            }
            return symbols[format]
        end
    end,
    hl = { fg = theme_colors.rose, bold = true },
}
-- local spell = {
--     condition = require("lvim-linguistics.status").spell_has,
--     provider = function()
--         local status = require("lvim-linguistics.status").spell_get()
--         return " SPELL: " .. status
--     end,
--     hl = { fg = theme_colors.foam, bold = true },
-- }
local statistic = {
    provider = function()
        local words = vim.fn.wordcount().words
        local chars = vim.fn.wordcount().chars
        return " " .. words .. " W | " .. chars .. " Ch"
    end,
    hl = { fg = theme_colors.gold, bold = true },
}
local ruler = {
    provider = "  %7(%l (%3L%)) | %2c %P",
    hl = { fg = theme_colors.love, bold = true },
}
local scroll_bar = {
    provider = function()
        local current_line = vim.fn.line(".")
        local total_lines = vim.fn.line("$")
        local chars = { "█", "▇", "▆", "▅", "▄", "▃", "▂", "▁" }
        local line_ratio = current_line / total_lines
        local index = math.ceil(line_ratio * #chars)
        return "  " .. chars[index]
    end,
    hl = { fg = theme_colors.rose },
}
local file_icon_name = {
    provider = function()
        local function isempty(s)
            return s == nil or s == ""
        end

        local hl_group_1 = "FileTextColor"
        vim.api.nvim_set_hl(0, hl_group_1, {
            fg = theme_colors.foam,
            bg = theme_colors.bg,
            bold = true,
        })
        local filename = vim.fn.expand("%:t")
        local extension = vim.fn.expand("%:e")
        if not isempty(filename) then
            local f_icon, f_icon_color =
                require("nvim-web-devicons").get_icon_color(
                    filename,
                    extension,
                    { default = true }
                )
            local hl_group_2 = "FileIconColor" .. extension
            vim.api.nvim_set_hl(
                0,
                hl_group_2,
                { fg = f_icon_color, bg = theme_colors.bg }
            )
            if isempty(f_icon) then
                f_icon = ""
            end
            return "%#"
                .. hl_group_2
                .. "# "
                .. f_icon
                .. "%*"
                .. " "
                .. "%#"
                .. hl_group_1
                .. "#"
                .. filename
                .. "%*"
                .. "  "
        end
    end,
    hl = { fg = theme_colors.rose },
}
local navic = {
    condition = require("nvim-navic").is_available(),
    static = {
        type_hl = icons.hl,
        enc = function(line, col, winnr)
            return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
        end,
        dec = function(c)
            local line = bit.rshift(c, 16)
            local col = bit.band(bit.rshift(c, 6), 1023)
            local winnr = bit.band(c, 63)
            return line, col, winnr
        end,
    },
    init = function(self)
        local data = require("nvim-navic").get_data() or {}
        local children = {}
        for i, d in ipairs(data) do
            local pos = self.enc(
                d.scope.start.line,
                d.scope.start.character,
                self.winnr
            )
            local child = {
                {
                    provider = d.icon,
                    hl = self.type_hl[d.type],
                },
                {
                    provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ""),
                    on_click = {
                        minwid = pos,
                        callback = function(_, minwid)
                            local line, col, winnr = self.dec(minwid)
                            vim.api.nvim_win_set_cursor(
                                vim.fn.win_getid(winnr),
                                { line, col }
                            )
                        end,
                        name = "heirline_navic",
                    },
                },
                hl = { bg = theme_colors.bg },
            }
            if #data > 1 and i < #data then
                table.insert(child, {
                    provider = " ➤ ",
                    hl = { bg = theme_colors.bg, fg = theme_colors.pine },
                })
            end
            table.insert(children, child)
        end
        self.child = self:new(children, 1)
    end,
    provider = function(self)
        return self.child:eval()
    end,
    hl = { bg = theme_colors.bg, fg = theme_colors.fg_01, bold = true },
    update = "CursorMoved",
}
local terminal_name = {
    provider = function()
        local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
        return " " .. tname
    end,
    hl = { fg = theme_colors.rose, bold = true },
}
local status_lines = {
    fallthrough = false,
    hl = function()
        if heirline_conditions.is_active() then
            return {
                bg = theme_colors.bg,
                fg = theme_colors.fg_01,
            }
        else
            return {
                bg = theme_colors.bg,
                fg = theme_colors.fg_01,
            }
        end
    end,
    static = {
        -- mode_color = function(self)
        -- 	local mode_color = heirline_conditions.is_active() and vim.fn.mode() or "n"
        -- 	return self.mode_colors[mode_color]
        -- end,
    },
    {
        vi_mode,
        work_dir,
        file_name_block,
        git,
        space,
        -- noice_mode,
        align,
        diagnostics,
        lsp_active,
        file_type,
        file_encoding,
        file_format,
        -- spell,
        statistic,
        ruler,
        scroll_bar,
    },
}
local win_bars = {
    fallthrough = false,
    {
        condition = function()
            return heirline_conditions.buffer_matches({
                buftype = {
                    "nofile",
                    "prompt",
                    "help",
                    "quickfix",
                },
                filetype = {
                    "ctrlspace",
                    "ctrlspace_help",
                    -- "packer",
                    "undotree",
                    "diff",
                    "Outline",
                    -- "LvimHelper",
                    "floaterm",
                    "dashboard",
                    "vista",
                    "spectre_panel",
                    "DiffviewFiles",
                    -- "flutterToolsOutline",
                    "log",
                    "qf",
                    "dapui_scopes",
                    "dapui_breakpoints",
                    "dapui_stacks",
                    "dapui_watches",
                    "dapui_console",
                    -- "calendar",
                    -- "neo-tree",
                    -- "neo-tree-popup",
                },
            })
        end,
        init = function()
            vim.opt_local.winbar = nil
        end,
    },
    {
        condition = function()
            return heirline_conditions.buffer_matches({
                buftype = { "terminal" },
            })
        end,
        {
            file_type,
            space,
            terminal_name,
        },
    },
    {
        condition = function()
            return not heirline_conditions.is_active()
        end,
        {
            file_icon_name,
        },
    },
    {
        file_icon_name,
        navic,
    },
}
heirline.setup({ statusline = status_lines, winbar = win_bars })
vim.api.nvim_create_autocmd("User", {
    pattern = "HeirlineInitWinbar",
    callback = function(args)
        local buf = args.buf
        local buftype = vim.tbl_contains({
            "nofile",
            "prompt",
            "help",
            "quickfix",
        }, vim.bo[buf].buftype)
        local filetype = vim.tbl_contains({
            "ctrlspace",
            "ctrlspace_help",
            "packer",
            "undotree",
            "diff",
            "Outline",
            "LvimHelper",
            "floaterm",
            "dashboard",
            "vista",
            "spectre_panel",
            "DiffviewFiles",
            "flutterToolsOutline",
            "log",
            "qf",
            "dapui_scopes",
            "dapui_breakpoints",
            "dapui_stacks",
            "dapui_watches",
            "calendar",
            "neo-tree",
            "neo-tree-popup",
        }, vim.bo[buf].filetype)
        if buftype or filetype then
            vim.opt_local.winbar = nil
        end
    end,
})
vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        heirline_utils.on_colorscheme(
            _G.NVIM_SETTINGS.colorschemes.colors[_G.NVIM_SETTINGS.colorschemes.theme]
        )
    end,
    group = "Heirline",
})
