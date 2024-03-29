" .vimrc
" Jonathan Lowe
" 10/21/2018
"
" vim settings

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Non plugin settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Brings vim into this century/decade
set nocompatible

" turn absolute line numbers on
set number relativenumber
set nu rnu

" turn absolute line numbers off
"set nonumber
"set nonu

" toggle absolute line numbers
"set number!
"set nu!

" syntax hightliting
syntax on

" Enables file undo after files close
set undofile
set undodir=~/.vim/undodir

" Makes backspace to behave like most text editors
set backspace=indent,eol,start

" Deals with tab sillyness for default settings
set expandtab
set tabstop=4
set shiftwidth=4

" Search settings
set incsearch
set hlsearch

set colorcolumn=81

" Folding code defaults
set foldmethod=syntax
"set foldnestmax=1

autocmd Filetype cpp set foldmethod=indent

function! NeatFoldText() "{{{2
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()
" }}}2

augroup AutoSaveFolds
  autocmd!
  autocmd BufWinLeave * mkview
  autocmd BufWinEnter * silent! loadview
augroup END

" Changes tab settings for specific languages
autocmd Filetype sh set expandtab&
autocmd Filetype ocaml setlocal expandtab tabstop=2 shiftwidth=2
autocmd Filetype ruby setlocal expandtab tabstop=2 shiftwidth=2
autocmd Filetype vim setlocal expandtab tabstop=2 shiftwidth=2

autocmd Filetype markdown setlocal textwidth=80

function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction

" Turns tab when in a word to autocomplete
function! Tab_Or_Complete()
  if &filetype == "ocaml"
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\(\w\|\.\)'
      return pumvisible() ? "\<C-o>" : "\<C-x>\<C-o>"
    else
      return "\<Tab>"
    endif
  endif
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction

" Makes shift tab go backward through autocomplete
function! Shift_Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-p>"
  else
    return "\<Tab>"
  endif
endfunction

inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
inoremap <S-Tab> <C-R>=Shift_Tab_Or_Complete()<CR>
set complete-=i

" Sets the path to include the files in this subdirectory
set path+=**
set wildmenu

" Sets autocomplete tab to only complete common characters for the first tab.
" By default it autocompletes to the first item in the list, which you can tab
" through.
set completeopt=longest,menuone

" Makes enter act as autocomplete select if an item is selected.
" By default it acts like enter
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Vim mappings
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Installation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" TODO -- maybe add later
" if empty(glob('~/.vim/autoload/plug.vim'))
"   silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
" endif

call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'           " The nice bar below
Plug 'itchyny/vim-gitbranch'           " Adds git info to bar below
Plug 'mark-westerhof/vim-lightline-base16'
if v:version < 800
  Plug 'vim-syntastic/syntastic'       " Syntax Checker
else
  Plug 'w0rp/ale'                      " Async linter Need to install linter though
  Plug 'maximbaz/lightline-ale'        " Adds ale info to bar below
endif
Plug 'airblade/vim-gitgutter'          " Shows changes in vim for git
Plug 'tpope/vim-eunuch'                " Adds commands like mkdir to vim
Plug 'tpope/vim-fugitive'              " git integration
Plug 'scrooloose/nerdtree'             " Adds filetree to left
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'bronson/vim-trailing-whitespace' " Highlites trailing space in red
Plug 'majutsushi/tagbar'               " Code Structure on right
Plug 'reasonml-editor/vim-reason-plus'
Plug 'chriskempson/base16-vim'
Plug 'edkolev/tmuxline.vim'
Plug 'terryma/vim-smooth-scroll'       " Makes scrolling smooth
Plug 'LucHermitte/lh-vim-lib'          " See below
Plug 'LucHermitte/local_vimrc'         " project local vimrc
Plug 'ludovicchabant/vim-gutentags'    " Manages tags
Plug 'christoomey/vim-tmux-navigator'  " Tmux Integration
Plug 'ericcurtin/CurtineIncSw.vim'     " Navigate between .ccp and .h files
Plug 'bounceme/poppy.vim'              " Highlight parentheses
Plug 'rgrinberg/vim-ocaml'
Plug 'tpope/vim-commentary'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings
"
" Lightline settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Shows cool status bar
set laststatus=2
set noshowmode

let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'gitbranch#name'
    \ },
    \ }

let g:lightline.colorscheme = 'base16_classic_dark'

"let g:lightline.separator = { 'left': '⮀', 'right': '⮂' }
"let g:lightline.subseparator = { 'left': '⮁', 'right': '⮃' }

" Ale lightline settings
if v:version >= 800
  let g:lightline.component_expand = {
        \  'linter_checking': 'lightline#ale#checking',
        \  'linter_warnings': 'lightline#ale#warnings',
        \  'linter_errors': 'lightline#ale#errors',
        \  'linter_ok': 'lightline#ale#ok',
        \ }

  let g:lightline.component_type = {
        \  'linter_checking': 'left',
        \  'linter_warnings': 'warning',
        \  'linter_errors': 'error',
        \  'linter_ok': 'left',
        \ }

  let g:lightline.active.right = [
        \  [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
		\  [ 'percent' ],
		\  [ 'fileformat', 'fileencoding', 'filetype' ],
        \  [ 'lineinfo' ]
        \ ]
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-commentary settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType cpp setlocal commentstring=//%s

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-ocaml settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ocaml_folding=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-tmux-navigator settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-H> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-J> :TmuxNavigateDown<cr>
nnoremap <silent> <C-K> :TmuxNavigateUp<cr>
nnoremap <silent> <C-L> :TmuxNavigateRight<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" local_vimrc settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:local_vimrc = ['.config', '_vimrc_local.vim']
call lh#local_vimrc#munge('whitelist', $HOME.'/git')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tmuxline settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:tmuxline_powerline_separators = 0
let g:tmuxline_preset = {
      \   'a'    : '#S',
      \   'b'    : '#W',
      \   'c'    : ['#(whoami)', '#H'],
      \   'win'  : '#I #W',
      \   'cwin' : '#I #W',
      \   'x'    : '%a',
      \   'y'    : '#W %R',
      \   'z'    : '#H'
      \ }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" color scheme settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let base16colorspace=256
colorscheme base16-classic-dark
"colorscheme base16-tomorrow-night
"colorscheme base16-railscasts
"colorscheme base16-default-dark
if v:version >= 800
  set termguicolors
endif

hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CurtineIncSw cpp-h file navigator settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <F5> :call CurtineIncSw()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTREE settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Show hidden files in nerdtree
let NERDTreeShowHidden=1

" autocmd vimenter * NERDTree " Open by default
autocmd StdinReadPre * let s:std_in=1 " Open if no file is specified
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

autocmd StdinReadPre * let s:std_in=1 " Open on directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" Close vim if left window is nerdtree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" arrow keys
let g:NERDTreeDirArrowExpandable = '>'
let g:NERDTreeDirArrowCollapsible = '|'
" CTL+n is now nerdtree toggle
map <C-n> :NERDTreeToggle<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ale settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if v:version >= 800

  "let g:ale_set_highlights = 0
  let g:airline#extensions#ale#enabled = 1

  highlight ALEError ctermbg=none cterm=underline
  highlight ALEWarning ctermbg=none cterm=underline

endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TAGBAR settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <S-t> :TagbarToggle<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if v:version < 800

  let g:syntastic_python_checkers = ['pylint']

  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*

  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0

endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-smooth-scroll settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 10, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 10, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 20, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 20, 4)<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPAM SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line

let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"
