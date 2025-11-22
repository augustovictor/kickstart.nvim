return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    vim.opt.termguicolors = true
    vim.o.showtabline = 2

    require('bufferline').setup {
      options = {
        mode = 'buffers', -- or "tabs"
        -- separator_style = 'slant', -- closest to IntelliJ's tab curvature
        show_buffer_close_icons = false, -- IntelliJ hides close icons until hover
        show_close_icon = false,
        diagnostics = 'nvim_lsp',
        always_show_bufferline = true,
      },
    }
  end,
}
