return {
  {
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
  },
  {
    'SmiteshP/nvim-navic',
    lazy = true,
    init = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('navic-lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentSymbolProvider then
            require('nvim-navic').attach(client, event.buf)
          end
        end,
      })
    end,
    opts = {
      separator = ' > ',
      highlight = true,
      depth_limit = 0,
      depth_limit_indicator = '..',
      safe_output = true,
    },
  },
  {
    'b0o/incline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'SmiteshP/nvim-navic' },
    event = 'VeryLazy',
    config = function()
      local helpers = require 'incline.helpers'
      local navic = require 'nvim-navic'
      local devicons = require 'nvim-web-devicons'
      require('incline').setup {
        window = {
          padding = 0,
          margin = { horizontal = 0, vertical = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          if filename == '' then
            filename = '[No Name]'
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          local res = {
            ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or '',
            ' ',
            { filename, gui = modified and 'bold,italic' or 'bold' },
            guibg = '#44406e',
          }
          if props.focused then
            for _, item in ipairs(navic.get_data(props.buf) or {}) do
              table.insert(res, {
                { ' > ', group = 'NavicSeparator' },
                { item.icon, group = 'NavicIcons' .. item.type },
                { item.name, group = 'NavicText' },
              })
            end
          end
          table.insert(res, ' ')
          return res
        end,
      }
    end,
  },
}
