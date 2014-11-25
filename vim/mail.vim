" completion of mail adresses using goobook
" press <C-x><C-u> to autocomplete email addresses anywhere in the current buffer
" stole large parts of this from http://jfreak53.blogspot.de/2012/07/vim-as-mutt-email-editor.html
fun! MailcompleteC(findstart, base)
    if a:findstart == 1
        let line = getline('.')
        let idx = col('.')
        while idx > 0
            let idx -= 1
            let c = line[idx]
            " break on header and previous email
            if c == ':' || c == '>'
                return idx + 2
            else
                continue
            endif
        endwhile
        return idx
    else
        if exists("g:goobookrc")
            let goobook="~/.local/bin/goobook -c " . g:goobookrc
        else
            let goobook="~/.local/bin/goobook"
        endif
        let res=system(goobook . ' query ' . shellescape(a:base))
        echom res
        if v:shell_error
            return []
        else
            "return split(system(trim . '|' . fmt, res), '\n')
            return MailcompleteF(MailcompleteT(res))
        endif
    endif
endfun

fun! MailcompleteT(res)
    " next up: port this to vimscript!
    let trim="sed '/^$/d' | grep -v '(group)$' | cut -f1,2"
    return split(system(trim, a:res), '\n')
endfun

fun! MailcompleteF(contacts)
    "let fmt='awk ''BEGIN{FS="\t"}{printf "%s <%s>\n", $2, $1}'''
    let contacts=map(copy(a:contacts), "split(v:val, '\t')")
    let ret=[]
    for [email, name] in contacts
        call add(ret, printf("%s <%s>", name, email))
    endfor
    return ret
endfun


set completefunc=MailcompleteC

" map <Tab> to <C-x><C-u> only if the current line is an address header
fun! AddressHeader(line) 
  let l:addressHeaders=['To', 'Cc', 'Bcc']

  for l:header in l:addressHeaders
    let l:match = match(a:line, l:header)
    if l:match==0
      return "\<C-x>\<C-u>"
    endif
  endfor

  return "\<Tab>"
endfun

imap <expr> <Tab> AddressHeader(getline('.'))

" word wrapping
set wrap
set linebreak
set nolist  " list disables linebreak
set textwidth=0
set wrapmargin=0

