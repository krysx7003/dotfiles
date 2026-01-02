return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = true,
            },
            ensure_installed = { "python", "lua", "sql", "latex", "kotlin" },
            auto_install = true,
            sync_install = true,
            semantic_tokens = true,
        },
    },
    -- "nvim-treesitter/playground",
}
