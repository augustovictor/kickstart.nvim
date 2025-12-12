-- vim-visual-multi
return {
  'mg979/vim-visual-multi',
  init = function()
    vim.g.VM_default_mappings = 0
    vim.g.VM_maps = {
      ['Find Under'] = '<C-d>',
      ['Find Subword Under'] = '<C-d>',
      ['Select All'] = '<C-a>',
      ['Add Cursor Down'] = '<C-j>',
      ['Add Cursor Up'] = '<C-k>',
    }
    vim.g.VM_add_cursor_at_pos_no_mappings = 1
  end,
}
