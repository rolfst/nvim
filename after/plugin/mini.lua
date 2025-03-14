local mini_move_ok, mini_move = pcall(require, "mini.move")
if not mini_move_ok then
    return
end
mini_move.setup()
local mini_ai_ok, mini_ai = pcall(require, "mini.ai")
if not mini_ai_ok then
    return
end
mini_ai.setup()
