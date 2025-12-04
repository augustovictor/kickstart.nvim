return {
  'voldikss/vim-floaterm',
  config = function()
    vim.g.floaterm_width = 0.95
    vim.g.floaterm_height = 0.95
    vim.g.floaterm_autoinsert = false

    -- Setup keymaps for terminal buffers
    local function setup_terminal_keymaps()
      vim.keymap.set('n', '<C-h>', '<cmd>FloatermPrev<cr>', { buffer = true, desc = 'Previous terminal' })
      vim.keymap.set('n', '<C-l>', '<cmd>FloatermNext<cr>', { buffer = true, desc = 'Next terminal' })
      vim.keymap.set('n', '<C-x>', '<cmd>FloatermKill<cr>', { buffer = true, desc = 'Close terminal session' })
    end

    -- Clear terminal with cmd+k (including scrollback history)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'floaterm',
      callback = function()
        vim.keymap.set('t', '<D-k>', function()
          local keys = vim.api.nvim_replace_termcodes('clear && printf "\\e[3J"<CR>', true, false, true)
          vim.api.nvim_feedkeys(keys, 't', false)
        end, { buffer = true, desc = 'Clear terminal' })
      end,
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'floaterm',
      callback = setup_terminal_keymaps,
    })
  end,
  cmd = 'FloatermToggle',
  keys = {
    { '<leader>t', '<cmd>FloatermToggle<cr>', desc = 'Toggle floating terminal' },
    {
      '<C-\\>',
      function()
        local bufdir = vim.fn.expand '%:p:h'
        local old_cwd = vim.fn.getcwd()
        vim.cmd('cd ' .. vim.fn.fnameescape(bufdir))
        vim.cmd 'FloatermNew'
        vim.cmd('cd ' .. vim.fn.fnameescape(old_cwd))
      end,
      desc = 'Create new terminal session',
    },
  },
}
