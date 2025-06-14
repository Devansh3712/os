print:
	pusha

start:
	mov al, [bx]
	; If current character is null-byte (0), stop printing
	cmp al, 0
	je done

	mov ah, 0x0E
	int 0x10

	add bx, 1
	jmp start

done:
	popa
	ret

print_newline:
	pusha

	mov ah, 0x0E
	mov al, 0x0A ; newline character
	int 0x10
	mov al, 0x0D ; carriage return
	int 0x10

	popa
	ret
