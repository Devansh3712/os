; BIOS always loads the boot sector from 0x7C00 where it is sure
; will not be occupied by important routines
;
;		+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
;		|                     Free                      |
; 0x100000	+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
;		|                 BIOS (256 KB)                 |
; 0xC0000	+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
;		|             Video Memory (128 KB)             |
; 0xA0000	+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
;		|       Extended BIOS Data Area (639 KB)        |
; 0x9FC00	+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
;		|                Free (638 KB)                  |
; 0x7E00	+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
;		|        Loaded Boot Sector (512 Bytes)         |
; 0x7C00	+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
;		|                                               |
; 0x500		+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
;		|          BIOS Data Area (256 Bytes)           |
; 0x400		+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
;		|        Interrupt Vector Table (1 KB)          |
; 0x0		+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

mov ah, 0x0E

; Add BIOS starting offset to the memory address of X and then
; dereference the contents of the pointer
mov bx, the_secret
add bx, 0x7C00
mov al, [bx]
int 0x10

jmp $

the_secret:
	db "X"

times 510-($-$$) db 0
dw 0xAA55
