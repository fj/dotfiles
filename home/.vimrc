set nocompatible

" Pathogen
call pathogen#infect()
call pathogen#helptags()

set statusline=%<\ %n:%f\ %m%r%y%=%20.(%l/%L\ @\ %c%V\ (%P)%)
filetype plugin indent on

" Use /tmp for backup directories.
set backupdir=/tmp
set directory=/tmp

" Use ~/.vim for viminfo.
set viminfo+=n~/.vim/viminfo

syntax on
set mouse=a
set number
set hlsearch!
set showmatch
set incsearch
set nowrap
set autoindent
set history=1000
if has("unnamedplus")
  set clipboard=unnamedplus
elseif has("clipboard")
  set clipboard=unnamed
endif

set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2

" Nerdtree
" autocmd vimenter * NERDTree
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=0
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.pyc','\~$','\.swo$','\.swp$','\.git','\.hg','\.svn','\.bzr']
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0
map <F12> :NERDTreeToggle<CR>
map <S-F12> :NERDTreeFind<CR>

" ==========================================
" Use vim tabs with 'vim -p ...'.
" :tabnew -- new tab
" :tabn   -- next tab
" :tabp   -- previous tab
" :tabc   -- close tab
nmap <C-H> :tabprev<CR>
nmap <C-L> :tabnext<CR>

" Put trailing whitespace in red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

" Ruby autocompletion
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_use_bundler = 1

colorscheme Tomorrow-Night-Bright
if &diff
  colorscheme desert256
endif
