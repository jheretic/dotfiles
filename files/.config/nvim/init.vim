""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plugpac#begin()

" minpac
Pack 'k-takata/minpac', {'type': 'opt'}

" lsp
Pack 'neovim/nvim-lspconfig'
Pack 'nvim-lua/completion-nvim'
Pack 'nvim-lua/diagnostic-nvim'
Pack 'weilbith/nvim-lsp-smag'
Pack 'RishabhRD/popfix'
"Pack 'RishabhRD/nvim-lsputils'
Pack 'nvim-lua/lsp-status.nvim'

" snippets
Pack 'hrsh7th/vim-vsnip'
Pack 'hrsh7th/vim-vsnip-integ'

" search
Pack 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Icons
Pack 'lambdalisue/nerdfont.vim'
Pack 'lambdalisue/glyph-palette.vim'

" Fern
Pack 'lambdalisue/fern.vim'
Pack 'antoinemadec/FixCursorHold.nvim'
Pack 'lambdalisue/fern-renderer-nerdfont.vim'
Pack 'lambdalisue/fern-git-status.vim'

" git
Pack 'tpope/vim-fugitive'
Pack 'tpope/vim-rhubarb'
Pack 'rbong/vim-flog'
Pack 'mhinz/vim-signify'
Pack 'moll/vim-bbye'
Pack 'aymericbeaumet/vim-symlink'

" formatting
Pack 'Raimondi/delimitMate'
Pack 'machakann/vim-sandwich'
Pack 'tpope/vim-commentary'
Pack 'tpope/vim-sleuth'
Pack 'editorconfig/editorconfig-vim'
Pack 'w0rp/ale'

" tmux
Pack 'christoomey/vim-tmux-navigator'

" experience
Pack 'rbong/vim-crystalline'
Pack 'nvim-treesitter/nvim-treesitter'
Pack 'psliwka/vim-smoothie'
Pack 'wfxr/minimap.vim', {'do': ':!cargo install --locked code-minimap'}
Pack 'sainnhe/sonokai'
Pack 'sainnhe/artify.vim'
Pack 'jeffkreeftmeijer/vim-numbertoggle'
Pack 'mhinz/vim-startify'
Pack 'tpope/vim-obsession'

call plugpac#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin-specific settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""
" completion-nvim & diagnostic-nvim
""""""""""""""""""""""""""""""""""""
lua <<EOF
local nvim_lsp = require('nvim_lsp')
local lsp_status = require('lsp-status')
lsp_status.register_progress()
local on_attach_vim = function(client)
  require'completion'.on_attach(client)
  require'diagnostic'.on_attach(client)
  lsp_status.on_attach(client)
  capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)
end
vim.cmd('packadd nvim-lspconfig')
nvim_lsp.bashls.setup{on_attach=on_attach_vim}
nvim_lsp.cmake.setup{on_attach=on_attach_vim}
nvim_lsp.cssls.setup{on_attach=on_attach_vim}
nvim_lsp.diagnosticls.setup{
  on_attach=on_attach_vim,
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'css', 'markdown' },
  init_options = {
    linters = {
      eslint = {
        sourceName = "eslint",
        command = "./node_modules/.bin/eslint",
        rootPatterns = { ".git" },
        debounce = 100,
        args = {
          "--stdin",
          "--stdin-filename",
          "%filepath",
          "--format",
          "json",
        },
        parseJson = {
          errorsRoot = "[0].messages",
          line = "line",
          column = "column",
          endLine = "endLine",
          endColumn = "endColumn",
          message = "${message} [${ruleId}]",
          security = "severity",
        },
        securities = {
          [2] = "error",
          [1] = "warning"
        }
      },
      markdownlint = {
        command = 'markdownlint',
        rootPatterns = { '.git' },
        isStderr = true,
        debounce = 100,
        args = { '--stdin' },
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = 'markdownlint',
        securities = {
          undefined = 'hint'
        },
        formatLines = 1,
        formatPattern = {
          '^.*:(\\d+)\\s+(.*)$',
          {
            line = 1,
            column = -1,
            message = 2,
          }
        }
      }
    },
    filetypes = {
      javascript = "eslint",
      javascriptreact = "eslint",
      typescript = "eslint",
      typescriptreact = "eslint",
      markdown = "markdownlint",
    },
    formatters = {
      eslintFix = {
        command = "./node_modules/.bin/eslint",
        rootPatterns = { ".git" },
        args = {
          "--stdin",
          "--fix",
        },
        isStderr = false,
        isStdout = true
      }
    },
    formatFiletypes = {
      javascript = 'eslintFix',
      javascriptreact = 'eslintFix',
      ['javascript.jsx'] = 'eslintFix',
      json = 'eslintFix',
      typescript = 'eslintFix',
      typescriptreact = 'eslintFix'
    }
  }
}
nvim_lsp.dockerls.setup{on_attach=on_attach_vim}
nvim_lsp.gopls.setup{on_attach=on_attach_vim}
nvim_lsp.html.setup{on_attach=on_attach_vim}
nvim_lsp.jsonls.setup{on_attach=on_attach_vim}
nvim_lsp.kotlin_language_server.setup{on_attach=on_attach_vim}
nvim_lsp.pyls.setup{on_attach=on_attach_vim}
nvim_lsp.rust_analyzer.setup{on_attach=on_attach_vim}
nvim_lsp.solargraph.setup{on_attach=on_attach_vim}
nvim_lsp.sqlls.setup{on_attach=on_attach_vim}
nvim_lsp.sumneko_lua.setup{on_attach=on_attach_vim}
nvim_lsp.tsserver.setup{on_attach=on_attach_vim}
nvim_lsp.vimls.setup{on_attach=on_attach_vim}
nvim_lsp.yamlls.setup{on_attach=on_attach_vim}
EOF

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

