#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *yyin;
#define nbMax
int compteurSi = 0, compteurTest = 0, compteurWhile = 0, label = 0;
FILE *yyout;

char *header = "extern printf,scanf \nsection .data\n; declaration des variables en memoire\n @a:  dd  0\n @b:  dd  0\n @c:  dd  0\n @d:  dd  0\nfmt:db \"%d\", 10, 0 \nfmtlec:db \"%d\",0\nsection .text\nglobal _start\n\n_start:\n\n";

char *trailer = "mov eax,1 ; sys_exit \nmov ebx,0; Exit with return code of 0 (no error)\nint 80h\n";
char *add = " ; addition\npop eax\npop ebx\nadd eax,ebx\npush eax\n\n";
char *mul = " ;multiplication\npop eax\npop ebx\nmul ebx\npush eax\n\n";
char *affec = " ;affectation\npop eax\nmov";
char *take = " ;recuperation en memoire\nmov eax,";
char *affec1 = ";affectation\n";
char *afficher1 = ";affiher\nmov eax,";
char *afficher2 = "\npush eax\npush dword fmt\ncall printf\n\n";
char *lire1 = ";lire\npush ";
char *lire2 = "\npush dword fmtlec\ncall scanf\n\n";
char *cmp = "pop ebx\npop eax\ncmp eax, ebx\n\n";
int sinonVu = 0;

void push0()
{
    fprintf(yyout, "push0: push 0\n jmp edx\n");
}

void push1()
{
    fprintf(yyout, "push1: push 1\n jmp edx\n");
}

void head()
{
    fprintf(yyout, "%s", header);
}

void tail()
{
    fprintf(yyout, "%s", trailer);
    push0();
    push1();
}

void word(char *var)
{
    fprintf(yyout, "mov eax, [%s]\n push eax\n", var);
}

void integer(int val)
{
    fprintf(yyout, "push %d\n", val);
}

void print()
{
    fprintf(yyout, "push dword fmt\n call printf\n");
}

void lop(char *op)
{
    label++;
    fprintf(yyout, "mov edx, label%d \npop eax\n pop ebx\n cmp eax, ebx \n", label);
    if (!strcmp(op, "=="))
    {
        fprintf(yyout, "je push1\n");
    }
    else if (!strcmp(op, "!=") || !strcmp(op, "=!"))
    {
        fprintf(yyout, "jne push1\n");
    }
    else if (!strcmp(op, "<"))
    {
        fprintf(yyout, "jl push1\n");
    }
    else if (!strcmp(op, ">"))
    {
        fprintf(yyout, "jg push1\n");
    }
    else if (!strcmp(op, "<="))
    {
        fprintf(yyout, "jle push1\n");
    }
    else
    {
        fprintf(yyout, "jge push1\n");
    }
    fprintf(yyout, "jmp push0\n label%d:\n", label);
}

void unary_minus()
{
    fprintf(yyout, "pop eax\n imul -1\n push eax\n");
}

void aop(char *op)
{
    fprintf(yyout, "pop ebx\n pop eax\n");
    if (!strcmp(op, "+"))
    {
        fprintf(yyout, "add eax, ebx \n");
    }
    else
    {
        fprintf(yyout, "sub eax, ebx\n");
    }
    fprintf(yyout, "push eax\n");
}

void gop(char *op)
{
    fprintf(yyout, "pop ebx\n pop eax\n");
    if (!strcmp(op, "*"))
    {
        fprintf(yyout, "imul ebx \n");
    }
    else if (!strcmp(op, "%"))
    {
        fprintf(yyout, "idiv ebx\n mov eax, edx\n");
    }
    else
    {
        fprintf(yyout, "idiv ebx\n");
    }
    fprintf(yyout, "push eax\n");
}

void assign(char *var)
{
    fprintf(yyout, "pop eax\n mov [%s], eax\n", var);
}

void read(char *var)
{
    fprintf(yyout, "push %s\n push dword fmtlec\n call scanf\n", var);
}