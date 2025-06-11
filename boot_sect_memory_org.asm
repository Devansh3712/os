; Assemblers let us define a global offset for every memory location
; with the org command
[org 0x7C00]

mov ah, 0x0E

mov al, [the_secret]
int 0x10

jmp $

the_secret:
	db "X"

times 510-($-$$) db 0
dw 0xAA55