nmap <tab> <Plug>(completion_smart_tab)
nmap <s-tab> <Plug>(completion_smart_s_tab)

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_show_sign = 1
let g:diagnostic_sign_priority = 20
let g:diagnostic_enable_underline = 1
let g:diagnostic_virtual_text_prefix = ' '
call sign_define("LspDiagnosticsErrorSign", {"text" : "", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "", "texthl" : "LspDiagnosticsHint"})

nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>

" Auto-format files prior to saving them
augroup format
  autocmd! *
  autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 1000)
augroup END


""""""""""""""""
" nvim-lsputils
""""""""""""""""
"lua <<EOF
"vim.cmd('packadd nvim-lsputils')
"vim.cmd('packadd popfix')
"vim.lsp.callbacks['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
"vim.lsp.callbacks['textDocument/references'] = require'lsputil.locations'.references_handler
"vim.lsp.callbacks['textDocument/definition'] = require'lsputil.locations'.definition_handler
"vim.lsp.callbacks['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
"vim.lsp.callbacks['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
"vim.lsp.callbacks['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
"vim.lsp.callbacks['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
"vim.lsp.callbacks['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
"EOF

""""""""""""""""""
" nvim-treesitter
""""""""""""""""""

lua <<EOF
vim.cmd('packadd nvim-treesitter')
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",     -- one of "all", "language", or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- disable = { "c", "rust" },  -- list of language that will be disabled
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
EOF

""""""""""""""""""
" vim-crystalline
""""""""""""""""""
" these next two functions are copied straight from the lightline example for devicons

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . nerdfont#find() : 'no ft') : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? nerdfont#fileformat#find() : ''
endfunction

" Borrowed from https://github.com/maximbaz/lightline-ale
function! IsLinted() abort
  return get(g:, 'ale_enabled', 0) == 1
    \ && getbufvar(bufnr(''), 'ale_enabled', 1)
    \ && getbufvar(bufnr(''), 'ale_linted', 0) > 0
endfunction

" Statusline
function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

function! StatusLine(current, width)
  let l:s = ''

  if a:current
    let l:s .= crystalline#mode() . '%{&paste ?"| PASTE ":""}%{&spell?"| SPELL":""}' . crystalline#right_mode_sep('')
  else
    let l:s .= '%#CrystallineInactive#'
  endif
  if exists('g:loaded_fugitive')
    let l:head = fugitive#head()
    if !empty(l:head)
      let l:s .= ' %{sy#repo#get_stats_decorated()}  %{fugitive#head()} '
    endif
  endif
  if a:current
    let l:s .= crystalline#right_sep('', 'Fill')
  endif
  let l:s .= ' %f%h%w ' . ' %{(&modified) ? "" : ""}' . ' %{(&readonly || !&modifiable) ? "" : ""}'

  let l:s .= '%='
  if a:width > 80
    "let l:s .= '%{LinterStatus()} '
    let l:s .= '%{LspStatus()}'
    if a:current
      let l:s .= crystalline#left_sep('', 'Fill')
    endif
    let l:s .= ' %{MyFiletype()}  %{&fenc!=#""?&fenc:&enc} %{MyFileformat()} '
    if a:current
      let l:s .= crystalline#left_mode_sep('')
    endif
    let l:s .= ' %P ☰ %l/%L  : %c%V '
  else
    let l:s .= ' '
  endif

  return l:s
