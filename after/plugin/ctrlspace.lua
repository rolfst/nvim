vim.g.ctrlspace_use_tablineend = 1
vim.g.CtrlSpaceLoadLastWorkspaceOnStart = 0
vim.g.CtrlSpaceSaveWorkspaceOnSwitch = 1
vim.g.CtrlSpaceSaveWorkspaceOnExit = 1
vim.g.CtrlSpaceUseTabline = 0
vim.g.CtrlSpaceUseArrowsInTerm = 1
vim.g.CtrlSpaceUseMouseAndArrowsInTerm = 1
vim.g.CtrlSpaceGlobCommand = "rg --files --follow --hidden -g '!{.git/*,node_modules/*,target/*,vendor/*,.venv/*}'"
vim.g.CtrlSpaceIgnoredFiles = "\v(tmp|temp)[\\/]"
vim.g.CtrlSpaceSearchTiming = 10
vim.g.CtrlSpaceSymbols = {
    CS = "",
    Sin = "",
    All = "",
    Vis = "★",
    File = "",
    Tabs = "ﱡ",
    CTab = "ﱢ",
    NTM = "⁺",
    WLoad = "ﰬ",
    WSave = "ﰵ",
    Zoom = "",
    SLeft = "",
    SRight = "",
    BM = "",
    Help = "",
    IV = "",
    IA = "",
    IM = " ",
    Dots = "ﳁ",
}
