return {
    'stevearc/oil.nvim',
    config = function()
        require("oil").setup({
            default_file_explorer = true,
            view_options = {
                show_hidden = true, -- This will show ../
            }
        })
        ------------------- REMAP --------------------------
        vim.keymap.set("n", "<leader>pv", ":w | Oil<Cr>")
    end
}
