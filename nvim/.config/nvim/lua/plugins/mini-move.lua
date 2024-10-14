return {
    "echasnovski/mini.move",
    version = false,
    keys = {
        "J",
        "K",
        "H",
        "L",
    },
    config = function()
        require("mini.move").setup({
            mappings = {
                up = "K",
                down = "J",
                left = "H",
                right = "L",
            },
        })
    end,
}
