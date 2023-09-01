local plugin = {
  'windwp/nvim-autopairs'
}

function plugin.config()
  require("nvim-autopairs").setup {}
end

return plugin
