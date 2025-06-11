; ax = ah (high byte) + al (low byte)
; ah holds the function code
mov ah, 0x0E ; Teletype print function
mov al, 'H'
; int : interrupt
; 0x10 : video output (print to screen)
int 0x10
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
int 0x10
mov al, 'o'
int 0x10

jmp $ ; jump to current address = infinte loop

times 510-($-$$) db 0
dw 0xAA55
