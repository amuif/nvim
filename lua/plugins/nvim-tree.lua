return {
  "nvim-tree/nvim-tree.lua",
  opts = {
    filters = {
      dotfiles = false, -- show dotfiles like .env, .gitignore, etc.
    },
    git = {
      ignore = false, -- also show gitignored files
    },
    view = {
      side = "right",
      width = 35, -- Adjust the width to your liking
    },
  },
}
