" ========================================
" Minimal .vimrc
" ========================================

" --- General Settings ---
set fenc=utf-8              " Encoding
set nobackup                " Do not create backup files
set noswapfile              " Do not create swap files
set autoread                " Automatically reload file when changed outside
set showcmd                 " Show partial commands in status line
set hidden                  " Allow background buffers
set backspace=indent,eol,start " Smart backspace

" --- Appearance ---
set number                  " Show line numbers
syntax on                   " Enable syntax highlighting
set cursorline              " Highlight current line
set laststatus=2            " Always show status line
set showmatch               " Show matching bracket
set visualbell              " Use visual bell instead of beep

" --- Search ---
set ignorecase              " Ignore case in search
set smartcase               " ...unless search contains uppercase
set incsearch               " Show search results as you type
set hlsearch                " Highlight search results

" --- Indentation ---
set expandtab               " Use spaces instead of tabs
set tabstop=4               " Tab width
set shiftwidth=4            " Indent width
set softtabstop=4           " Interoperability
set autoindent              " Copy indent from current line
set smartindent             " Smart autoindenting

" --- Key Bindings ---
" Exit insert mode with 'jj'
inoremap jj <Esc>

" Clear highlight with Esc
nnoremap <Esc><Esc> :nohlsearch<CR>
