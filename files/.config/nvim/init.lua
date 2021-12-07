-- neovim config
-- github.com/jheretic/dotfiles
-------------------- HELPERS -------------------------------
local cmd, fn, g, api = vim.cmd, vim.fn, vim.g, vim.api

local helpers = require('helpers')
local opt, map = helpers.opt, helpers.map

-------------------- PLUGINS -------------------------------
local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git',
        install_path
    })
end

require 'paq' {
    'saveq/paq-nvim', 'neovim/nvim-lspconfig', 'williamboman/nvim-lsp-installer', 'glepnir/lspsaga.nvim',
    'hrsh7th/nvim-compe', 'kosayoda/nvim-lightbulb',
    'onsails/lspkind-nvim',
    'mhartington/formatter.nvim', 'RRethy/vim-illuminate',
    'simrat39/rust-tools.nvim', 'hrsh7th/vim-vsnip', 'hrsh7th/vim-vsnip-integ',
    'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim', 'folke/trouble.nvim',
    'lambdalisue/nerdfont.vim', 'lambdalisue/glyph-palette.vim',
    'lambdalisue/fern.vim', 'antoinemadec/FixCursorHold.nvim',
    'lambdalisue/fern-renderer-nerdfont.vim', 'lambdalisue/fern-git-status.vim',
    'tpope/vim-fugitive', 'tpope/vim-rhubarb', 'rbong/vim-flog',
    'mhinz/vim-signify', 'moll/vim-bbye', 'aymericbeaumet/vim-symlink',
    'Raimondi/delimitMate', 'machakann/vim-sandwich', 'tpope/vim-commentary',
    'tpope/vim-sleuth', 'editorconfig/editorconfig-vim',
    'mfussenegger/nvim-dap',
    {'nvim-treesitter/nvim-treesitter', run = fn['TSUpdate']},
    'nvim-treesitter/completion-treesitter', 'theHamsta/nvim-dap-virtual-text',
    'christoomey/vim-tmux-navigator', 'roxma/vim-tmux-clipboard',
    'glepnir/galaxyline.nvim', 'kyazdani42/nvim-web-devicons',
    'akinsho/nvim-bufferline.lua', 'karb94/neoscroll.nvim',
    {'wfxr/minimap.vim', run = 'cargo install --locked code-minimap'},
    'sainnhe/sonokai', 'sainnhe/artify.vim', 'tjdevries/colorbuddy.nvim',
    'jeffkreeftmeijer/vim-numbertoggle', 'mhinz/vim-startify',
    'tpope/vim-obsession', 'jdhao/better-escape.vim',
    'glepnir/indent-guides.nvim', 'ahmedkhalf/lsp-rooter.nvim',
    'famiu/bufdelete.nvim', 'famiu/nvim-reload'
}

-------------------- PLUGIN SETUP --------------------------
-- lsp
require('lsp_config')

-- nvim-compe
opt('o', 'completeopt', 'menuone,noselect')
require'compe'.setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = 'enable',
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,

    source = {
        path = true,
        buffer = true,
        calc = true,
        vsnip = true,
        nvim_lsp = true,
        nvim_lua = true,
        spell = true,
        tags = true,
        snippets_nvim = true,
        treesitter = true
    }
}

api.nvim_exec([[
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'mode': '' })
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
]], true)

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif vim.fn.call("vsnip#available", {1}) == 1 then
        return t "<Plug>(vsnip-expand-or-jump)"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn['compe#complete']()
    end
end
_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
        return t "<Plug>(vsnip-jump-prev)"
    else
        return t "<S-Tab>"
    end
end

map("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- treesitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "language", or a list of languages
    highlight = {
        enable = true -- false will disable the whole extension
        -- disable = { "c", "rust" },  -- list of language that will be disabled
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm"
        }
    }
}

-- minimap
map('n', '<Down>', '<cmd>MinimapToggle<CR>')

-- fern
map('n', '<Up>', '<cmd>Fern . -drawer -toggle<CR>')
api.nvim_exec([[
let g:fern#renderer = "nerdfont"
augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType startify call glyph_palette#apply()
augroup END

function! InitFern() abort
  " Open node with 'o'
  nmap <buffer> o <Plug>(fern-action-open)

  " Add any code to customize fern buffer
  setlocal nonumber
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call InitFern()
augroup END
]], true)

-- vim-signify
opt('o', 'updatetime', 100)

