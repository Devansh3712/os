[org 0x7C00]
; Memory offset to which we will load our kernel
KERNEL_OFFSET equ 0x1000

; BIOS stores our boot drive in dl, its best to remember it for later
mov [BOOT_DRIVE], dl
mov bp, 0x9000
mov sp, bp

mov bx, MSG_REAL_MODE
call print
call print_newline

call load_kernel
; Disable interrupts, load GDT and jump to BEGIN_PM
call switch_to_pm
jmp $

%include "../bootsector/boot_sect_print.asm"
%include "../bootsector/boot_sect_print_hex.asm"
%include "../bootsector/boot_sect_disk.asm"
%include "../bootsector/32bit_gdt.asm"
%include "../bootsector/32bit_print.asm"
%include "../bootsector/32bit_switch.asm"

[bits 16]
load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print
	call print_newline

	; Read from disk and store in 0x1000
	mov bx, KERNEL_OFFSET
	mov dh, 2
	mov dl, [BOOT_DRIVE]
	call disk_load
	ret

[bits 32]
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm
	; Give control to the kernel
	call KERNEL_OFFSET
	jmp $

BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16-bit real mode", 0
MSG_PROT_MODE db "Landed in 32-bit protected mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0

times 510-($-$$) db 0
dw 0xAA55
