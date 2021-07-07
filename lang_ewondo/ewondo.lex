%{
#include<stdio.h>
#include "simple.h"

%}


entier [0-9]+
operateur \+|\*|\=|\=\=|\!\=|\<|\>|\-|\/
/*parenthese \(|\)*/
/* variable a|b|c|d */
variable  [abcd]

%%
{entier} { yylval=atoi(yytext);return INTEGER;}
{operateur} {return *yytext;}
{variable}  {yylval=*yytext; return VARIABLE;}
til {return PRINT; }
nge  {return IF;}
ndo {return THEN;}
sena {return ELSE;}
"\;"  {return EOL;}
"\("  {return PO;}
"\)"  {return PF;}
bo {return DO;}
manabo {return FSI;}
mana {return END;}
ntie  {return WHILE;}
asu  {return FOR;}
tari {return START;}
lang {return READ;}
man {return DONE;}
ya {return TO;}
[\n] ;
[ ] ;
[\t] ;
. { printf("parse error (lex) + %s -\n",yytext); }


%%

/*flex -o tp7.yy.c tp7.lex
gcc -pedantic -Wall -O2 exo15.yy.c -o exo15 -lfl
utilisation : echo "12+6*8" | ./exo15 */
