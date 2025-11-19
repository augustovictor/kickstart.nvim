return {
  'romgrk/barbar.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- Required for icons
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    -- Customize options here if needed
  },
}
