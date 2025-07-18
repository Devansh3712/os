#include "screen.h"
#include "ports.h"

int get_cursor_offset() {
	// The device uses its control register as an index to select
	// its internal registers
	// reg 14: high byte of cursor's offset
	// reg 15: low byte of cursor's offset
	// Once the internal register has been selected, we may read or
	// write a byte on the data register
	port_byte_out(REG_SCREEN_CTRL, 14);
	int offset = port_byte_in(REG_SCREEN_DATA) << 8;
	port_byte_out(REG_SCREEN_CTRL, 15);
	offset += port_byte_in(REG_SCREEN_DATA);
	// The cursor offset reported by VGA hardware is the number of
	// characters, we multiply by 2 to convert it to a character cell
	// offset
	return offset * 2;
}

void set_cursor_offset(int offset) {
	offset /= 2;
	port_byte_out(REG_SCREEN_CTRL, 14);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
	port_byte_out(REG_SCREEN_CTRL, 15);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xFF));
}

int get_offset(int col, int row) { return 2 * (row * MAX_COLS + col); }
int get_offset_row(int offset) { return offset / (2 * MAX_COLS); }
int get_offset_col(int offset) { return (offset - (get_offset_row(offset) * 2 * MAX_COLS)) / 2; }

int print_char(char c, int col, int row, char attr) {
	unsigned char *vidmem = (unsigned char*) VIDEO_ADDRESS;
	if (!attr) attr = WHITE_ON_BLACK;

	if (col >= MAX_COLS || row >= MAX_ROWS) {
		vidmem[2 * MAX_COLS * MAX_ROWS - 2] = 'E';
		vidmem[2 * MAX_COLS * MAX_ROWS - 1] = RED_ON_WHITE;
		return get_offset(col, row);
	}

	int offset;
	if (col >= 0 && row >= 0) offset = get_offset(col, row);
	else offset = get_cursor_offset();

	if (c == '\n') {
		int rows = get_offset_row(offset);
		offset = get_offset(0, rows + 1);
	} else {
		vidmem[offset] = c;
		vidmem[offset + 1] = attr;
		offset += 2;
	}
	set_cursor_offset(offset);

	return offset;
}

void clear_screen() {
	int screen_size = MAX_COLS * MAX_ROWS;
	char *screen = (char*) VIDEO_ADDRESS;

	for (int i = 0; i < screen_size; i++) {
		screen[i * 2] = ' ';
		screen[i * 2 + 1] = WHITE_ON_BLACK;
	}
	set_cursor_offset(get_offset(0, 0));
}

void kprint_at(char *message, int col, int row) {
	int offset;
	if (col >= 0 && row >= 0) {
		offset = get_offset(col, row);
	} else {
		offset = get_cursor_offset();
		row = get_offset_row(offset);
		col = get_offset_col(offset);
	}

	int i = 0;
	while (message[i] != 0) {
		offset = print_char(message[i++], col, row, WHITE_ON_BLACK);
		row = get_offset_row(offset);
		col = get_offset_col(offset);
	}
}

void kprint(char *message) {
	kprint_at(message, -1, -1);
}
