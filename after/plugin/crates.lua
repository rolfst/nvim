local crates_status_ok, crates = pcall(require, "crates")
if not crates_status_ok then
    return
end
crates.setup()
vim.api.nvim_create_user_command("CratesUpdate", "lua require('crates').update()", {})
vim.api.nvim_create_user_command("CratesReload", "lua require('crates').reload()", {})
vim.api.nvim_create_user_command("CratesHide", "lua require('crates').hide()", {})
vim.api.nvim_create_user_command("CratesToggle", "lua require('crates').toggle()", {})
vim.api.nvim_create_user_command("CratesUpdateCrate", "lua require('crates').update_crate()", {})
vim.api.nvim_create_user_command("CratesUpdateCrates", "lua require('crates').update_crates()", {})
vim.api.nvim_create_user_command("CratesUpdateAllCrates", "lua require('crates').update_all_crates()", {})
vim.api.nvim_create_user_command("CratesUpgradeCrate", "lua require('crates').upgrade_crate()", {})
vim.api.nvim_create_user_command("CratesUpgradeCrates", "lua require('crates').upgrade_crates()", {})
vim.api.nvim_create_user_command("CratesUpgradeAllCrates", "lua require('crates').upgrade_all_crates()", {})
vim.api.nvim_create_user_command("CratesShowPopup", "lua require('crates').show_popup()", {})
vim.api.nvim_create_user_command("CratesShowVersionsPopup", "lua require('crates').show_versions_popup()", {})
vim.api.nvim_create_user_command("CratesShowFeaturesPopup", "lua require('crates').show_features_popup()", {})
vim.api.nvim_create_user_command("CratesFocusPopup", "lua require('crates').focus_popup()", {})
vim.api.nvim_create_user_command("CratesHidePopup", "lua require('crates').hide_popup()", {})
