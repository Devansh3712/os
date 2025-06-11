.PHONY: run clean

run:
	nasm -f bin $(file).asm -o $(file).bin
	qemu-system-x86_64 $(file).bin

clean:
	rm *.bin
