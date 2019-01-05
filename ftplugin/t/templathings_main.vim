
" useful things
inoremap <leader>p <Esc>:call TogglePasteMode()<Cr>a
nnoremap <leader>p <Esc>:call TogglePasteMode()<Cr>
inoremap <leader>\ \

func! TogglePasteMode()
	
	" if paste isn't set, set it, and vice versa

	if &paste == 0
		setlocal paste
	else
		setlocal nopaste
	endif

endfunc


nnoremap stonk :tabnew<Cr>:set filetype=java<Cr>o<Cr><Cr>{<Cr><Cr>{<Cr><Cr>



" only for dev:
source ./utilities.vim
