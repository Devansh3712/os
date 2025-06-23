// Placeholder to prevent the compiler/linker from thinking that
// the function main() is the entry point of the program
// Forces us to create a kernel entry function instead of jumping to
// kernel.c:0x00
void test_entrypoint() {}

void main() {
	char* video_memory = (char*)0xB8000;
	*video_memory = 'X';
}
