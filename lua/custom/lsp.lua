-- Custom LSP server configurations
-- This file contains LSP server customizations that extend Kickstart's defaults

return {
  servers = {
    -- Python
    pyright = {},

    -- Terraform
    terraformls = {
      filetypes = { 'terraform', 'tf', 'hcl' },
    },

    -- Lua
    lua_ls = {
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
    },
  },

  -- Additional tools to install via Mason
  ensure_installed = {
    'stylua', -- Used to format Lua code
    'terraform',
    'terraform-ls',
    'yamlfmt',
    'black', -- Used to format Python code
    'isort', -- Used to sort imports in Python code
  },
}
