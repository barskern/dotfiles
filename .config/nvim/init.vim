"
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|
"
" Author: Ole Martin Ruud (barskern@outlook.com)

" Disable plugins in Vi-mode
if v:progname ==# 'vi'
	set noloadplugins
endif

" Compatibility is for losers!
set nocompatible

" Setup Plugins {{{

call plug#begin('~/.local/share/nvim/plugged')

Plug 'honza/vim-snippets'
Plug 'airblade/vim-rooter'
Plug 'b4b4r07/vim-hcl'
Plug 'cespare/vim-toml'
Plug 'derekwyatt/vim-scala'
Plug 'dhruvasagar/vim-table-mode'
Plug 'editorconfig/editorconfig-vim'
Plug 'hashivim/vim-terraform'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'itchyny/lightline.vim'
Plug 'juliosueiras/vim-terraform-completion'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-easy-align'
Plug 'Konfekt/FastFold'
Plug 'lepture/vim-jinja'
Plug 'lervag/vimtex'
Plug 'liuchengxu/vista.vim'
Plug 'majutsushi/tagbar'
Plug 'markonm/traces.vim'
Plug 'mattn/emmet-vim'
Plug 'mattn/webapi-vim'
Plug 'mxw/vim-jsx'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovimhaskell/haskell-vim'
Plug 'pangloss/vim-javascript'
Plug 'parsonsmatt/intero-neovim'
Plug 'plasticboy/vim-markdown'
Plug 'rbgrouleff/bclose.vim'
Plug 'rhysd/vim-grammarous'
Plug 'rodjek/vim-puppet'
Plug 'ron-rs/ron.vim'
Plug 'rust-lang/rust.vim'
Plug 'sakhnik/nvim-gdb', { 'do': './install.sh' }
Plug 'Shougo/context_filetype.vim'
Plug 'Shougo/neco-syntax'
Plug 'srcery-colors/srcery-vim'
Plug 'StanAngeloff/php.vim'
Plug 'tikhomirov/vim-glsl'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-ruby/vim-ruby'
" Plug 'vim-pandoc/vim-pandoc'
" Plug 'vim-pandoc/vim-pandoc-syntax'

call plug#end()

" }}}

" Generic settings {{{

" Settings for diffmode
set diffopt+=vertical

filetype plugin on
syntax on

" Settings for `hardcopy`
set printoptions=number:y,left:5pc,right:5pc,top:5pc,bottom:5pc
set printheader=%<%f%h%=Ole\ Martin\ Ruud%=Side\ %N

" Set encoding
set encoding=utf-8
scriptencoding utf-8

" Some basics
let mapleader = ","
let maplocalleader = ";"

" Set numberline settings
set number
set relativenumber

" Set language settings
set spelllang=nb

" Paste mode (disables autoindent etc)
set pastetoggle=<F2>

if has('autocmd')
	augroup nasmdetection
		autocmd!
		autocmd BufNewFile,BufRead *.nasm set filetype=nasm
	augroup END

	augroup togglerelnumbers
		autocmd!
		" Turn off relative numbers in insert mode
		autocmd InsertEnter,BufLeave,WinLeave,FocusLost *
					\ if &l:number && empty(&buftype) |
					\ setlocal norelativenumber |
					\ endif
		" Turn on relative numbers in normal mode
		autocmd InsertLeave,BufEnter,WinEnter,FocusGained *
					\ if &l:number && empty(&buftype) |
					\ setlocal relativenumber |
					\ endif
	augroup end

	augroup autowriteread
		autocmd!
		" Save whenever switching windows or leaving vim. This is useful when running
		" the tests inside vim without having to save all files first.
		autocmd FocusLost,WinLeave * :silent! noautocmd wa

		" Trigger autoread when changing buffers or coming back to vim.
		autocmd FocusGained,BufEnter * :silent! !
	augroup END

endif

" Use ripgrep as grep
if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
endif

" Automatically read on filechange outside of vim.
set autoread
" Automatically write to file when performing certain commands.
set autowrite

