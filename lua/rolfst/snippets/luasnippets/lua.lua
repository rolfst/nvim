return {
	s({ trig = "key", name = "add key binding", dscr = "set vim keymap" }, {
		t('vim.keymap.set("'),
		c(1, { t("n"), t("v"), t("x") }),
		t('", "'),
		i(2, "vim_key_binding"),
		t('", "'),
		i(3, "command"),
		t('", {'),
		i(4, "opt"),
		t("})"),
		i(0),
	}),
}
