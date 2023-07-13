local telescope = require('telescope')

local helpers = require('../helpers')

local map = helpers.map

telescope.setup {
  defaults = {file_ignore_patterns = {"node_modules"}}
}
map('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>')
map('n', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<cr>')
map('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>')
map('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>')

telescope.load_extension('fzf')
