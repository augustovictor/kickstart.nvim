-- vim-visual-multi
return {
  'mg979/vim-visual-multi',
  init = function()
    vim.g.VM_default_mappings = 0
    vim.g.VM_maps = {
      ['Find Under'] = '<C-d>',
      -- ['Find Subword Under'] = '<C-d>',
      ['Select All'] = '<C-a>',
      ['Add Cursor Down'] = '<C-S-j>',
      ['Add Cursor Up'] = '<C-S-k>',
    }
    vim.g.VM_add_cursor_at_pos_no_mappings = 1
  end,
}