" Set search settings
set incsearch
set hlsearch

" Misc settings
set scrolloff=2
set ruler
set showcmd
set noshowmode
set laststatus=2
set splitbelow
set splitright
set nojoinspaces
set signcolumn=yes

" Indentation and formatting settings
set noexpandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set autoindent
set smartindent
" set cursorline
set list

" Command to convert spaces to tabs for a range
" See https://vim.fandom.com/wiki/Super_retab
:command! -nargs=1 -range SuperRetab <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g

" Enable soft wrapping (vim.wikia.com/wiki/Word_wrap_without_line_breaks)
"set wrap
"set nolist

set linebreak

set tw=80
set formatoptions=jcrql

" Prevent ins-completion-menu popups
set shortmess+=c
"set completeopt-=preview
"set completeopt+=noinsert

" Colorscheme
colorscheme srcery
let g:srcery_italic = 1

" Backup, swap and undo
set undofile
set undolevels=1000
set undoreload=10000
set swapfile

" Required for operations modifying multiple buffers like rename.
set hidden

" Customized version of folded text made by
" https://github.com/chrisbra/vim_dotfiles/blob/master/plugin/CustomFoldText.vim,
" based on the idea by
" http://www.gregsexton.org/2011/03/improving-the-text-displayed-in-a-fold/
fu! CustomFoldText(string)
	" Get first non-blank line
	let fs = v:foldstart
	if getline(fs) =~ '^\s*$'
		let fs = nextnonblank(fs + 1)
	endif
	if fs > v:foldend
		let line = getline(v:foldstart)
	else
		let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
	endif
	let pat  = matchstr(&l:cms, '^\V\.\{-}\ze%s\m')

	" Remove leading comments from line
	let line = substitute(line, '^\s*'.pat.'\s*', '', '')

	" Remove foldmarker from line
	let pat  = '\%('. pat. '\)\?\s*'. split(&l:fmr, ',')[0]. '\s*\d\+'
	let line = substitute(line, pat, '', '')

	" let line = substitute(line, matchstr(&l:cms,
	" \ '^.\{-}\ze%s').'\?\s*'. split(&l:fmr,',')[0].'\s*\d\+', '', '')

	let w = get(g:, 'custom_foldtext_max_width', winwidth(0)) - &foldcolumn - (&number ? 8 : 0)
	let foldSize = 1 + v:foldend - v:foldstart
	let foldSizeStr = " " . foldSize . " lines "
	let foldLevelStr = '+'. v:folddashes
	let lineCount = line("$")
	if has("float")
		try
			let foldPercentage = printf("[%2.0f", (foldSize*1.0)/lineCount*100) . "%] "
		catch /^Vim\%((\a\+)\)\=:E806/	" E806: Using Float as String
			let foldPercentage = printf("[of %d lines] ", lineCount)
		endtry
	endif
	if exists("*strwdith")
		let expansionString = repeat(a:string, w - 2 - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
	else
		let expansionString = repeat(a:string, w - 2 - strlen(substitute(foldSizeStr.line.foldLevelStr.foldPercentage, '.', 'x', 'g')))
	endif
	return '⟫ ' . line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endf

set foldtext=CustomFoldText('.')

" }}}

" Plugin settings {{{

" fzf.vim
let g:fzf_tags_command = "ctags -R src"

" vista
let g:vista_sidebar_width = 50

" vimtex
let g:vimtex_compiler_progname = 'nvr'
let g:tex_flavor = 'latex'

" coc.nvim

" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" Install coc extensions
let g:coc_global_extensions = [
	\ "coc-dictionary",
	\ "coc-json",
	\ "coc-metals",
	\ "coc-solargraph",
	\ "coc-rust-analyzer",
	\ "coc-vimtex",
	\ "coc-snippets",
	\ "coc-css",
	\ "coc-html",
	\ "coc-yaml",
	\ "coc-emmet",
	\ "coc-tailwindcss",
	\ "coc-highlight",
	\ "coc-actions",
	\ "coc-pyright"
	\ ]

augroup mygroup
	autocmd!
	" Setup formatexpr specified filetype(s).
	autocmd FileType scala,rust,html,json,css,latex setl formatexpr=CocAction('formatSelected')
	" Update signature help on jump placeholder
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" goyo.vim

" taken from https://github.com/junegunn/goyo.vim/issues/16
function! s:goyo_enter()
	let b:quitting = 0
	let b:quitting_bang = 0
	autocmd QuitPre <buffer> let b:quitting = 1
	cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
	" Quit Vim if this is the only remaining buffer
	if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
		if b:quitting_bang
			qa!
		else
			qa
		endif
	endif
endfunction

autocmd! User GoyoEnter call <SID>goyo_enter()
autocmd! User GoyoLeave call <SID>goyo_leave()

" vim-rooter

let g:rooter_patterns = ['.git', '.git/', 'Cargo.toml', 'build.sbt']

" Fetch a env variable using vim-dotenv if it exist
function! s:env(var) abort
	return exists('*DotenvGet') ? DotenvGet(a:var) : eval('$'.a:var)
endfunction

" dadbod
let g:db = s:env('DATABASE_URL')

" intero-neovim
let g:intero_prompt_regex = '[^-]> '
let g:intero_window_size = 20

let g:intero_backend = {
\ 'command': 'stack ghci',
\ 'options': '--ghci-options "-w -ghci-script /home/oruud/.ghc/pretty-printer.conf"',
\ 'cwd': expand('%:p:h'),
\}

" rust.vim settings
let g:rust_fold = 2
let g:rust_clip_command = 'xclip -selection clipboard'

" vim-go settings
let g:go_list_type = "none"

" lightline settings
let g:lightline = {}

let g:lightline.component_function = {
\  'gitbranch': 'fugitive#head',
\  'cocstatus': 'coc#status'
\}

let g:lightline.colorscheme = 'srcery'

let g:lightline.active = {
\ 'left': [ [ 'mode', 'paste' ],
\           [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
\ 'right': [ [ 'cocstatus' ],
\            [ 'lineinfo', 'percent' ],
\            [ 'fileformat', 'fileencoding', 'filetype' ] ],
\}

" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" pandoc-vim settings
" let g:pandoc#syntax#conceal#use=0
" let g:pandoc#spell#enabled=0

" vim-markdown
" let g:vim_markdown_conceal = 0
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:tex_conceal = ""
let g:vim_markdown_math = 1

" editorconfig-vim
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" nvim-gdb
let g:nvimgdb_disable_start_keymaps = 1

" vim-table-mode
let g:table_mode_map_prefix = '<Leader>\|'
let g:table_mode_update_time = 300
let g:table_mode_corner = '|'
let g:table_mode_corner_corner = '|'
let g:table_mode_header_fillchar = '-'

" emmet.vim
"let g:user_emmet_install_global = 0
let g:user_emmet_leader_key = ',e'

" }}}

" Keybindings {{{

" coc.nvim

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@<CR>

" Remap keys for gotos
nmap <silent> <leader>ld <Plug>(coc-definition)
nmap <silent> <leader>lt <Plug>(coc-type-definition)
nmap <silent> <leader>i <Plug>(coc-implementation)
nmap <silent> <leader>lr <Plug>(coc-references)
nmap <silent> <leader>f <Plug>(coc-fix-current)
nmap <silent> <leader>l<CR> <Plug>(coc-codelens-action)
nmap <silent> <leader>ll :CocList<CR>
nmap <silent> <leader>lc :CocCommand<CR>

" Format using F
nmap <leader>F :Format<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" fzf commands for
nnoremap <leader>f :Files<CR>
nnoremap <leader>L :Lines<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <leader>bb :Buffers<CR>

" Starting nvim-gdb
nnoremap <leader>dd :GdbStart gdb -q <C-R>=expand('%:r')<CR><CR>
nnoremap <leader>dD :GdbStart gdb -q<Space>
nnoremap <leader>dl :GdbStartLLDB lldb <C-R>=expand('%:r')<CR><CR>
nnoremap <leader>dL :GdbStartLLDB lldb<Space>

" Exit terminal mode with ESC
tnoremap <Esc> <C-\><C-n>

" vim-fugitive commands
map <leader>gg :G<CR>
map <leader>gw :Gwrite<CR>
map <leader>gW :Gwrite!<CR>
map <leader>gc :Gcommit -v<CR>
map <leader>gs :Gstatus<CR>
map <leader>gb :Gblame<CR>
map <leader>gB :Gbrowse<CR>
map <leader>gl :0Glog<CR>
map <leader>gp :Gpush<CR>
map <leader>gP :Gpull<CR>

" cargo commands
map <leader>cc :Cbuild<CR>
map <leader>cb :Cbench<CR>
map <leader>cr :Crun<CR>
map <leader>ct :Ctest <C-R>=expand('%:t:r')<CR><CR>
map <leader>cT :Ctest<CR>

nnoremap <C-l> :copen<cr>
nnoremap <C-g> :cclose<cr>

" Toggle tagbar
nmap <F8> :TagbarToggle<CR>

" Use easy align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Search results unfolded please
nnoremap <silent> n nzv
nnoremap <silent> N Nzv
nnoremap <silent> g* g*zv

" Quiting shortcuts
nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>W :w !sudo tee >/dev/null %<CR>
nnoremap <leader>x :xit<CR>

" Make j and k work with both relativenumbers and softwrapped text
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Clear highlight
nmap <silent> <BS> :nohlsearch<CR>

" Open the selected text in a split (i.e. should be a file).
map <leader>o "oyaW:sp <C-R>o<CR>
xnoremap <leader>o "oy<Esc>:sp <C-R>o<CR>
vnoremap <leader>o "oy<Esc>:sp <C-R>o<CR>

" Search for selected text in visual mode
vnoremap // y/<C-R>"<CR>

" Open file in urlview to follow url
noremap <leader>u :w<Home>silent <End> !urlview<CR>

" Replace all is aliased to S.
nnoremap S :%s/

" Copy selected text to system clipboard (requires gvim installed):
vnoremap <silent> <C-c> "*y :let @+=@*<CR>
map <C-p> "*p

" Navigating with guides
inoremap <leader><leader> <Esc>/<++><CR>"_c4l
vnoremap <leader><leader> <Esc>/<++><CR>"_c4l
map <leader><leader> <Esc>/<++><CR>"_c4l

" Run make in background
nnoremap <silent> <leader>m :call jobstart('make')<CR>

" }}}

" Filetype snippets and settings {{{

if has('autocmd')

	augroup hcl
		autocmd!
		autocmd FileType hcl set expandtab tabstop=2 softtabstop=2 shiftwidth=2
	augroup END

	augroup terraform
		autocmd!
		autocmd FileType terraform set expandtab tabstop=2 softtabstop=2 shiftwidth=2
	augroup END

	augroup terminals
		autocmd!
		autocmd TermOpen * setlocal nonumber norelativenumber scrolloff=0
	augroup END

	augroup json
		autocmd!
		autocmd FileType json set conceallevel=0
	augroup END

	augroup haskell
		autocmd!
		" Background process and window management
		autocmd FileType haskell nnoremap <silent> <leader>is :InteroStart<CR>
		autocmd FileType haskell nnoremap <silent> <leader>ik :InteroKill<CR>

		" Open intero/GHCi split horizontally
		autocmd FileType haskell nnoremap <silent> <leader>io :InteroOpen<CR>
		" Open intero/GHCi split vertically
		autocmd FileType haskell nnoremap <silent> <leader>iov :InteroOpen<CR><C-W>H
		autocmd FileType haskell nnoremap <silent> <leader>ih :InteroHide<CR>

		" Reloading (pick one)
		" Automatically reload on save
		autocmd BufWritePost *.hs InteroReload

		" Load individual modules
		autocmd FileType haskell nnoremap <silent> <leader>il :InteroLoadCurrentModule<CR>
		autocmd FileType haskell nnoremap <silent> <leader>if :InteroLoadCurrentFile<CR>

		" Type-related information
		" Heads up! These next two differ from the rest.
		autocmd FileType haskell map <silent> <leader>t <Plug>InteroGenericType
		autocmd FileType haskell map <silent> <leader>T <Plug>InteroType
		autocmd FileType haskell nnoremap <silent> <leader>it :InteroTypeInsert<CR>

		" Navigation
		autocmd FileType haskell nnoremap <silent> <leader>jd :InteroGoToDef<CR>

		" Managing targets
		" Prompts you to enter targets (no silent):
		autocmd FileType haskell nnoremap <leader>ist :InteroSetTargets<SPACE>
	augroup end

	augroup cpp
		autocmd!
		autocmd FileType cpp inoremap <F5> <Esc>:!g++ -g -o %< %<CR>
		autocmd FileType cpp nnoremap <F5> :!g++ -g -o %< %<CR>
		autocmd FileType cpp inoremap <F6> <Esc>:!g++ -g -o %< % && ./%<<CR>
		autocmd FileType cpp nnoremap <F6> :!g++ -g -o %< % && ./%<<CR>

		autocmd FileType cpp set tabstop=2
		autocmd FileType cpp set softtabstop=2
		autocmd FileType cpp set shiftwidth=2
	augroup END

	augroup yaml
		autocmd!
		autocmd FileType yaml set tabstop=2
		autocmd FileType yaml set softtabstop=2
		autocmd FileType yaml set shiftwidth=2
	augroup END

	augroup rust
		autocmd!
		autocmd FileType rust inoremap <F5> <Esc>:Cbuild<CR>
		autocmd FileType rust nnoremap <F5> :Cbuild<CR>
		autocmd FileType rust inoremap <F6> <Esc>:Crun<CR>
		autocmd FileType rust nnoremap <F6> :Crun<CR>
		" Run all tests
		autocmd FileType rust inoremap <F7> <Esc>:Ctest<CR>
		autocmd FileType rust nnoremap <F7> :Ctest<CR>
		" Run single test
		autocmd FileType rust inoremap <F8> <Esc>:RustTest<CR>
		autocmd FileType rust nnoremap <F8> :RustTest<CR>
	augroup END

	augroup markdown
		autocmd!
		autocmd FileType markdown inoremap <F5> <Esc>:PandocCompile<CR>
		autocmd FileType markdown nnoremap <F5> :PandocCompile<CR>
		autocmd FileType markdown inoremap <F6> <Esc>:PandocPreview<CR>
		autocmd FileType markdown nnoremap <F6> :PandocPreview<CR>
	augroup END

	augroup golang
		autocmd!
		autocmd FileType go inoremap <F5> <Esc>:GoBuild<CR>
		autocmd FileType go nnoremap <F5> :GoBuild<CR>
		autocmd FileType go inoremap <F6> <Esc>:GoRun<CR>
		autocmd FileType go nnoremap <F6> :GoRun<CR>
		autocmd FileType go inoremap <F7> <Esc>:GoTest<CR>
		autocmd FileType go nnoremap <F7> :GoTest<CR>
	augroup END

	augroup mail
		autocmd!
		autocmd FileType mail set wrap linebreak nolist tw=0
		" Workaround due to lightline not being enabled (https://github.com/junegunn/goyo.vim/issues/207)
		autocmd FileType mail call lightline#init()
		autocmd FileType mail :Goyo
	augroup END

	augroup jinja
		autocmd!
		autocmd BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm,*.tera set ft=jinja expandtab
	augroup END

	augroup css
		autocmd!
		autocmd BufNewFile,BufRead *.css set expandtab
	augroup END
endif

" }}}

" vim: foldmethod=marker:ts=2:sw=2
