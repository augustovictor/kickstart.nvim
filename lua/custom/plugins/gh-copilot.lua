return -- Example using Lazy.nvim
{
  'github/copilot.vim',
  config = function()
    -- Set delay to 4000ms (4 seconds) before showing suggestions
    vim.g.copilot_idle_delay = 4000
  end,
}
