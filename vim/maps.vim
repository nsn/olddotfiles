" Vim
" An example for a vimrc file.
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"             for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc

"set enc=utf-8
"set fenc=utf-8
set termencoding=utf-8

set nocompatible	" Use Vim defaults (much better!)
set bs=2		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers

set background=dark
set nowrap
:set showmatch		" jump emacs style to matching bracket

if has("multi_byte")
    "unicode support"
    setglobal fileencoding=utf-8
    setglobal encoding=utf-8
    set fileencoding=utf-8
    set encoding=utf-8
endif

"these characters can move past end of line
:set whichwrap=b,s,h,l

"default tabs are too wide IMO. uncomment to change them
:set tabstop=2 
:set et
:set shiftwidth=2
" In text files, always limit the width of text to 78 characters
autocmd BufRead *.txt set tw=78	

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
"  set hlsearch
endif

augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For *.c and *.h files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd BufRead *       set formatoptions=tcql nocindent comments&
  autocmd BufRead *.c,*.h set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
augroup END

augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  "	  read:	set binary mode before reading the file
  "		uncompress text in buffer after reading
  "	 write:	compress file after writing
  "	append:	uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre	*.gz set bin
  autocmd BufReadPost,FileReadPost	*.gz let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost	*.gz set nobin
  autocmd BufReadPost,FileReadPost	*.gz let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r

  autocmd FileAppendPre			*.gz !gunzip <afile>
  autocmd FileAppendPre			*.gz !mv <afile>:r <afile>
  autocmd FileAppendPost		*.gz !mv <afile> <afile>:r
  autocmd FileAppendPost		*.gz !gzip <afile>:r
augroup END


"let bash_is_sh = 1
"let is_bash = 1

" Uncomment to turn off arrow keys. Using arrow keys is a good habit to 
" get out of ... 

":map <left> <Nop>
":map <right> <Nop>
":map <up> <Nop>
":map <down> <Nop>

":imap <left> <Nop>
":imap <right> <Nop>
":imap <up> <Nop>
":imap <down> <Nop>

" Some emacs/pico like keybindings for insert mode

":imap <C-A> <ESC>0i
":imap <C-E> <ESC>$a
":imap <C-P> <ESC>ki
":imap <C-N> <ESC>ji
":imap <C-B> <ESC>la
":imap <C-F> <ESC>ha

" Some highlighting definitions

" THis is the default. 
" Doesn't use colours wisely IMO. Consider changing Repeat and Conditional
" to make them stand out a little better.

" There are two sets of defaults: for a dark and a light background.
  if &background == "dark"
    hi Comment	term=bold ctermfg=Brown guifg=#80a0ff
    hi Constant	term=underline ctermfg=Magenta guifg=#ffa0a0
    hi Special	term=bold ctermfg=LightRed guifg=Orange
    hi Identifier term=underline cterm=bold ctermfg=Cyan guifg=#40ffff
    hi Statement term=bold ctermfg=Yellow guifg=#ffff60 gui=bold
    hi PreProc	term=underline ctermfg=LightBlue guifg=#ff80ff
    hi Type	term=underline ctermfg=LightGreen guifg=#60ff60 gui=bold
    hi Ignore	ctermfg=black guifg=bg
  else
    hi Comment	term=bold ctermfg=DarkBlue guifg=Blue
    hi Constant	term=underline ctermfg=DarkRed guifg=Magenta
    hi Special	term=bold ctermfg=DarkMagenta guifg=SlateBlue
    hi Identifier term=underline ctermfg=DarkCyan guifg=DarkCyan
    hi Statement term=bold ctermfg=Brown gui=bold guifg=Brown
    hi PreProc	term=underline ctermfg=DarkMagenta guifg=Purple
    hi Type	term=underline ctermfg=DarkGreen guifg=SeaGreen gui=bold
    hi Ignore	ctermfg=white guifg=bg
  endif
  hi Error	term=reverse ctermbg=Red ctermfg=White guibg=Red guifg=White
  hi Todo	term=standout ctermbg=Yellow ctermfg=Black guifg=Blue guibg=Yellow

  " Common groups that link to default highlighting.
  " You can specify other highlighting easily.
  hi link String	Constant
  hi link Character	Constant
  hi link Number	Constant
  hi link Boolean	Constant
  hi link Float		Number
  hi link Function	Identifier
  hi link Conditional	Statement
  hi link Repeat	Statement
  hi link Label		Statement
  hi link Operator	Statement
  hi link Keyword	Statement
  hi link Exception	Statement
  hi link Include	PreProc
  hi link Define	PreProc
  hi link Macro		PreProc
  hi link PreCondit	PreProc
  hi link StorageClass	Type
  hi link Structure	Type
  hi link Typedef	Type
  hi link Tag		Special
  hi link SpecialChar	Special
  hi link Delimiter	Special
  hi link SpecialComment Special
  hi link Debug		Special


" change settings dependant on whether we edit php

:au BufReadPost,BufNewFile *.php if b:current_syntax == "php"
:au BufReadPost,BufNewFile *.php   :set shiftwidth=2
:au BufReadPost,BufNewFile *.php   :set tabstop=2
:au BufReadPost,BufNewFile *.php endif
:au BufReadPost,BufNewFile *.php set dictionary-=~/.dict.php dictionary+=~/.dict.php
:au BufReadPost,BufNewFile *.php set complete-=k complete+=k

" change settings dependant on whether we edit xsl
:au BufReadPost,BufNewFile *.xsl :set shiftwidth=2
:au BufReadPost,BufNewFile *.xsl :set tabstop=2
:au BufReadPost,BufNewFile *.html :set shiftwidth=2
:au BufReadPost,BufNewFile *.html :set tabstop=2
:au BufReadPost,BufNewFile *.xml :set shiftwidth=2
:au BufReadPost,BufNewFile *.xml :set tabstop=2
:au BufReadPost,BufNewFile *.tml :set shiftwidth=2
:au BufReadPost,BufNewFile *.tml :set tabstop=2
:au BufReadPost,BufNewFile *.jsp :set shiftwidth=2
:au BufReadPost,BufNewFile *.jsp :set tabstop=2
:au BufReadPost,BufNewFile *.lzx :set shiftwidth=2
:au BufReadPost,BufNewFile *.lzx :set tabstop=2
:au BufReadPost,BufNewFile *.lzx :set syntax=xml

" own abbrevations
ab fori for ($i=0;$i;$i++) { }

:set cpo-=<

" maps
map <F5> :make<CR>
map <F4> :!exuberant-ctags -R<CR>
map <C-TAB> :bnext<CR>




