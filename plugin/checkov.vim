""
" @usage {}
" Run checkov against the current directory and populate the QuickFix list
command! Checkov call s:checkov()

" checkov runs checkov and prints adds the results to the quick fix buffer
function! s:checkov() abort
  try
		" capture the current error format
		let errorformat = &g:errorformat

 		" set the error format for use with checkov
		let &g:errorformat='%ECheck:\ %m:\ %m,%C	FAILED\ for\ resource:\ %m,%C	File:\ %f:%l,%C	%s,%Z'

		let s:cmd='date;checkov --quiet --directory . --output cli 2>/dev/null | gsed "s/File: /File: ./"'
		" get the latest checkov comments and open the quick fix window with them
		cgetexpr system(s:cmd) | cw
		call setqflist([], 'a', {'title' : ':Checkov'})
	finally
		" restore the errorformat value
		let &g:errorformat = errorformat
  endtry
endfunction

" checkovInstall runs the go install command to get the latest version of checkov
function! s:checkovInstall() abort
	try
		echom "Downloading the latest version of checkov"
    let installResult = system('go install github.com/aquasecurity/checkov/cmd/checkov@latest')
		if v:shell_error != 0
    	echom installResult
		else
			echom "checkov downloaded successfully"
		endif
	endtry
endfunction

" checkovUpdate will update existing checkov
function! s:checkovUpdate() abort
	try
		echom "Updating to the latest version of checkov"
    echom system('checkov --update')
	endtry
endfunction
