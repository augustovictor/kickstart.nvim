-- Custom Tokyonight colorscheme configuration
-- IntelliJ-inspired color scheme with custom syntax highlighting

return {
  'folke/tokyonight.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('tokyonight').setup {
      style = 'night',
      styles = {
        -- Your legacy config had almost no italics, so we disable them here
        comments = { italic = false },
        keywords = { italic = false },
        functions = { italic = false },
        variables = { italic = false },
        sidebars = 'normal',
        floats = 'normal',
      },
      on_colors = function(colors)
        -- 1. Base Palette
        colors.bg = '#2b2b2b' -- Editor Background
        colors.fg = '#a9b7c6' -- Main Text
        colors.bg_dark = '#2b2b2b'

        -- 2. Sidebar Specific (IntelliJ Classic Tool Window Grey)
        colors.bg_sidebar = '#313335'
        -- colors.bg_float = '#3c3f41' -- Slightly lighter for documentation popups

        -- 3. Syntax Colors
        colors.orange = '#CC7833'
        colors.green = '#6A8759'
        colors.yellow = '#FBC862'
        colors.purple = '#9876AA'
        colors.blue = '#769AA5'
        colors.comment = '#808080'
      end,

      on_highlights = function(hl, c)
        -- Editor Overrides
        hl.Normal = { bg = c.bg, fg = c.fg }
        hl.CursorLine = { bg = '#323232' }
        hl.Visual = { bg = '#214283' }
        hl.LineNr = { fg = '#888888', bg = '#323232' } -- Matches the gutter to the sidebar tone
        hl.SignColumn = { bg = '#323232' }

        -- Syntax Overrides
        hl['@keyword'] = { fg = c.orange }
        hl['@function'] = { fg = c.yellow }
        hl['@string'] = { fg = c.green }
        hl['@comment'] = { fg = c.comment }
        hl['@variable'] = { fg = c.fg }
        hl['@constant'] = { fg = c.purple }
        hl['@property'] = { fg = c.purple }
        hl['@type'] = { fg = c.orange }

        ---------------------------------------------------------
        -- SIDEBAR CONFIGURATION (IntelliJ Style)
        ---------------------------------------------------------

        -- 1. Backgrounds (Forces the gray tool-window look)
        hl.NeoTreeNormal = { bg = c.bg_sidebar, fg = c.fg }
        hl.NeoTreeNormalNC = { bg = c.bg_sidebar, fg = c.fg }
        hl.NvimTreeNormal = { bg = c.bg_sidebar, fg = c.fg }

        -- 2. Folders & Files
        hl.NeoTreeRootName = { fg = c.fg, bold = true }
        hl.NeoTreeDirectoryName = { fg = c.fg } -- IntelliJ folders are standard grey
        hl.NeoTreeDirectoryIcon = { fg = c.fg }

        -- 3. Active File Highlighting
        -- IntelliJ highlights the currently open file with a different background or bold text
        hl.NeoTreeFileNameOpened = { fg = c.fg, bold = true }
        -- If you want the background highlight style:
        hl.NeoTreeCursorLine = { bg = '#0d293e' }

        -- 4. Git Status Colors (Matching IntelliJ)
        hl.NeoTreeGitAdded = { fg = c.green }
        hl.NeoTreeGitConflict = { fg = c.orange }
        hl.NeoTreeGitDeleted = { fg = c.comment }
        hl.NeoTreeGitIgnored = { fg = c.comment }
        hl.NeoTreeGitModified = { fg = c.orange, bold = true }
        hl.NeoTreeGitUntracked = { fg = c.orange }

        -- 5. Window Separator
        hl.WinSeparator = { fg = '#555555', bg = c.bg_sidebar }
      end,
    }
    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    vim.cmd.colorscheme 'tokyonight-night'
  end,
}
