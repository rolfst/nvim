local img_clip_ok, img_clip = pcall(require, "img_clip")
if not img_clip_ok then
    return
end
img_clip.setup({
    filetypes = {
        codecompanion = {
            prompt_for_file_name = false,
            template = "[Image]($FILE_PATH)",
            use_absolute_path = true,
        },
    },
})
