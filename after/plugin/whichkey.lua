local status_ok, whichkey = pcall(require, "which-key")
if not status_ok then
	return
end

whichkey.setup()
whichkey.register({
	t = {
		name = "Find",
	},
	g = {
		name = "Git",
	},
	s = {
		name = "Snippets",
	},
}, { prefix = "<space>" })
