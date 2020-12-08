""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plugpac#begin()

" minpac
Pack 'k-takata/minpac', {'type': 'opt'}

" lsp
Pack 'neovim/nvim-lspconfig'
Pack 'nvim-lua/completion-nvim'
Pack 'weilbith/nvim-lsp-smag'
Pack 'RishabhRD/popfix'
Pack 'RishabhRD/nvim-lsputils'
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
"Pack 'w0rp/ale'

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
" completion-nvim & treesitter
""""""""""""""""""""""""""""""""""""
lua require("lsp_config")

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

nmap <tab> <Plug>(completion_smart_tab)
nmap <s-tab> <Plug>(completion_smart_s_tab)

" Set custom diagnostic signs
sign define LspDiagnosticsSignError text= texthl=LspDiagnosticsSignError linehl= numhl=
sign define LspDiagnosticsSignWarning text= texthl=LspDiagnosticsSignWarning linehl= numhl=
sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsSignInformation linehl= numhl=
sign define LspDiagnosticsSignHint text= texthl=LspDiagnosticsSignHint linehl= numhl=

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

" Set tabs to 2
set tabstop=2
set shiftwidth=2
set softtabstop=2
set noexpandtab

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
