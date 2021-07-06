CFLAGS= -g3 -c -Wall
CC= gcc
SRC = src
TESTSCR = test
LIB = lib
OBJ = obj
BIN = bin
FILES=$(SRC)/app.l $(SRC)/app.y
TESTFILES=$(TESTSCR)/test.l $(TESTSCR)/test.y
file = test_code.ewondo


all :  test 

app: $(FILES)
	bison -d $(SRC)/app.y
	flex $(SRC)/app.l
	cc -o $(BIN)/app.exe app.tab.c lex.yy.c -lfl

test: $(TESTFILES)
	bison -d $(TESTSCR)/test.y
	flex $(TESTSCR)/test.l
	cc -o $(BIN)/test.exe test.tab.c lex.yy.c -lfl

clean: 
	rm -rf $(OBJ)/*.o
	rm -rf $(BIN)/*.exe

empty: 
	del /F /Q $(OBJ)\*.o
	del /F /Q $(BIN)\*.exe

run-test: test
	./$(BIN)/test.exe $(file)
	nasm -f elf -o test.o test.asm
	ld -s -o tester test.o -melf_i386 -I/lib/ld-linux.so.2 -lc

run-app: app
	./$(BIN)/app.exe $(file)
