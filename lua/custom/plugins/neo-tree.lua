return {
  'nvim-neo-tree/neo-tree.nvim',
  config = function(_, opts)
    -- Disable default keymaps
    opts.window = opts.window or {}
    opts.window.mappings = opts.window.mappings or {}
    opts.window.mappings['S'] = 'none'
    opts.window.mappings['H'] = 'none'

    -- Add preview scroll mappings
    -- Vertical: Negative direction = scroll down (forward), Positive = scroll up (backward)
    opts.window.mappings['<S-j>'] = { 'scroll_preview', config = { direction = -10 } }
    opts.window.mappings['<S-k>'] = { 'scroll_preview', config = { direction = 10 } }
    -- Horizontal: Shift+H (left), Shift+L (right)
    opts.window.mappings['<S-h>'] = { 'scroll_preview', config = { direction = 10, axis = 'horizontal' } }
    opts.window.mappings['<S-l>'] = { 'scroll_preview', config = { direction = -10, axis = 'horizontal' } }

    require('neo-tree').setup(opts)

    vim.keymap.set('n', '<leader>ff', function()
      local state = require('neo-tree.sources.manager').get_state 'filesystem'
      ---@diagnostic disable-next-line: undefined-field
      local node = state.tree:get_node()
      local path = node.type == 'directory' and node.path or node:get_parent_id()

      require('telescope.builtin').find_files {
        cwd = path,
        file_sorter = require('telescope.sorters').get_fuzzy_file,
      }
    end)

    vim.keymap.set('n', '<leader>fg', function()
      local state = require('neo-tree.sources.manager').get_state 'filesystem'
      ---@diagnostic disable-next-line: undefined-field
      local node = state.tree:get_node()
      local path = node.type == 'directory' and node.path or node:get_parent_id()

      require('telescope.builtin').live_grep { cwd = path }
    end)
  end,
}