-- telescope
require('telescope').setup {
    defaults = {file_ignore_patterns = {"node_modules"}}
}
map('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>')
map('n', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<cr>')
map('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>')
map('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>')

-- trouble
map('n', '<leader>xx', '<cmd>Trouble<cr>')
map('n', '<leader>xw', '<cmd>Trouble lsp_workspace_diagnostics<cr>')
map('n', '<leader>xd', '<cmd>Trouble lsp_document_diagnostics<cr>')
map('n', '<leader>xl', '<cmd>Trouble loclist<cr>')
map('n', '<leader>xq', '<cmd>Trouble quickfix<cr>')
map('n', 'gR', '<cmd>Trouble lsp_references<cr>')

-- nvim-dap
g.dap_virtual_text = 0
g.hap_virtual_text = 1
g.dap_virtual_text = 'all frames'

-- better-escape
g.better_escape_interval = 200
g.better_escape_shortcut = 'jj'

-- indent guides
require('indent_guides').setup()

-- nvim-bufferline
require('bufferline').setup({
    options = {diagnostics = "nvim_lsp", separator_style = "thin"}
})

-- FixCursorHold
g.cursorhold_updatetime = 100

-- Neoscroll
require('neoscroll').setup()

-- formatter.nvim
function eslint()
    return {
        exe = "eslint_d",
        args = {
            "--stdin-filename", vim.api.nvim_buf_get_name(0), "--stdin",
            "--fix-to-stdout"
        },
        stdin = true
    }
end
function prettier()
    return {
        exe = "prettier",
        args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
        stdin = true
    }
end
require('formatter').setup({
    logging = false,
    filetype = {
        javascript = {eslint},
        javascriptreact = {eslint},
        typescript = {eslint},
        typescriptreact = {eslint},
        json = {prettier},
        markdown = {prettier},
        css = {prettier},
        scss = {prettier},
        html = {prettier},
        yaml = {prettier},
        ruby = {
            function()
                -- Rufo
                return {
                    exe = "rufo",
                    args = {"--filename", vim.api.nvim_buf_get_name(0)},
                    stdin = true
                }
            end
        },
        rust = {
            -- Rustfmt
            function()
                return {exe = "rustfmt", args = {"--emit=stdout"}, stdin = true}
            end
        },
        lua = {
            -- lua-format
            function()
                return {
                    exe = "lua-format",
                    -- args = {"--indent-count", 2, "--stdin"},
                    stdin = true
                }
            end
        }
    }
})

vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.jsx,*.ts,*.tsx,*.mjs,*.rs,*.lua,*.json,*.md,*.html,*.css,*.scss,*.yaml,*.yml,*.rb FormatWrite
augroup END
]], true)

-------------------- THEME ---------------------------------
-- colorscheme
g.sonokai_style = 'shusia'
g.sonokai_enable_italic = 1
g.sonokai_disable_italic_comment = 0
g.sonokai_transparent_background = 1
g.sonokai_diagnostic_line_highlight = 1
cmd 'colorscheme sonokai'

-- line
require('slantline')

-------------------- OPTIONS -------------------------------
local indent = 2
local width = 80

opt('b', 'expandtab', true) -- Use spaces instead of tabs
opt('b', 'formatoptions', 'tcrqnj') -- Automatic formatting options
opt('b', 'shiftwidth', indent) -- Size of an indent
opt('b', 'smartindent', true) -- Insert indents automatically
opt('b', 'tabstop', indent) -- Number of spaces tabs count for
opt('b', 'textwidth', width) -- Maximum width of text
opt('o', 'completeopt', 'menuone,noinsert,noselect') -- Completion options
opt('o', 'clipboard', 'unnamed,unnamedplus') -- Completion options
opt('o', 'inccommand', 'split')
opt('o', 'hidden', true) -- Enable background buffers
opt('o', 'ignorecase', true) -- Ignore case
opt('o', 'joinspaces', false) -- No double spaces with join
opt('o', 'pastetoggle', '<F2>') -- Paste mode
opt('o', 'scrolloff', 4) -- Lines of context
opt('o', 'shiftround', true) -- Round indent
opt('o', 'sidescrolloff', 8) -- Columns of context
opt('o', 'smartcase', true) -- Don't ignore case with capitals
opt('o', 'splitbelow', true) -- Put new windows below current
opt('o', 'splitright', true) -- Put new windows right of current
opt('o', 'termguicolors', true) -- True color support
opt('o', 'updatetime', 200) -- Delay before swap file is saved
opt('o', 'wildmode', 'list:longest') -- Command-line completion mode
opt('o', 'wildignore', 'node_modules/*,.git/*') -- Files to skip
opt('o', 'autoread', true) -- Auto-reload files on changes
opt('o', 'mouse', 'a') -- Add mouse support
opt('w', 'colorcolumn', tostring(width)) -- Line length marker
opt('w', 'cursorline', true) -- Highlight cursor line
opt('w', 'list', true) -- Show some invisible characters
opt('w', 'number', true) -- Show line numbers
opt('w', 'relativenumber', true) -- Relative line numbers
opt('w', 'signcolumn', 'yes') -- Show sign column
opt('w', 'wrap', false) -- Disable line wrap

