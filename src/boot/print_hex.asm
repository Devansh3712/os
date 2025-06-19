print_hex:
	pusha
	mov cx, 0 ; index variable

; Get the last character of dx, then convert to ASCII
; Numeric ASCII values: '0' (0x30) to '9' (0x39) - add 0x30 to byte N
; For alphabetic values: 'A' (0x41) to 'F' (0x46) - add 0x40
hex_loop:
	cmp cx, 4
	je end

	mov ax, dx
	and ax, 0x000F
	add al, 0x30 ; if 0-9, makes it ASCII '0'-'9'
	cmp al, 0x39 ; if > 9, add extra 7 to represent 'A' to 'F'
	jle step2
	add al, 7 ; if its A-F, correct the ASCII

step2:
	; bx <- base address + string length - index of character
	mov bx, HEX_OUT + 5
	sub bx, cx
	; Copy ASCII character on al to the position pointed by bx
	mov [bx], al
	; Right rotate by 4 bits
	ror dx, 4

	add cx, 1
	jmp hex_loop

end:
	mov bx, HEX_OUT
	call print

	popa
	ret

HEX_OUT:
	db '0x0000',0
