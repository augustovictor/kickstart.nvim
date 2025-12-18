-- [[ Custom configs]]
-- Core vim settings (moved from init.lua to keep it clean)
vim.opt.fileformats = { 'unix', 'mac', 'dos' } -- set file formats
vim.o.spell = true
-- vim.opt.wrap = false

-- Session settings (moved from init.lua)
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos'

-- Confirm before quit with unsaved changes (moved from init.lua)
vim.o.confirm = true

-- [[ Custom Commands ]]
vim.keymap.set('n', '<leader>st', function()
  vim.cmd.edit '~/projects/personal/telos/personal_telos.md'
end, { desc = '[S]earch [t]elos file' })

-- [[ Per filetype settings ]]
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'yaml', 'yml' },
  callback = function()
    vim.wo.cursorcolumn = true
    vim.api.nvim_set_hl(0, 'CursorColumn', { bg = '#2f3740' })
  end,
})

-- Refresh neo-tree on git operations
vim.api.nvim_create_autocmd('User', {
  pattern = 'GitOperationComplete',
  callback = function()
    require('neo-tree.sources.manager').refresh 'filesystem'
  end,
})

-- [[ Custom Remaps ]]
-- Escape
vim.keymap.set('i', 'kj', '<Esc>')
vim.keymap.set('t', 'kj', '<C-\\><C-n>')
-- Save
vim.keymap.set('n', '<leader>w', function()
  vim.cmd 'wa'
  require('neo-tree.sources.manager').refresh 'filesystem'
end, {
  desc = 'Save all files',
  silent = true,
})

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

-- Git operations for current buffer
vim.keymap.set('n', 'ga', function()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath ~= '' then
    vim.fn.system('git add ' .. vim.fn.shellescape(filepath))
    print('Added: ' .. vim.fn.fnamemodify(filepath, ':t'))
    vim.api.nvim_exec_autocmds('User', { pattern = 'GitOperationComplete' })
  end
end, { desc = 'Git [a]dd current buffer' })

vim.keymap.set('n', 'gu', function()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath ~= '' then
    vim.fn.system('git reset ' .. vim.fn.shellescape(filepath))
    print('Unstaged: ' .. vim.fn.fnamemodify(filepath, ':t'))
    vim.api.nvim_exec_autocmds('User', { pattern = 'GitOperationComplete' })
  end
end, { desc = 'Git [u]nstage current buffer' })

vim.keymap.set('n', 'gm', function()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath ~= '' then
    local commit_msg = vim.fn.input 'Commit message: '
    if commit_msg ~= '' then
      local result = vim.fn.system('git commit ' .. vim.fn.shellescape(filepath) .. ' -m ' .. vim.fn.shellescape(commit_msg))
      print(result)
      vim.api.nvim_exec_autocmds('User', { pattern = 'GitOperationComplete' })
    end
  end
end, { desc = 'Git [c]ommit current buffer' })

vim.keymap.set('n', 'gp', function()
  local result = vim.fn.system 'git push'
  print(result)
  vim.api.nvim_exec_autocmds('User', { pattern = 'GitOperationComplete' })
end, { desc = 'Git [p]ush' })

-- Register with vim-which-key
local wk = require 'which-key'
wk.add {
  -- Visual Multi
  { '<leader>m', group = 'Visual Multi', mode = 'n' },
  { '<leader>ma', '<Plug>(VM-Select-All)', desc = 'Select All', mode = 'n' },
  { '<leader>mr', '<Plug>(VM-Start-Regex-Search)', desc = 'Regex Search', mode = 'n' },
  { '<leader>mp', '<Plug>(VM-Add-Cursor-At-Pos)', desc = 'Add Cursor At Pos', mode = 'n' },
  { '<leader>mo', '<Plug>(VM-Toggle-Mappings)', desc = 'Toggle Mappings', mode = 'n' },

  -- Git operations (buffer-level)
  { 'ga', desc = 'Git add current buffer' },
  { 'gu', desc = 'Git unstage current buffer' },
  { 'gm', desc = 'Git commit current buffer' },
  { 'gp', desc = 'Git push' },

  -- Buffer navigation
  { '<S-H>', desc = 'Previous buffer' },
  { '<S-L>', desc = 'Next buffer' },
  { '<S-R>', desc = 'Reload current buffer' },
  { '<leader>x', desc = 'Close current buffer' },
  { '<leader>q', desc = 'Close current tab' },
  { '<leader>z', desc = 'Zoom buffer (open in new tab)' },

  -- Splits
  { '<leader>sj', desc = 'Split horizontal' },
  { '<leader>sl', desc = 'Split vertical' },

  -- File operations
  { '<leader>w', desc = 'Save all files' },
  { '<localleader>yp', desc = 'Copy file path to clipboard' },

  -- Escape shortcuts
  { 'kj', desc = 'Escape to normal mode', mode = 'i' },
  { 'kj', desc = 'Escape terminal mode', mode = 't' },

  -- Blink completion
  { '<C-e>', desc = 'Blink: Show/Hide completion menu', mode = 'i' },
  { '<C-s>', desc = 'Blink: Show/Hide signature help', mode = 'i' },
  { '<C-k>', desc = 'Blink: Show/Hide documentation', mode = 'i' },

  -- Search
  { '/', desc = 'Search in visual selection', mode = 'x' },

  -- File completion
  { '<C-x><C-f>', desc = 'File path completion', mode = 'i' },
}
local telescope = require 'telescope'
local actions = require 'telescope.actions'

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<S-h>'] = actions.preview_scrolling_left,
        ['<S-j>'] = actions.preview_scrolling_down,
        ['<S-k>'] = actions.preview_scrolling_up,
        ['<S-l>'] = actions.preview_scrolling_right,
      },
    },
  },
}