endfunction

function! TabLabel(buf, max_width)
    let [l:left, l:name, l:short_name, l:right] = crystalline#default_tablabel_parts(a:buf, a:max_width)
    return l:left . l:short_name . ' ' . nerdfont#find(expand(l:name)) . (l:right ==# ' ' ? '' : ' ') . l:right
endfunction

function! TabLine()
    let l:vimlabel = has('nvim') ?  ' ⁿᵉᵒ ' : '  '
    return crystalline#bufferline(0, 0, 1, 1, 'TabLabel', crystalline#default_tabwidth() + 3) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction

let g:crystalline_enable_sep = 1
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn = 'TabLine'
let g:crystalline_theme = 'molokai'
let g:crystalline_separators = [ "", "" ]
let g:crystalline_tab_mod = ""
let g:crystalline_tab_separator = ""

set showtabline=2
set guioptions-=e
set laststatus=2

"""""""
" fern
"""""""
let g:fern#renderer = "nerdfont"
augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType startify call glyph_palette#apply()
augroup END

function! s:init_fern() abort
  " Open node with 'o'
  nmap <buffer> o <Plug>(fern-action-open)

  " Add any code to customize fern buffer
  setlocal nonumber
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

"""""""""""""""
" vim-sandwich
"""""""""""""""
" use vim-surround keybindings
"runtime macros/sandwich/keymap/surround.vim


"""""""""""""""
" vim-signify
"""""""""""""""
set updatetime=100

""""""
" fzf
""""""
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.5, 'highlight': 'Comment' } }
let g:fzf_colors =
  \ { 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'] }

""""""
" ale
""""""
let g:ale_linters_explicit = 1
"let g:ale_linters = {'javascript': ['eslint'], 'javascriptreact': ['eslint'], 'typescript': ['eslint --ext ts,tsx'], 'rust': ['rustfmt'], 'C': ['cppcheck', 'flawfinder'], 'go': ['gofmt'], 'python': ['black', 'yapf'], 'json': ['prettier'], 'markdown': ['prettier'], 'html': ['prettier'], 'sh': ['shfmt'] }
let g:ale_fixers = {
    \ '*': [ 'remove_trailing_lines', 'trim_whitespace'],
    \ 'javascript': ['eslint'],
    \ 'javascriptreact': ['eslint'],
    \ 'typescript': ['eslint'],
    \ 'rust': ['rustfmt'],
    \ 'C': ['cppcheck', 'flawfinder'],
    \ 'go': ['gofmt'],
    \ 'python': ['black', 'yapf'],
    \ 'json': ['prettier'],
    \ 'markdown': ['prettier'],
    \ 'html': ['prettier'],
    \ 'sh': ['shfmt']
    \ }
let g:ale_fix_on_save = 1
"
let g:ale_python_auto_pipenv = 1
let g:ale_disable_lsp = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Line numbers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number relativenumber

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme/Colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('termguicolors')
  set termguicolors
endif
let g:sonokai_style = 'maia'
let g:sonokai_enable_italic = 1
let g:sonokai_disable_italic_comment = 0
let g:sonokai_transparent_background = 1

colorscheme sonokai " my theme

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Open and close the taglist.vim separately
nmap <down>  :MinimapToggle<CR>
"" Open and close netrw separately
nmap <up> :Fern . -drawer -toggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Windows
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <right> <ESC>:tabn<RETURN> " right arrow (normal mode) switches tabs
map <left> <ESC>:tabp<RETURN> " left arrow (normal mode) switches tabs
map <C-right> <ESC>:bn<RETURN> " right arrow (normal mode) switches buffers
map <C-left> <ESC>:bp<RETURN> " left arrow (normal mode) switches buffers
nmap <C-t> :tabnew<CR>
imap <C-t> <Esc>:tabnew<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Gvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set guioptions-=m  "remove menu bar
"set guioptions-=T  "remove toolbar
"set guioptions-=R  "remove right-hand scroll bar
"set guioptions-=l  "remove left-hand scroll bar
"set guioptions-=L  "remove left-hand scroll bar
"set guioptions-=b  "remove bottom scroll bar
set guioptions-=mTLlRrb
set guioptions+=mTLlRrb

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildignore+=node_modules/*,.git/*
