extern printf,scanf 
section .data
; declaration des variables en memoire
a:  dd  0
b:  dd  0
c:  dd  0
d:  dd  0
fmt:db "%d", 10, 0 
fmtlec:db "%d",0
section .text
global _start

_start:

;lire
push  a 
push dword fmtlec
call scanf

 ;recuperation en memoire
mov eax, [a] 
push eax
push 2
;Teste de superiorité
pop ebx
pop eax
cmp eax, ebx

jg test1
push 0
jmp fintest1 
test1:
push 1
fintest1:


;Réduction du THEN1
pop eax
cmp eax,1
jne sinon1
;affiher
mov eax, [a] 
push eax
push dword fmt
call printf

sinon1:
;Réduction du fsi1
mov eax,1 ; sys_exit 
mov ebx,0; Exit with return code of 0 (no error)
int 80h