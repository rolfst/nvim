local status_ok, sad = pcall(require, "sad")
if not status_ok then
    return
end
sad.setup({})
