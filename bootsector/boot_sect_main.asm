[org 0x7C00]

mov bp, 0x8000
mov sp, bp

mov bx, 0x9000	; es:bx = 0x0000:0x9000
mov dh, 2	; Read 2 sectors
; BIOS sets dl for our boot disk number
call disk_load

mov dx, [0x9000]
call print_hex
call print_newline

mov dx, [0x9000 + 512]
call print_hex

jmp $

%include "boot_sect_print.asm"
%include "boot_sect_print_hex.asm"
%include "boot_sect_disk.asm"

times 510-($-$$) db 0
dw 0xAA55

times 256 dw 0xdead ; sector 2 = 512 bytes
times 256 dw 0xbeef ; sector 3 = 512 bytes
