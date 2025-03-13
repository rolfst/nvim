local mini_move_ok, mini_move = pcall(require, "mini.move")
if not mini_move_ok then
    return
end
mini_move.setup()
