return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    vim.opt.termguicolors = true

    require("gruvbox").setup({
      contrast = "hard",
      transparent_mode = true,
      overrides = {
        Normal = { bg = "NONE" },
        NormalFloat = { bg = "NONE" },
        LineNr = { fg = "#A89984", bg = "NONE" },
        SignColumn = { bg = "NONE" },
        Comment = { fg = "#928374", italic = true },
      },
    })

    vim.cmd("colorscheme gruvbox")
  end,
}