-- new tagfunc
cmd("set tagfunc=v:lua.vim.lsp.tagfunc")

-------------------- MAPPINGS ------------------------------
-- map('', '<leader>c', '"+y')
-- map('i', '<C-u>', '<C-g>u<C-u>')
-- map('i', '<C-w>', '<C-g>u<C-w>')
-- map('n', '<C-l>', '<cmd>noh<CR>')
map('n', '<F3>', '<cmd>lua ToggleWrap()<CR>')
map('n', '<F4>', '<cmd>set spell!<CR>')
-- map('n', '<F5>', '<cmd>checkt<CR>')
-- map('n', '<F6>', '<cmd>set scb!<CR>')
-- map('n', '<F9>', '<cmd>Lexplore<CR>')
-- map('n', '<leader><Down>', '<cmd>cclose<CR>')
-- map('n', '<leader><Left>', '<cmd>cprev<CR>')
-- map('n', '<leader><Right>', '<cmd>cnext<CR>')
-- map('n', '<leader><Up>', '<cmd>copen<CR>')
-- map('n', '<leader>i', '<cmd>conf qa<CR>')
-- map('n', '<leader>o', 'm`o<Esc>``')
-- map('n', '<leader>u', '<cmd>update<CR>')
-- map('n', '<leader>w', '<cmd>lua CloseBuffer()<CR>')
map('n', '<C-c>', '<cmd>lua CloseBuffer()<CR>')
map('n', 'Q', '<cmd>lua WarnCapsLock()<CR>')
map('n', 'U', '<cmd>lua WarnCapsLock()<CR>')
-- map('n', '<leader>s', '<cmd>%s//gcI<Left><Left><Left><Left>')
-- map('v', '<leader>s', '<cmd>s//gcI<Left><Left><Left><Left>')
-- tabs
map('n', '<right>', '<cmd>BufferLineCycleNext<CR>')
map('n', '<left>', '<cmd>BufferLineCyclePrev<CR>')
map('n', '<A-right>', '<cmd>BufferLineMoveNext<CR>')
map('n', '<A-left>', '<cmd>BufferLineMovePrev<CR>')
map('n', '<S-right>', '<cmd>tabn<CR>')
map('n', '<S-left>', '<cmd>tabp<CR>')
map('n', '<C-t>', '<cmd>tabnew<CR>')
map('i', '<C-t>', '<ESC><cmd>tabnew<CR>')

-------------------- WINDOWS -------------------------------
-- Don't know how to port this function to lua yet
api.nvim_exec([[
function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

map <silent> <C-w>h :call WinMove('h')<CR>
map <silent> <C-w>j :call WinMove('j')<CR>
map <silent> <C-w>k :call WinMove('k')<CR>
map <silent> <C-w>l :call WinMove('l')<CR>
]], true)

-------------------- COMMANDS ------------------------------
function CloseBuffer()
    if #fn.getbufinfo('')[1]['windows'] > 1 then
        cmd 'Bdelete';
        return
    end
    local buflisted = fn.getbufinfo {buflisted = 1}
    local last_bufnr = buflisted[#buflisted]['bufnr']
    if fn.bufnr '' == last_bufnr then
        cmd 'bp'
    else
        cmd 'bn'
    end
    cmd 'Bdelete #'
end

function ToggleWrap()
    opt('w', 'breakindent', not vim.wo.breakindent)
    opt('w', 'linebreak', not vim.wo.linebreak)
    opt('w', 'wrap', not vim.wo.wrap)
end

function WarnCapsLock()
    cmd 'echohl WarningMsg'
    cmd 'echo "Caps Lock may be on"'
    cmd 'echohl None'
end

cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false, timeout = 200}'
cmd 'au TextYankPost * if v:event.operator is "y" && v:event.regname is "+" | call YankOSC52(getreg("+")) | endif'
-- cmd 'au FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != "c" | checktime | endif'
cmd 'au FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None'

-- Go to last known cursor position when opening a file
vim.api.nvim_exec(
    [[autocmd! BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]],
    false)
