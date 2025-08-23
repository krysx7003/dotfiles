return {
    "fedepujol/move.nvim",
    config = function()
        require("move").setup()

        ------------------- REMAP --------------------------
        vim.keymap.set("n", "<C-Up>", ":MoveLine(-1)<CR>", { silent = true })
        vim.keymap.set("n", "<C-Down>", ":MoveLine(1)<CR>", { silent = true })

        vim.keymap.set("v", "<C-Up>", ":MoveBlock(-1)<CR>", { silent = true })
        vim.keymap.set("v", "<C-Down>", ":MoveBlock(1)<CR>", { silent = true })
    end
}
