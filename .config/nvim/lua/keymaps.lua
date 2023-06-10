-- <leader> is '\' (back slash)


local keymap = vim.api.nvim_set_keymap
keymap('n', '<C-w>', ':w<CR>', {})
keymap('i', '<C-w>', '<ESC>:w<CR>', {})
keymap('n', '<C-q>', ':q<CR>', {})
keymap('n', '<C-n>', ':set number<CR>', {})
keymap('i', '<C-n>', '<ESC>:set number<CR>a', {})
keymap('n', '<A-n>', ':set nonumber<CR>', {})
keymap('i', '<A-n>', '<ESC>:set nonumber<CR>a', {})
keymap('n', '<C-u>', ':u<CR>', {})
keymap('i', '<C-u>', '<ESC>:u<CR>a', {})
keymap('n', '<leader>s', ':vsplit<CR>', {})
keymap('n', '<C-c>', ':ColorizerToggle<CR>', {})
keymap('n', '<ScrollWheelUp>', '<C-Y>', {})
keymap('n', '<ScrollWheelDown>', '<C-E>', {})

keymap('n', 'gd', ':lua vim.lsp.buf.definition()<cr>', {})
keymap('n', 'gD', ':lua vim.lsp.buf.declaration()<cr>', {})
keymap('n', 'gi', ':lua vim.lsp.buf.implementation()<cr>', {})
keymap('n', 'gw', ':lua vim.lsp.buf.document_symbol()<cr>', {})
keymap('n', 'gw', ':lua vim.lsp.buf.workspace_symbol()<cr>', {})
keymap('n', 'gr', ':lua vim.lsp.buf.references()<cr>', {})
keymap('n', 'gt', ':lua vim.lsp.buf.type_definition()<cr>', {})
keymap('n', 'K', ':lua vim.lsp.buf.hover()<cr>', {})
keymap('n', '<c-k>', ':lua vim.lsp.buf.signature_help()<cr>', {})
keymap('n', '<leader>ca', ':lua vim.lsp.buf.code_action()<cr>', {})
keymap('n', '<leader>rn', ':lua vim.lsp.buf.rename()<cr>', {})

keymap('n', '<A-f>', ':NvimTreeToggle<CR>', {})

keymap('n', '<c-h>', ':WhichKey<CR>', {})
