require("rust-tools").setup({
    tools = {
        inlay_hints = {
            auto = true,
            -- only_current_line = true,
            parameter_hints_prefix = "     ",
            other_hints_prefix = "     ",
            max_len_align = false,
            max_len_align_padding = 10,
        },
        hover_actions = {
            border = {
                { "╭", "FloatBorder" },
                { "─", "FloatBorder" },
                { "╮", "FloatBorder" },
                { "│", "FloatBorder" },
                { "╯", "FloatBorder" },
                { "─", "FloatBorder" },
                { "╰", "FloatBorder" },
                { "│", "FloatBorder" },
            },
            auto_focus = false,
        },
    },
})
