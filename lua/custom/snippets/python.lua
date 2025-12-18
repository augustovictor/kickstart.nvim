local ls = require 'luasnip'
local snippet = ls.snippet
local text_node = ls.text_node
local insert_node = ls.insert_node

return {
  -- Dictionary item snippet: "key": "value"
  snippet('di', {
    text_node '"',
    insert_node(1, 'key'),
    text_node '": "',
    insert_node(2, 'value'),
    text_node '"',
    text_node ',',
  }),

  -- Dictionary item snippet with variable value (no quotes around value)
  snippet('div', {
    text_node '"',
    insert_node(1, 'key'),
    text_node '": ',
    insert_node(2, 'value'),
    text_node ',',
  }),

  -- Dictionary item with integer value
  snippet('dii', {
    text_node '"',
    insert_node(1, 'key'),
    text_node '": ',
    insert_node(2, '0'),
    text_node ',',
  }),
}
