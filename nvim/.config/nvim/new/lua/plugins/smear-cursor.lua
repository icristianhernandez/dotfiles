return {
    -- animate the cursor movement
    "sphamba/smear-cursor.nvim",
    cond = vim.g.neovide == nil,

    opts = {
        never_draw_over_target = true,
        hide_target_hack = true,
        damping = 1.0,
    },
}
