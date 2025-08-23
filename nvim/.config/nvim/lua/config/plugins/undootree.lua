return {
    {
        "mbbill/undotree",
        config = function()
            ------------------- REMAP --------------------------
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },
}
