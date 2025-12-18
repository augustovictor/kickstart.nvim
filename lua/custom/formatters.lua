-- Custom formatter configurations for Conform
-- This file contains formatter customizations that extend Kickstart's defaults

return {
  formatters_by_ft = {
    lua = { 'stylua' },
    terraform = { 'terraform' },
    json = { 'jq' },
    tf = { 'terraform' },
    hcl = { 'hclfmt' },
    yml = { 'yamlfmt' },
    yaml = { 'yamlfmt' },
    k8s_yaml = { 'kubeconform' },
    python = { 'isort', 'black' },
  },

  formatters = {
    jq = {
      command = 'jq',
      args = { '.', '$FILENAME' },
      stdin = true,
    },
    kubeconform = {
      command = 'kubeconform',
      args = {
        '--strict',
        '--ignore-missing-schemas',
        '--schema-location',
        'default',
        '--output',
        'json',
        '$FILENAME',
      },
      stdin = true,
    },
    terraform = {
      command = 'terraform',
      args = { 'fmt', '-' },
      stdin = true,
    },
    hclfmt = {
      command = 'hclfmt',
      stdin = true,
    },
  },
}
