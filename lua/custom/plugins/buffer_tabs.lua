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
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            text_align = 'left',
            separator = true,
          },
        },
        custom_filter = function(buf, _)
          -- Hide empty, unmodified buffers (like the initial [No Name] buffer)
          if
            vim.fn.bufname(buf) == ''
            and vim.api.nvim_get_option_value('buftype', { buf = buf }) == ''
            and not vim.api.nvim_get_option_value('modified', { buf = buf })
          then
            return false
          end
          return true
        end,
      },
    }
  end,
}
