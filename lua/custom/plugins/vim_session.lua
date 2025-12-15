return {
  'tpope/vim-obsession',
  -- Session.vim will be saved in the current directory
  -- Start tracking: :Obsession (or :Obsession <filename>)
  -- Stop tracking: :Obsession!
  -- Auto-loads Session.vim if it exists in the current directory
  -- Auto-save happens automatically when session is active
  config = function()
    vim.cmd [[
      augroup ObsessionAuto
        autocmd!
        " Auto-load Session.vim if it exists (unless opening specific files)
        autocmd VimEnter * nested
          \ if filereadable('Session.vim') && (argc() == 0 || (argc() == 1 && isdirectory(argv(0)))) |
          \   source Session.vim |
          \ elseif argc() == 0 || (argc() == 1 && isdirectory(argv(0))) |
          \   Obsession |
          \ endif
      augroup END
    ]]
  end,
}
