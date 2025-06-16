gdt_start:

; GDT starts with a null 8-byte
gdt_null:
	; dd means define double word (4 bytes)
	dd 0x0
	dd 0x0

; Code segment descriptor
; base=0x0, limit=0xFFFFF
; 1st flags: (present)1 (privilige)00 (descriptor type)1
; type flags: (code)1 (conforming)0 (readable)1 (accesed)0
; 2nd flags: (granularity)1 (32-bit default)1 (64-bit seg)0 (AVL)0
gdt_code:
	dw 0xFFFF	; Limit (bits 0-15)
	dw 0x0		; Base (bits 0-15)
	db 0x0		; Base (bits 16-23)
	db 10011010b	; 1st flags, type flags
	db 11001111b	; 2nd flags, Limit (bits 16-19)
	db 0x0		; Base (bits 24-31)

; Data segment descriptor
; type flags: (code)0 (expand down)0 (writable)1 (accessed)0
gdt_data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0

; Putting a label at the end of GDT so the assembler can calculate
; the size of the GDT for the GDT descriptor
gdt_end:

gdt_descriptor:
	; Size of the GDT, always less one of the true size
	dw gdt_end - gdt_start - 1
	dw gdt_start

; In our GDT, 0x0 -> NULL; 0x08 -> CODE; 0x10 -> DATA
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
