[bits 32]

; VGA (Video Graphics Array) is a standard for displaying graphics/text
; on screen
; VGA memory starts at 0xB8000 and has a text mode which is useful to
; avoid manipulating direct pixels
VIDEO_MEMORY equ 0xB8000
WHITE_ON_BLACK equ 0x0F

print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY

print_string_pm_loop:
	mov al, [ebx] ; [ebx] is the address of the character
	mov ah, WHITE_ON_BLACK

	cmp al, 0
	je print_string_pm_done

	mov [edx], ax	; Store character + attribute in video memory
	add ebx, 1	; Next character
	add edx, 2	; Next video memory position

	jmp print_string_pm_loop

print_string_pm_done:
	popa
	ret
