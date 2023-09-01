local plugin = {
  'NvChad/nvim-colorizer.lua'
}

function plugin.config()
  require('colorizer').setup()
end

return plugin
