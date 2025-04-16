return {
    -- animate the cursor movement
    "sphamba/smear-cursor.nvim",

    opts = {
        stiffness = 0.4,
        trailing_stiffness = 0.3,
        distance_stop_animating = 0.4,
        -- never_draw_over_target = false,
        never_draw_over_target = true,
    },
}
