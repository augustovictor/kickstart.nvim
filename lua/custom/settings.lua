-- [[ Custom Configs ]]
-- [[ Custom Remaps ]]
-- Escape
vim.keymap.set('i', 'kj', '<Esc>')
vim.keymap.set('t', 'kj', '<C-\\><C-n>')
-- Save
vim.keymap.set('n', '<leader>w', ':wa<CR>')

-- Splits
vim.keymap.set('n', '<leader>sj', ':split<CR>')
vim.keymap.set('n', '<leader>sl', ':vsplit<CR>')

-- Neo-tree
-- vim.keymap.set('n', '<leader>a', ':Neotree toggle<CR>')
-- Buffer
vim.keymap.set('n', '<S-H>', ':bprevious<CR>', { desc = 'Previous buffer', silent = true })
vim.keymap.set('n', '<S-L>', ':bnext<CR>', { desc = 'Next buffer', silent = true })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Close current tab', noremap = true, silent = true })
vim.keymap.set('n', '<leader>x', ':bp <BAR> bd #<CR>', { desc = 'Close current buffer', noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>xa', ':%bd|e#|bd#<CR>', { desc = 'Close all buffers except current' })
vim.keymap.set('n', '<S-R>', ':e<CR>', { desc = 'Reload current buffer', silent = true })
vim.keymap.set('n', '<leader>z', ':tab split<CR>', { desc = 'Zoom buffer', silent = true })
-- Format current file CRLF to LF
-- vim.keymap.set('n', '<leader>fc', ':%s/\\r//g<CR>:set ff=unix<CR>:w<CR>', { desc = 'Format current file CRLF to LF' })
-- Copy file path
vim.keymap.set('n', '<localleader>yp', function()
  vim.fn.setreg('+', vim.fn.expand '%:p:h')
end, { desc = 'Copy current file path to clipboard', silent = true })
-- Search
vim.keymap.set('x', '/', '<Esc>/\\%V', { desc = 'Search in visual selection', silent = true })

-- [[ Custom configs]]
vim.g.loaded_netrw = 1 -- disable netrw
vim.g.loaded_netrwPlugin = 1 -- disable netrw
vim.opt.fileformats = { 'unix', 'mac', 'dos' } -- set file formats

-- vim-visual-multi
-- Register with vim-which-key
local wk = require 'which-key'
wk.add {
  { '<leader>m', group = 'Visual Multi', mode = 'n' },
  { '<leader>ma', '<Plug>(VM-Select-All)', desc = 'Select All', mode = 'n' },
  { '<leader>mr', '<Plug>(VM-Start-Regex-Search)', desc = 'Regex Search', mode = 'n' },
  { '<leader>mp', '<Plug>(VM-Add-Cursor-At-Pos)', desc = 'Add Cursor At Pos', mode = 'n' },
  { '<leader>mo', '<Plug>(VM-Toggle-Mappings)', desc = 'Toggle Mappings', mode = 'n' },
}
