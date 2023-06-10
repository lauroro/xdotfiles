-- Gruvbox
vim.cmd.colorscheme "gruvbox-material"



-- Nord
require("nord").setup({
  transparent = false, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  diff = { mode = "bg" }, -- enables/disables colorful backgrounds when used in diff mode. values : [bg|fg]
  borders = true, -- Enable the border between verticaly split windows visible
  errors = { mode = "bg" }, -- Display mode for errors and diagnostics
                            -- values : [bg|fg|none]
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = false },
    keywords = {},
    functions = {},
    variables = { bold = false },

    -- To customize lualine/bufferline
    bufferline = {
      current = {},
      modified = { italic = true },
    },
  },
  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with all highlights and the colorScheme table
  on_highlights = function(highlights, colors) end,
})
--vim.cmd.colorscheme "nord"


-- Catppuccin
require("catppuccin").setup({
  flavour = "mocha",   -- latte, frappe, macchiato, mocha
  background = {
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false,
  color_overrides = {
    mocha = {
      base = "#181a1f",
      mantle = "#13151a",
    },
  }
})
--vim.cmd.colorscheme "catppuccin"



-- Nvim-tree
vim.opt.termguicolors = true
require("nvim-tree").setup()



-- Lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  }
}



-- Bufferline
require 'bufferline'.setup {
  auto_hide = true
}



-- Colorizer
require 'colorizer'.setup()



-- Which-key
vim.o.timeout = true
vim.o.timeoutlen = 300
require("which-key").setup {}



-- Autopairs
require("nvim-autopairs").setup {}



-- Luasnip, friendly snippet
require("luasnip.loaders.from_vscode").lazy_load()



-- Nvim-cmp
local cmp = require("cmp")
cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
        end,
    },
  mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
  sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
    })
})
local capabilities = require("cmp_nvim_lsp").default_capabilities()



-- Meson, Lspconfig
require("mason").setup()
local mlspc = require'mason-lspconfig'
mlspc.setup{
  ensure_installed = {
    -- check new lsp names with :LspInstall
    "lua_ls",
    "pyright",
    "bashls",
    "html",
    "clangd"
  },
}
mlspc.setup_handlers {
  function(server)
    require('lspconfig')[server].setup{
      capabilities = capabilities
    }
  end
}



-- Tree-sitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  -- ensure_installed = { "c", "lua", "vim", "help", "query" },
  ensure_installed = {},
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- Automatically install missing parsers when entering buffer
  auto_install = true,
  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { "javascript" },
  highlight = {
    enable = true,
    -- disable = { "javascript" },
  },
}

