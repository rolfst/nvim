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
