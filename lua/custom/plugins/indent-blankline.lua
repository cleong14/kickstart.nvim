-- https://github.com/lukas-reineke/indent-blankline.nvim
return function()
  require("indent_blankline").setup({
    enabled = true,
    char = "│",
    -- If treesitter plugin is enabled then use its indentation
    -- use_treesitter = require("doom.utils").check_plugin("nvim-treesitter", "opt"),
    use_treesitter = true,
    show_first_indent_level = true,
    show_current_context = true,
    show_current_context_start = true,
    filetype_exclude = { "help", "dashboard", "packer", "norg", "DoomInfo", "mason", "null-ls-info", "noice" },
    buftype_exclude = { "terminal" },
    context_patterns = {
      "class",
      "function",
      "method",
      "^if",
      "^while",
      "^for",
      "^object",
      "^table",
      "^type",
      "^import",
      "block",
      "arguments",
    },
  })
end
