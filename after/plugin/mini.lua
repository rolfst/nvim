local mini_move_ok, mini_move = pcall(require, "mini.move")
if mini_move_ok then
    mini_move.setup()
end
local mini_ai_ok, mini_ai = pcall(require, "mini.ai")
if mini_ai_ok then
    mini_ai.setup()
end
local mini_diff_ok, mini_diff = pcall(require, "mini.diff")
if mini_diff_ok then
    mini_diff.setup({
        -- Disabled by default
        source = mini_diff.gen_source.none(),
    })
end
local mini_icons_ok, mini_icons = pcall(require, "mini.icons")
if mini_icons_ok then
    mini_icons.setup()
end
local mini_session_ok, mini_session = pcall(require, "mini.sessions")
if mini_session_ok then
    local SaveProject = function()
        -- 1. Bepaal paden en namen
        local cwd = vim.fn.getcwd()
        -- Haal alleen de mapnaam op (bijv. 'mijn-project' van '/home/ik/code/mijn-project')
        local dir_name = vim.fn.fnamemodify(cwd, ":t")

        -- De locatie van je kitty sessies (zoals in je eerdere scripts)
        local session_dir = vim.fn.expand("~/.local/share/kitty/sessions")
        local session_file = session_dir .. "/" .. dir_name

        -- Zorg dat de map bestaat (veiligheidshalve)
        vim.fn.mkdir(session_dir, "p")

        -- 2. Check of het kitty sessie bestand al bestaat
        -- We gebruiken vim.uv (of vim.loop in oudere nvim) om bestandsstatus te checken
        local stat = (vim.uv or vim.loop).fs_stat(session_file)

        if not stat then
            -- BESTAAT NIET: Maak Kitty sessie aan
            -- We gebruiken --base-dir om zeker te weten dat hij in jouw map komt
            -- Of we geven het volledige pad mee, wat kitty ook accepteert.

            local cmd = string.format(
                "kitten @ action save_as_session --use-foreground-process=yes --save-only=yes '%s'",
                session_file
            )

            local output = vim.fn.system(cmd)

            if vim.v.shell_error == 0 then
                vim.notify(
                    "🚀 Kitty sessie aangemaakt: " .. dir_name,
                    vim.log.levels.INFO
                )
            else
                vim.notify(
                    "❌ Fout bij maken Kitty sessie: " .. output,
                    vim.log.levels.ERROR
                )
            end
        else
            -- BESTAAT WEL: Doe niets met Kitty, alleen notificatie
            vim.notify(
                "ℹ️ Kitty sessie bestond al: " .. dir_name,
                vim.log.levels.INFO
            )
        end
        mini_session.write(dir_name)
        vim.notify(
            "💾 Neovim sessie opgeslagen als: " .. dir_name,
            vim.log.levels.INFO
        )
    end

    mini_session.setup()
    vim.keymap.set("n", "<leader>pl", function()
        mini_session.read(vim.fn.fnamemodify(vim.loop.cwd(), ":t"))
    end, { desc = "Session load" })
    vim.keymap.set("n", "<leader>ps", function()
        SaveProject()
    end, { desc = "Session save" })
    vim.keymap.set("n", "<leader>pd", function()
        mini_session.delete(nil, { force = true })
    end, { desc = "Session delete" })
end
