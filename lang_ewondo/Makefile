all: test

ewondo: ewondo.y ewondo.lex
	bison --defines=simple.h -v -o ewondo.c ewondo.y
	flex -o ewondo.yy.c ewondo.lex
	gcc ewondo.yy.c ewondo.c -o ewondo -lfl

test: test.o ewondo
	ld -s -o test test.o -melf_i386 -I/lib/ld-linux.so.2 -lc

test.o: test.asm
	nasm -f elf -o test.o test.asm
