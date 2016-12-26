"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 一般设定
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 设定默认解码
set fenc=utf-8
set fencs=utf-8 ",usc-bom,euc-jp,gb18030,gbk,gb2312,cp936

" 不要使用vi的键盘模式，而是vim自己的
set nocompatible

" history文件中需要记录的行数
set history=100

" 在处理未保存或只读文件的时候，弹出确认
set confirm

" 与windows共享剪贴板
"set clipboard+=unnamed

" 侦测文件类型
filetype on

" 载入文件类型插件
filetype plugin on

" 为特定文件类型载入相关缩进文件
filetype indent on

" 保存全局变量
set viminfo+=!

" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-

" 语法高亮
syntax on

" 高亮字符，让其不受100列限制
:highlight OverLength ctermbg=red ctermfg=white guibg=red guifg=white
:match OverLength '\%101v.*'

" 状态行颜色
highlight StatusLine guifg=SlateBlue guibg=Yellow
highlight StatusLineNC guifg=Gray guibg=White


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 文件设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 不要备份文件（根据自己需要取舍）
"set nobackup

" 不要生成swap文件，当buffer被丢弃的时候隐藏它
"setlocal noswapfile
"set bufhidden=hide

" 字符间插入的像素行数目
set linespace=0

" 增强模式中的命令行自动完成操作
set wildmenu

" 在状态行上显示光标所在位置的行号和列号
set ruler
set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\ %p%%%)

" 命令行（在状态行下）的高度，默认为1，这里是2
set cmdheight=1
"状态栏
set laststatus=2
set showcmd
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set statusline=[%f]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]

" 使回格键（backspace）正常处理indent, eol, start等
set backspace=2

" 允许backspace和光标键跨越行边界
set whichwrap+=<,>,h,l

" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
"set mouse=a
"set selection=exclusive
"set selectmode=mouse,key

" 启动的时候不显示那个援助索马里儿童的提示
set shortmess=atI

" 通过使用: commands命令，告诉我们文件的哪一行被改变过
set report=0

" 不让vim发出讨厌的滴滴声
set noerrorbells

" 在被分割的窗口间显示空白，便于阅读
set fillchars=vert:\ ,stl:\ ,stlnc:\

" 设置使用的ctags
set tags=~/tags

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 文本格式和排版
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 自动格式化
set formatoptions=tcrqn

" 继承前一行的缩进方式，特别适用于多行注释
"set autoindent

" 为C程序提供自动缩进
set smartindent

" 使用C样式的缩进
set cindent

" 制表符为8
set tabstop=8

" 统一缩进为8
set softtabstop=8
set shiftwidth=8

" 不要用空格代替制表符
"set noexpandtab

" 不要换行
set nowrap

" 在行和段开始处使用制表符
set smarttab
colorscheme evening
"colorscheme solarized
"窗口分割时,进行切换的按键热键需要连接两次,比如从下方窗口移动
"光标到上方窗口,需要<c-w><c-w>k,非常麻烦,现在重映射为<c-k>,切换的
"时候会变得非常方便.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 配置多语言环境
if has("multi_byte")
        " UTF-8 编码
        set encoding=utf-8
        set termencoding=utf-8
        set formatoptions+=mM
        set fencs=utf-8,gbk

        if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
                set ambiwidth=double
        endif

        if has("win32")
                source $VIMRUNTIME/delmenu.vim
                source $VIMRUNTIME/menu.vim
                language messages zh_CN.utf-8
        endif
else
        echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif
map <F1> :NERDTreeToggle<CR>

"-----------------------------------------------------------------
" plugin - taglist.vim  查看函数列表，需要ctags程序
" F4 打开隐藏taglist窗口
"-----------------------------------------------------------------
"let Tlist_Ctags_Cmd = '/usr/bin/ctags'
nnoremap <silent><F4> :TlistToggle<CR>
let Tlist_Show_One_File = 1            " 不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow = 1          " 如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Use_Left_Window = 1         " 在右侧窗口中显示taglist窗口
let Tlist_File_Fold_Auto_Close=1       " 自动折叠当前非编辑文件的方法列表
let Tlist_Auto_Open = 0
let Tlist_Close_On_Select=0
let Tlist_Auto_Update = 1
let Tlist_Hightlight_Tag_On_BufEnter = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_Process_File_Always = 1
let Tlist_Display_Prototype = 0
let Tlist_Compact_Format = 1
let Tlist_Max_Submenu_Items=100	
let Tlist_Max_Tag_Length=100
let Tlist_GainFocus_On_ToggleOpen=1
let Tlist_WinHeight=100
let Tlist_WinWidth=25
"
"自动补全
"":inoremap ( ()<ESC>i
"":inoremap ) <c-r>=ClosePair(')')<CR>
"":inoremap { {<CR>}<ESC>O
"":inoremap } <c-r>=ClosePair('}')<CR>
"":inoremap [ []<ESC>i
"":inoremap ] <c-r>=ClosePair(']')<CR>
"":inoremap " ""<ESC>i
"":inoremap ' ''<ESC>i
""function! ClosePair(char)
""	if getline('.')[col('.') - 1] == a:char
""		return "\<Right>"
""		else
""		return a:char
""	endif
""endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""新文件标题""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.py文件，自动插入文件头 
autocmd BufNewFile *.py,*.[ch],*.sh exec ":call SetTitle()" 
""定义函数SetTitle，自动插入文件头 
func SetTitle() 
        "如果文件类型为.sh文件 
        if &filetype == 'sh'
                call append(0,"#!/bin/bash")
                call append(1,"###############################################################################")
                call append(2,"# Author : liyunteng")
                call append(3,"# Email : li_yunteng@163.com")
                call append(4,"# Created Time : ".strftime("%Y-%m-%d %H:%M"))
                call append(5,"# Filename : ".expand("%:t"))
                call append(6,"# Description : ")
                call append(7,"###############################################################################")
                "call append(8,"")
                "echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
        endif
        if &filetype == 'python'
                call append(0,"#!/usr/bin/env python")
		call append(1,"###############################################################################")
                call append(2,"# Author : liyunteng")
                call append(3,"# Email : li_yunteng@163.com")
                call append(4,"# Created Time : ".strftime("%Y-%m-%d %H:%M"))
                call append(5,"# Filename : ".expand("%:t"))
                call append(6,"# Description : ")
                call append(7,"###############################################################################")
                call append(8,"# -*- coding: utf-8 -*-")
                "call append(9,"")
                "echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
        endif
        if &filetype == 'c'
                call append(0,"/*******************************************************************************")
                call append(1,"* Author : liyunteng")
                call append(2,"* Email : li_yunteng@163.com")
                call append(3,"* Created Time : ".strftime("%Y-%m-%d %H:%M"))
                call append(4,"* Filename : ".expand("%:t"))
                call append(5,"* Description : ")
                call append(6,"* *****************************************************************************/")
                call append(7,"#include <stdio.h>")
                "call append(8,"")
                "echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
        endif
        "新建文件后，自动定位到文件末尾
        autocmd VimEnter * normal G
