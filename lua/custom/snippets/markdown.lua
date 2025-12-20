local ls = require 'luasnip'
local snippet = ls.snippet
local text_node = ls.text_node

return {
  snippet('due', {
    text_node '📅 ',
  }),
  snippet('scheduled', {
    text_node '⏳ ',
  }),
}
