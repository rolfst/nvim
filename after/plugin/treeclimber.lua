local nvim_treeclimber_status_ok, nvim_treeclimber = pcall(require, "nvim-treeclimber")
if not nvim_treeclimber_status_ok then
	return
end
nvim_treeclimber.setup()
