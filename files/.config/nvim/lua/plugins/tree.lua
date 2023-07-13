require('nvim-tree').setup()

local helpers = require('../helpers')

local map = helpers.map

map('n', '<Up>', '<cmd>NvimTreeToggle<CR>')
map('n', '<leader>r', '<cmd>NvimTreeRefresh<CR>')
map('n', '<leader>n', '<cmd>NvimTreeFindFile<CR>')
