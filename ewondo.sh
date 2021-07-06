./bin/app.exe $1
nasm -f elf -o test.o test.asm
ld -s -o test test.o -melf_i386 -I/lib/ld-linux.so.2 -lc
