mov ah, 0x0E

mov bx, 0x7C0
; ds = data segment (default for most data accesses)
mov ds, bx
; all memory references will be offset by 'ds' implicitly
mov al, [the_secret] ; access memory at 0x7C0:the_secret
int 0x10

; we cannot mov literals to special registers, we have to use a
; general purpose register before
mov bx, 0x7c0
mov es, bx
; segmentation is used to specify an offset to the data we are
; referring to
; offset << 4 + address
mov al, [es:the_secret]
int 0x10

jmp $

the_secret:
	db "X"

times 510-($-$$) db 0
dw 0xAA55
