[org 0x7C00]

mov bx, OS
call print
call print_newline

mov dx, 0x1002
call print_hex

jmp $

%include "boot_sect_print.asm"
%include "boot_sect_print_hex.asm"

OS:
	db 'devOS 1.0', 0

times 510-($-$$) db 0
dw 0xAA55
