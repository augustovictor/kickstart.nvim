return {
  'petertriho/nvim-scrollbar',
  event = 'VeryLazy',
  dependencies = {
    {
      'kevinhwang91/nvim-hlslens',
      config = function()
        require('hlslens').setup {
          build_position_cb = function(plist, _, _, _)
            require('scrollbar.handlers.search').handler.show(plist.start_pos)
          end,
        }

        -- Hide search marks when leaving command line
        vim.api.nvim_create_autocmd('CmdlineLeave', {
          callback = function()
            require('scrollbar.handlers.search').handler.hide()
          end,
        })
      end,
    },
  },
  config = function()
    require('scrollbar').setup {
      show = true,
      show_in_active_only = false,
      set_highlights = true,
      handle = {
        color = '#5a5a5a',
        blend = 30,
      },
      marks = {
        Cursor = {
          text = '•',
          priority = 0,
          highlight = 'Normal',
        },
        Search = {
          text = { '-', '=' },
          priority = 1,
          highlight = 'Search',
        },
        Error = { color = '#db4b4b' },
        Warn = { color = '#e0af68' },
        Info = { color = '#0db9d7' },
        Hint = { color = '#1abc9c' },
        Misc = { color = '#9d7cd8' },
      },
      excluded_filetypes = {
        'neo-tree',
        'terminal',
        'floaterm',
        'prompt',
        'TelescopePrompt',
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true,
        handle = true,
        search = true,
      },
    }

    -- Enable gitsigns integration
    require('scrollbar.handlers.gitsigns').setup()
  end,
}
