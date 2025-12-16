return {
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    {
      '<leader>o',
      function()
        vim.ui.select({
          '[n] New Note',
          '[s] Quick Switch',
          '[f] Search',
          '[t] Today',
          '[y] Yesterday',
          '[m] Tomorrow',
          '[o] Open in Obsidian',
          '[p] Paste Image',
          '[c] Toggle Checkbox',
          '[l] Follow Link',
          '[w] Switch Workspace',
        }, {
          prompt = 'Obsidian:',
          format_item = function(item)
            return item
          end,
        }, function(choice)
          if not choice then
            return
          end
          local commands = {
            ['[n] New Note'] = 'ObsidianNew',
            ['[s] Quick Switch'] = 'ObsidianQuickSwitch',
            ['[f] Search'] = 'ObsidianSearch',
            ['[t] Today'] = 'ObsidianToday',
            ['[y] Yesterday'] = 'ObsidianYesterday',
            ['[m] Tomorrow'] = 'ObsidianTomorrow',
            ['[o] Open in Obsidian'] = 'ObsidianOpen',
            ['[p] Paste Image'] = 'ObsidianPasteImg',
            ['[c] Toggle Checkbox'] = function()
              require('obsidian').util.toggle_checkbox()
            end,
            ['[l] Follow Link'] = 'ObsidianFollowLink',
            ['[w] Switch Workspace'] = 'ObsidianWorkspace',
          }
          local cmd = commands[choice]
          if type(cmd) == 'function' then
            cmd()
          else
            vim.cmd(cmd)
          end
        end)
      end,
      desc = '[O]bsidian commands',
    },
    -- Direct keymaps for quick access
    { '<leader>on', '<cmd>ObsidianNew<cr>', desc = 'Obsidian: [N]ew Note' },
    { '<leader>os', '<cmd>ObsidianQuickSwitch<cr>', desc = 'Obsidian: Quick [S]witch' },
    { '<leader>of', '<cmd>ObsidianSearch<cr>', desc = 'Obsidian: Search [F]ind' },
    { '<leader>ot', '<cmd>ObsidianToday<cr>', desc = 'Obsidian: [T]oday' },
    { '<leader>oy', '<cmd>ObsidianYesterday<cr>', desc = 'Obsidian: [Y]esterday' },
    { '<leader>om', '<cmd>ObsidianTomorrow<cr>', desc = 'Obsidian: To[m]orrow' },
    { '<leader>oo', '<cmd>ObsidianOpen<cr>', desc = 'Obsidian: [O]pen in app' },
    { '<leader>op', '<cmd>ObsidianPasteImg<cr>', desc = 'Obsidian: [P]aste Image' },
    { '<leader>ow', '<cmd>ObsidianWorkspace<cr>', desc = 'Obsidian: Switch [W]orkspace' },
  },
  opts = {
    workspaces = {
      {
        name = 'personal',
        path = '/Users/victoraugusto/Documents/Obsidian Vault/AAAGitVault',
        overrides = {
          templates = {
            folder = '/Users/victoraugusto/Documents/Obsidian Vault/AAAGitVault/templates',
          },
          daily_notes = {
            folder = 'AAAGitVault/_ME/daily',
            date_format = '%Y-%m-%d',
            alias_format = '%B %-d, %Y',
            default_tags = { 'daily-notes' },
            template = 'default.md',
          },
        },
      },
      {
        name = 'work',
        path = '/Users/victoraugusto/Documents/Obsidian Vault/WorkVault',
        overrides = {
          templates = {
            folder = '/Users/victoraugusto/Documents/Obsidian Vault/AAAGitVault/templates',
            default = 'daily-work.md',
          },
          daily_notes = {
            folder = 'WorkVault/daily',
            date_format = '%Y-%m-%d',
            alias_format = '%B %-d, %Y',
            default_tags = { 'daily-notes', 'work' },
            template = 'daily-work.md',
          },
        },
      },
    },

    notes_subdir = 'notes',

    daily_notes = {
      folder = 'notes/dailies',
      date_format = '%Y-%m-%d',
      alias_format = '%B %-d, %Y',
      default_tags = { 'daily-notes' },
    },

    completion = {
      nvim_cmp = false, -- Using blink.cmp instead
      min_chars = 2,
    },

    mappings = {
      ['gf'] = {
        action = function()
          return require('obsidian').util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ['<leader>ch'] = {
        action = function()
          return require('obsidian').util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      ['<cr>'] = {
        action = function()
          return require('obsidian').util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },

    new_notes_location = 'notes_subdir',

    note_id_func = function(title)
      local suffix = ''
      if title ~= nil then
        suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. '-' .. suffix
    end,

    wiki_link_func = function(opts)
      return require('obsidian.util').wiki_link_id_prefix(opts)
    end,

    markdown_link_func = function(opts)
      return require('obsidian.util').markdown_link(opts)
    end,

    preferred_link_style = 'wiki',

    disable_frontmatter = false,

    note_frontmatter_func = function(note)
      if note.title then
        note:add_alias(note.title)
      end

      local out = { id = note.id, aliases = note.aliases, tags = note.tags }

      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,

    -- Default templates config (can be overridden per workspace)
    templates = {
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
    },

    follow_url_func = function(url)
      vim.fn.jobstart { 'open', url }
    end,

    follow_img_func = function(img)
      vim.fn.jobstart { 'qlmanage', '-p', img }
    end,

    use_advanced_uri = false,
    open_app_foreground = false,

    picker = {
      name = 'telescope.nvim',
      note_mappings = {
        new = '<C-x>',
        insert_link = '<C-l>',
      },
      tag_mappings = {
        tag_note = '<C-x>',
        insert_tag = '<C-l>',
      },
    },

    sort_by = 'modified',
    sort_reversed = true,

    search_max_lines = 1000,
    open_notes_in = 'current',

    ui = {
      enable = true,
      update_debounce = 200,
      max_file_length = 5000,
      checkboxes = {
        [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
        ['x'] = { char = '', hl_group = 'ObsidianDone' },
        ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
        ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
        ['!'] = { char = '', hl_group = 'ObsidianImportant' },
      },
      bullets = { char = '•', hl_group = 'ObsidianBullet' },
      external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
      reference_text = { hl_group = 'ObsidianRefText' },
      highlight_text = { hl_group = 'ObsidianHighlightText' },
      tags = { hl_group = 'ObsidianTag' },
      block_ids = { hl_group = 'ObsidianBlockID' },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = '#f78c6c' },
        ObsidianDone = { bold = true, fg = '#89ddff' },
        ObsidianRightArrow = { bold = true, fg = '#f78c6c' },
        ObsidianTilde = { bold = true, fg = '#ff5370' },
        ObsidianImportant = { bold = true, fg = '#d73128' },
        ObsidianBullet = { bold = true, fg = '#89ddff' },
        ObsidianRefText = { underline = true, fg = '#c792ea' },
        ObsidianExtLinkIcon = { fg = '#c792ea' },
        ObsidianTag = { italic = true, fg = '#89ddff' },
        ObsidianBlockID = { italic = true, fg = '#89ddff' },
        ObsidianHighlightText = { bg = '#75662e' },
      },
    },

    attachments = {
      img_folder = 'assets/imgs',
      img_name_func = function()
        return string.format('%s-', os.time())
      end,
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        return string.format('![%s](%s)', path.name, path)
      end,
    },
  },
}
