#include "../drivers/ports.h"

void main() {
	// Screen cursor position: ask VGA control register (0x3D4) for bytes
	// 14 = high byte of cursor and 15 = low byte of cursor
	port_byte_out(0x3D4, 14);
	// Data is returned in VGA data register (0x3D5)
	int position = port_byte_in(0x3D5);
	// High byte
	position = position << 8;

	port_byte_out(0x3D4, 15);
	position += port_byte_in(0x3D5);

	// Each screen position takes 2 bytes: one for the character and one
	// for color
	int offset_from_vga = position * 2;

	char *vga = (char*) 0xB8000;
	vga[offset_from_vga] = 'X';
	vga[offset_from_vga + 1] = 0x0F;
}
