[bits 32]
; Declare that we will be referencing the external symbol 'main'
; so the linker can substitute the final address
[extern main]
call main
jmp $
