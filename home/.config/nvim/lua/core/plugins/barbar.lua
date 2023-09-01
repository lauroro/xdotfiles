local plugin = {
  {'romgrk/barbar.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  init = function() vim.g.barbar_auto_setup = false end,
  opts = {
    auto_hide = true,
    sidebar_filetypes = {
      NvimTree = true,
    },
  },
}}

return plugin
