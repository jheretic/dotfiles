"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin()
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-eunuch'
Plug 'bling/vim-airline'
Plug 'w0rp/ale'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'gregsexton/gitv'
Plug 'mhinz/vim-signify'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'tomasr/molokai'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'vhdirk/vim-cmake', { 'for': 'cmake' }
Plug 'vim-scripts/c.vim', { 'for': ['C', 'make'] }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'vim-scripts/bash-support.vim', { 'for': 'sh' }
Plug 'vim-scripts/doxygen-support.vim', { 'for': 'doxygen' }
Plug 'vim-scripts/lua-support', { 'for': 'lua' }
Plug 'saltstack/salt-vim', { 'for': 'sls' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' }
Plug 'deoplete-plugins/deoplete-jedi', { 'for': 'python' }
Plug 'Firef0x/PKGBUILD.vim'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'ryanoasis/vim-devicons'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin-specific settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline#extensions#tabline#enabled = 1 " Enable Airline for tabs
let g:airline#extensions#ale#enabled = 1 " Enable Airline for ALE
let g:airline_powerline_fonts = 1

let g:ale_linters = {'javascript': ['eslint'], 'javascriptreact': ['eslint'], 'rust': ['rustfmt'], 'C': ['cppcheck', 'flawfinder'], 'go': ['gofmt'], 'python': ['black', 'yapf'], 'json': ['prettier'], 'markdown': ['prettier'], 'html': ['prettier'], 'sh': ['shfmt'] }
let g:ale_fixers = {
    \ '*': [ 'remove_trailing_lines', 'trim_whitespace'],
    \ 'javascript': ['eslint'],
    \ 'javascriptreact': ['eslint'],
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

let g:ale_python_auto_pipenv = 1

let g:BASH_MapLeader  = '\'

"let g:python_host_prog = '~/.pyenv/versions/neovim2/bin/python'
"let g:python3_host_prog = '~/.pyenv/versions/neovim3/bin/python'
"let g:ruby_host_prog = system('rbenv whence --path neovim-ruby-host')
"let g:ruby_host_prog = '~/.rbenv/versions/2.6.5/bin/neovim-ruby-host'
"let g:ruby_host_prog = $NVIM_RUBY_HOST

let g:deoplete#enable_at_startup = 1 " Use deoplete
" Let <Tab> also do completion
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

" Close the documentation window when completion is done
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" LanguageServer
" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'python': ['pyls'],
    \ 'go': ['gopls'],
    \ 'C': ['ccls'],
    \ 'sh': ['bash-language-server', 'start']
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
"nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
"nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
"nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme/Colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme molokai " my theme

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Open and close the taglist.vim separately
nmap <down>  :TagbarToggle<CR>
"" Open and close netrw separately
nmap <up> :Lexplore<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Windows
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <right> <ESC>:tabn<RETURN> " right arrow (normal mode) switches buffers  (excluding minibuf)
map <left> <ESC>:tabp<RETURN> " left arrow (normal mode) switches buffers (excluding minibuf)
map <C-right> <ESC>:bn<RETURN> " right arrow (normal mode) switches buffers  (excluding minibuf)
map <C-left> <ESC>:bp<RETURN> " left arrow (normal mode) switches buffers (excluding minibuf)
" tab navigation like firefox
map <a-1> <ESC>1gt<RETURN>
map <a-2> <ESC>2gt<RETURN>
map <A-3> 3gt
map <A-4> 4gt
map <A-5> 5gt
map <A-6> 6gt
map <A-7> 7gt
map <A-8> 8gt
map <A-9> 9gt
map <A-0> 10gt
nmap <C-S-tab> :tabprevious<CR>
nmap <C-tab> :tabnext<CR>
map <C-S-tab> :tabprevious<CR>
map <C-tab> :tabnext<CR>
imap <C-S-tab> <Esc>:tabprevious<CR>i
imap <C-tab> <Esc>:tabnext<CR>i
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
set guioptions+=mTLlRrb
set guioptions-=mTLlRrb

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildignore+=node_modules/*,.git/*
