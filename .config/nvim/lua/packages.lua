local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


local plugins = {
  { "catppuccin/nvim", name = "catppuccin" },
  "nvim-tree/nvim-tree.lua",
  "nvim-tree/nvim-web-devicons",
  "nvim-lualine/lualine.nvim",
  "NvChad/nvim-colorizer.lua",
  {'romgrk/barbar.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
  },
  {'nvim-telescope/telescope.nvim', tag = '0.1.1',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  "folke/which-key.nvim",
  "windwp/nvim-autopairs",
  "nvim-treesitter/nvim-treesitter",
  -- lsp
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  -- completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  {"L3MON4D3/LuaSnip", version = "<CurrentMajor>.*"},
  "rafamadriz/friendly-snippets",
  "saadparwaiz1/cmp_luasnip"
}


local opts = {}


require("lazy").setup(plugins, opts)




