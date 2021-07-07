extern printf,scanf 
section .data
; declaration des variables en memoire
 @a:  dd  0
 @b:  dd  0
 @c:  dd  0
 @d:  dd  0
fmt:db "%d", 10, 0 
fmtlec:db "%d",0
section .text
global _start

_start:

push @b
 push dword fmtlec
 call scanf
mov eax, [@b]
 push eax
push 0
push 12
pop ebx
 pop eax
sub eax, ebx
push eax
push 3
pop ebx
 pop eax
imul ebx 
push eax
push 4
pop ebx
 pop eax
idiv ebx
push eax
pop ebx
 pop eax
add eax, ebx 
push eax
pop eax
 mov [@a], eax
mov eax, [@a]
 push eax
push dword fmt
 call printf
mov eax,1 ; sys_exit 
mov ebx,0; Exit with return code of 0 (no error)
int 80h
push0: push 0
 jmp edx
push1: push 1
 jmp edx
