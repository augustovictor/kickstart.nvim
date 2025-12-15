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
    -- A floating bufferline that shows the current buffer and its context
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
          local bufname = vim.api.nvim_buf_get_name(props.buf)
          local filename = vim.fn.fnamemodify(bufname, ':t')
          if filename == '' then
            filename = '[No Name]'
          end

          -- Check for duplicate filenames across all listed buffers
          local display_name = filename
          local bufs = vim.fn.getbufinfo { buflisted = 1 }
          local same_name_bufs = {}
          for _, buf in ipairs(bufs) do
            local buf_filename = vim.fn.fnamemodify(buf.name, ':t')
            if buf_filename == filename and buf.name ~= '' then
              table.insert(same_name_bufs, buf.name)
            end
          end

          -- If there are multiple buffers with the same filename, find unique suffix
          if #same_name_bufs > 1 then
            local function get_unique_path(target_path, all_paths)
              local all_parts = {}
              for _, path in ipairs(all_paths) do
                table.insert(all_parts, vim.split(path, '/', { plain = true }))
              end

              -- Find the longest common prefix across all paths
              local min_len = math.huge
              for _, parts in ipairs(all_parts) do
                min_len = math.min(min_len, #parts - 1) -- -1 to exclude filename
              end

              local common_prefix_len = 0
              for i = 1, min_len do
                local segment = all_parts[1][i]
                local all_match = true
                for j = 2, #all_parts do
                  if all_parts[j][i] ~= segment then
                    all_match = false
                    break
                  end
                end
                if all_match then
                  common_prefix_len = i
                else
                  break -- Stop at first difference
                end
              end

              -- Show from one level after the common prefix (the divergence point)
              local parts = vim.split(target_path, '/', { plain = true })
              local start_idx = common_prefix_len + 1

              -- Safety: ensure we at least show parent/filename
              if start_idx >= #parts then
                start_idx = math.max(1, #parts - 1)
              end

              return table.concat(vim.list_slice(parts, start_idx, #parts), '/')
            end

            display_name = get_unique_path(bufname, same_name_bufs)
          end

          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          local res = {
            ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or '',
            ' ',
            { display_name, gui = modified and 'bold,italic' or 'bold' },
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
