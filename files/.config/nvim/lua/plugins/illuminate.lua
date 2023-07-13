local helpers = require('../helpers')

local map = helpers.map
map('n', '<a-n>', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>')
map('n', '<a-p>', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>')
