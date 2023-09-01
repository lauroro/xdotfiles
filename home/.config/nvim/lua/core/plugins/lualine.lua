local plugin = {
  'nvim-lualine/lualine.nvim'
}

function plugin.config()
  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    }
  }
end

return plugin
