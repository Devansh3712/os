[bits 16]
; Switch to protected mode
switch_to_pm:
	cli
	lgdt [gdt_descriptor]
	; To make the switch to protected mode, we set the first
	; bit of CR0, a control register
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	; Make a far jump, forces CPU to flush its cache of pre-fetched
	; and real-mode decoded instructions
	jmp CODE_SEG:init_pm

[bits 32]
init_pm:
	; In PM, old segments are meaningless, point our segment
	; registers to the data selector we defined in our GDT
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	; Update stack position
	mov ebp, 0x90000
	mov esp, ebp

	call BEGIN_PM
