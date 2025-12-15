return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    -- Enable indent guides
    indent = {
      enabled = true,
    },
    -- Enable git features
    git = {
      enabled = true,
    },
    gitbrowse = {
      enabled = true,
    },
    -- Enable notifications for better UI feedback
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    -- Enable smooth scrolling
    scroll = {
      enabled = true,
    },
    -- Enable quickfile for better performance
    quickfile = {
      enabled = true,
    },
    -- Enhanced statuscolumn with git signs
    statuscolumn = {
      enabled = true,
    },
  },
  keys = {
    {
      '<leader>gb',
      function()
        require('snacks').git.blame_line()
      end,
      desc = 'Git Blame Line',
    },
    {
      '<leader>gB',
      function()
        require('snacks').gitbrowse()
      end,
      desc = 'Git Browse',
    },
  },
}
