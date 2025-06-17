mov ah, 0x0E

mov bp, 0x8000
mov sp, bp

push 'A'
push 'B'
push 'C'

; We can only pop 16-bits, so pop to bx and copy bl to al
pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10

; Stack grows downward
mov al, [0x7ffe] ; 0x8000 - 2
int 0x10

jmp $

times 510-($-$$) db 0
dw 0xAA55
