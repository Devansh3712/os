loop:
	jmp loop  ; Infinite loop

; To make sure that the disk is bootable, the BIOS checks that bytes 511 and 512 of the
; boot sector are bytes 0xAA55
; $ : current address in the output binary
; $$ : start address of the current section (start of file in NASM)
; ($ - $$) is how many bytes of code have been generated so far
times 510-($-$$) db 0
dw 0xAA55
