local keymap = vim.api.nvim_set_keymap
keymap('n', '<C-w>', ':w<CR>', {})
keymap('i', '<C-w>', '<ESC>:w<CR>', {})
keymap('n', '<C-q>', ':q<CR>', {})
keymap('n', '<C-n>', ':set number!<CR>', {})
keymap('i', '<C-n>', '<ESC>:set number!<CR>a', {})
keymap('n', '<C-u>', ':u<CR>', {})
keymap('i', '<C-u>', '<ESC>:u<CR>a', {})
keymap('n', '<space>s', ':vsplit<CR>', {})
keymap('n', '<C-c>', ':ColorizerToggle<CR>', {})
keymap('n', '<ScrollWheelUp>', '<C-Y>', {})
keymap('n', '<ScrollWheelDown>', '<C-E>', {})

keymap('n', '<A-e>', ':NvimTreeToggle<CR>', {})

keymap('n', '<c-h>', ':WhichKey<CR>', {})

keymap('n', '<space>t', ':TroubleToggle<CR>', {})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<space>ff', builtin.find_files, {})
vim.keymap.set('n', '<space>fb', builtin.buffers, {})
vim.keymap.set('n', '<space>fh', builtin.help_tags, {})
vim.keymap.set("n", '<space>fg', require('telescope').extensions.live_grep_args.live_grep_args, {})
