.PHONY: compile clean

compile:
	nasm -f bin $(file).asm -o $(file).bin

clean:
	rm *.bin
