" CTRL-T Fuzzy Finder
noremap <C-t>		:FuzzyFinderTextMate<CR>
vnoremap <C-t>		<C-C>:FuzzyFinderTextMate<CR>

" Use CTRL-D for NERDTree
noremap <C-d>		:NERDTreeToggle<CR>
vnoremap <C-d>		<C-C>:NERDTreeToggle<CR>
inoremap <C-d>		<C-O>:NERDTreeToggle<CR>

:com MRU FuzzyFinderMruFile

" snippets
":filetype plugin on

set tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab
set nowrap
set autoindent
set smartindent
set cindent

behave mswin

" backspace in Visual mode deletes selection
vnoremap <BS> d

" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
vnoremap <S-Del> "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y

" CTRL-V and SHIFT-Insert are Paste
map <C-V>		"+gP
map <S-Insert>		"+gP
cmap <C-V>		<C-R>+
cmap <S-Insert>		<C-R>+

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.

exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

imap <S-Insert>		<C-V>
vmap <S-Insert>		<C-V>

" Use CTRL-S for saving, also in Insert mode
noremap <C-S>		:update<CR>
vnoremap <C-S>		<C-C>:update<CR>
inoremap <C-S>		<C-O>:update<CR>

" CTRL-Z is Undo; not in cmdline though
noremap <C-Z> u
inoremap <C-Z> <C-O>u

" CTRL-Y is Redo (although not repeat); not in cmdline though
noremap <C-Y> <C-R>
inoremap <C-Y> <C-O><C-R>

" CTRL-A is Select all
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG

" Indent/Unindent
vmap <silent> <Tab>        :<C-u>call Cream_indent("v")<CR>
imap <silent> <S-Tab> <C-O>:call Cream_unindent("i")<CR>
vmap <silent> <S-Tab>      :<C-u>call Cream_unindent("v")<CR>

" Indent/Unindent {{{1

function! Cream_indent(mode)
	if a:mode == "v"
		normal gv
		normal >
		normal gv
	endif
endfunction

function! Cream_unindent(mode)
	if a:mode == "v"
		normal gv
		normal <
		normal gv
	elseif a:mode == "i"
		let mypos = Cream_pos()
		" select line and unindent
		normal V
		normal <
		execute mypos
		" now adjust for shift
		let i = 0
		let myline = line('.')
		while i < &tabstop
			normal h
			" oops, go back to current line if we jumped up
			if line('.') < myline
				normal l
			endif
			let i = i + 1
		endwhile
		" select one char so
		" * user can see a selection is in place
		" * if tab is used immediately following this routine believes
		"   the whole line is selected rather than inserting a single
		"   tab
		normal vl
		if mode() == "v"
			" change to select mode
			execute "normal \<C-G>"
		endif
	endif
endfunction

" Positioning {{{1

function! Cream_pos(...)
" return current position in the form of an executable command
" Origins: Benji Fisher's foo.vim, available at
"          http://vim.sourceforge.net

	"let mymark = "normal " . line(".") . "G" . virtcol(".") . "|"
	"execute mymark
	"return mymark

	" current pos
	let curpos = line(".") . "G" . virtcol(".") . "|"

	" mark statement
	let mymark = "normal "

	" go to screen top
	normal H
	let mymark = mymark . line(".") . "G"
	" go to screen bottom
	normal L
	let mymark = mymark . line(".") . "G"

	" go back to curpos
	execute "normal " . curpos

	" cat top/bottom screen marks to curpos
	let mymark = mymark . curpos

	execute mymark
	return mymark

endfunction

colorscheme vividchalk
:lcd %:p:h
