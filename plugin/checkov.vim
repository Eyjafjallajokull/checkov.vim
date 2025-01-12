""
" @usage {}
" Run checkov against the current directory and populate the QuickFix list
command! -nargs=* Checkov call s:checkov(<f-args>)

" checkov runs checkov and prints adds the results to the quick fix buffer
function! s:checkov(cwd, custom_args) abort
  try
		" capture the current error format
		let errorformat = &g:errorformat

 		" set the error format for use with checkov
		let &g:errorformat='%ECheck:\ %m,%C	FAILED\ for\ resource:\ %s,%C	File:\ %f:%l-%s,%C	%s,%Z	Guide: %s'

		let s:cmd='set -o pipefail; checkov ' . a:custom_args . ' --directory "' . a:cwd . '" --compact | sed "s#File: #File: ./' . a:cwd . '#"' 
		" get the latest checkov comments and open the quick fix window with them
        let s:result = system(s:cmd)
		if v:shell_error != 0
            echo s:result
		else
            cgetexpr s:result | cw
            call setqflist([], 'a', {'title' : ':Checkov'})
		endif
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