endfunction
"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags 
"autocmd FileType css set omnifunc=csscomplete#CompleteCSS 
"autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags 
"autocmd FileType php set omnifunc=phpcomplete#CompletePHP 
autocmd FileType c set omnifunc=ccomplete#Complete 
autocmd FileType python set tabstop=4 shiftwidth=4 "cursorcolumn 
"autocmd FileType java set omnifunc=javacomplete#Complete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocommands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 只在下列文件类型被侦测到的时候显示行号，普通文本文件不显示
"if has("autocmd")
"	autocmd FileType html,c,cs,java,perl,shell,bash,cpp,python,vim,php,ruby set number
"	autocmd FileType html vmap <C-o> <ESC>'<i<!--<ESC>o<ESC>'>o-->
"	autocmd FileType java,c,cpp,cs vmap <C-o> <ESC>'<o/*<ESC>'>o*/
"	autocmd FileType html,text,php,vim,c,java,bash,shell,perl,python setlocal textwidth=100
"	autocmd Filetype html,xsl source $VIMRUNTIME/plugin/closetag.vim
"	autocmd BufReadPost *
"		\ if line("'\"") > 0 && line("'\"") <= line("$") |
"		\   exe "normal g`\"" |
""		\ endif
"endif " has("autocmd")

" F5编译和运行C程序，F6编译和运行C++程序
" 请注意，下述代码在windows下使用会报错
" 需要去掉./这两个字符

" C的编译和运行
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
        exec "w"
        exec "!gcc % -o %<"
        exec "! ./%<"
endfunc

" C++的编译和运行
map <F6> :call CompileRunGpp()<CR>
func! CompileRunGpp()
        exec "w"
        exec "!g++ % -o %<"
        exec "! ./%<"
endfunc
"python 的运行
map <F9> :call PythonRun()<CR>
func! PythonRun()
        exec "w"
        exec "!python %"
endfunc

" 能够漂亮地显示.NFO文件
set encoding=utf-8
function! SetFileEncodings(encodings)
        let b:myfileencodingsbak=&fileencodings
        let &fileencodings=a:encodings
endfunction

function! RestoreFileEncodings()
        let &fileencodings=b:myfileencodingsbak
        unlet b:myfileencodingsbak
endfunction

au BufReadPre *.nfo call SetFileEncodings('cp437')|set ambiwidth=single
au BufReadPost *.nfo call RestoreFileEncodings()

" 高亮显示普通txt文件（需要txt.vim脚本）
au BufRead,BufNewFile * setfiletype txt

"代码折叠 按空格展开关闭
set foldenable
"flodcolumn 
"set foldcolumn=2  
"set foldmethod=indent
"set foldopen=all
"set foldclose=all
set foldlevel=5
set foldmethod=syntax
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" minibufexpl插件的一般设置
"let g:miniBufExplMapWindowNavVim = 1
"let g:miniBufExplMapWindowNavArrows = 1
"let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplModSelTarget = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" 自定义
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 记住文件最后一次编辑位置，注意检查~/.viminfo权限是否可写
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm	$"|endif|endif

        " 当前行高亮
        " 可以把darkred，white等换成你喜欢的颜色。
        " 其中guibg和guifg修改的是下划线的颜色；
        " ctermbg和ctermfg修改的是背景的颜色，可以删去，仅保留下划线。
        "hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
        hi CursorColumn cterm=NONE ctermbg=blue ctermfg=white guibg=darkred guifg=white
        "hi CursorLine   cterm=NONE ctermbg=blue ctermfg=yellow
        "hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white
        set cursorline
        set hlsearch
        set nu
