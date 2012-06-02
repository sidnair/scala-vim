" Vim plugin that attempts to add a package new Scala source files. It tries to
" detect the package name from the directory path. For example:
" .../src/main/scala/com/mycompany/myapp/app.scala gets the package
" com.mycompany.myapp
"
" Author: Stepan Koltsov <yozh@mx1.ru>

function! MakeScalaFile()
    if exists("b:template_used") && b:template_used
        return
    endif

    let b:template_used = 1

    let filename = expand("<afile>:p")
    let x = substitute(filename, "\.scala$", "", "")

    let p = substitute(x, "/[^/]*$", "", "")
    let p = substitute(p, "/", ".", "g")
    let p = substitute(p, ".*\.src$", "@", "") " unnamed package
    let p = substitute(p, ".*\.src\.", "!", "")
    let p = substitute(p, "^!main\.scala\.", "!", "")
    let p = substitute(p, "^!.*\.ru\.", "!ru.", "")
    let p = substitute(p, "^!.*\.org\.", "!org.", "")
    let p = substitute(p, "^!.*\.com\.", "!com.", "")

    " If we have guessed some package name
    if match(p, "^!") == 0
        let p = substitute(p, "^!", "", "")
        call append("0", "package " . p)
    endif
endfunction

au BufNewFile *.scala call MakeScalaFile()
