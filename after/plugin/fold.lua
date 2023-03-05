local status_ok, fold = pcall(require, "pretty-fold")
if not status_ok then
    return
end
fold.setup()
