local plugin = {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  }
}

function plugin.config()
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  vim.opt.termguicolors = true

  require('nvim-tree').setup {
    disable_netrw = true,
    hijack_netrw = true,
    actions = {
      open_file = {
        quit_on_open = false,
      },
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      show_on_open_dirs = true,
    },
  }
end

return plugin
