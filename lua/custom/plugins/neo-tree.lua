-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- This is a merged configuration combining Kickstart's base and custom modifications

local function copy_path(state)
  -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
  -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
  local node = state.tree:get_node()
  if not node or not node.id then
    vim.notify('No node selected.', vim.log.levels.WARN)
    return
  end

  if vim.fn.has 'clipboard' == 0 then
    vim.notify('System clipboard is not available.', vim.log.levels.ERROR)
    return
  end

  local filepath = node:get_id()
  local filename = node.name
  local modify = vim.fn.fnamemodify

  local choices = {
    { label = 'Absolute path', value = filepath },
    { label = 'Path relative to CWD', value = modify(filepath, ':.') },
    { label = 'Path relative to HOME', value = modify(filepath, ':~') },
    { label = 'Filename', value = filename },
    { label = 'Filename without extension', value = modify(filename, ':r') },
    { label = 'Extension of the filename', value = modify(filename, ':e') },
  }

  vim.ui.select(choices, {
    prompt = 'Choose to copy to clipboard:',
    format_item = function(item)
      return string.format('%-30s %s', item.label, item.value)
    end,
  }, function(choice)
    if not choice then
      vim.notify('Copy cancelled.', vim.log.levels.INFO)
      return
    end

    local value_to_copy = choice.value

    vim.fn.setreg('+', value_to_copy)
    vim.notify('Copied to clipboard: ' .. value_to_copy)
  end)
end

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['Y'] = copy_path,
          ['ga'] = 'git_add_file',
          ['gu'] = 'git_unstage_file',
          ['gc'] = 'git_commit',
          ['gp'] = 'git_push',
          -- Disable conflicting default keymaps
          ['S'] = 'none',
          ['H'] = 'none',
          -- Add preview scroll mappings
          -- Vertical: Negative direction = scroll down (forward), Positive = scroll up (backward)
          ['<S-j>'] = { 'scroll_preview', config = { direction = -10 } },
          ['<S-k>'] = { 'scroll_preview', config = { direction = 10 } },
          -- Horizontal: Shift+H (left), Shift+L (right)
          ['<S-h>'] = { 'scroll_preview', config = { direction = 10, axis = 'horizontal' } },
          ['<S-l>'] = { 'scroll_preview', config = { direction = -10, axis = 'horizontal' } },
        },
      },
      follow_current_file = {
        enabled = true,
      },
    },
  },
  config = function(_, opts)
    require('neo-tree').setup(opts)

    -- Custom keybindings for Telescope integration
    vim.keymap.set('n', '<leader>ff', function()
      local state = require('neo-tree.sources.manager').get_state 'filesystem'
      ---@diagnostic disable-next-line: undefined-field
      local node = state.tree:get_node()
      local path = node.type == 'directory' and node.path or node:get_parent_id()

      require('telescope.builtin').find_files {
        cwd = path,
        file_sorter = require('telescope.sorters').get_fuzzy_file,
      }
    end, { desc = '[F]ind [F]iles from neo-tree node' })

    vim.keymap.set('n', '<leader>fg', function()
      local state = require('neo-tree.sources.manager').get_state 'filesystem'
      ---@diagnostic disable-next-line: undefined-field
      local node = state.tree:get_node()
      local path = node.type == 'directory' and node.path or node:get_parent_id()

      require('telescope.builtin').live_grep { cwd = path }
    end, { desc = '[F]ind by [G]rep from neo-tree node' })
  end,
}
