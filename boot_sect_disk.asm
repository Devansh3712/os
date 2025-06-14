; Load dh sectors from drive dl into es:bx
disk_load:
	pusha
	; Reading from disk requires setting specific values in all
	; registers, so we will overwrite our input parameters from dx
	push dx

	mov ah, 0x02	; 0x02 = read
	mov al, dh	; al <- number of sectors to read (0x01..0x80)
	mov cl, 0x02	; cl <- sector (0x01 .. 0x11)
			; 0x01 is our boot sector, 0x02 is the first available sector
	mov ch, 0x00	; ch <- cylinder (0x0..0x3FF)
	; dl <- drive number, caller sets is as a parameter and gets it from BIOS
	; 0 = floppy, 1 = floppy2, 0x80 = hdd, 0x81 = hdd2
	mov dh, 0x00	; dh <- head number (0x0..0xF)

	; [es:bx] <- pointer to buffer where the data will be stored
	int 0x13
	jc disk_error

	pop dx
	; BIOS sets al to the number of sectors read
	cmp al, dh
	jne sectors_error
	popa
	ret

disk_error:
	mov bx, DISK_ERROR
	call print
	call print_newline
	; ah = error code, dl = disk drive that dropped the error
	mov dh, ah
	call print_hex
	jmp disk_loop

sectors_error:
	mov bx, SECTORS_ERROR
	call print

disk_loop:
	jmp $

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0
