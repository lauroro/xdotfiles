local plugin = {
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'neovim/nvim-lspconfig',
}

function plugin.config()
  require('mason').setup()
  local mlspc = require'mason-lspconfig'
  mlspc.setup{
    ensure_installed = {
      -- check new lsp names with :LspInstall
      'lua_ls',
      'bashls',
    },
  }
  mlspc.setup_handlers {
    function(server)
      require('lspconfig')[server].setup{
        capabilities = capabilities
      }
    end
  }
end

return plugin
