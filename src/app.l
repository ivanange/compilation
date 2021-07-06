%option noyywrap
%{
# include "app.tab.h"
int yylval;
%}

entier [0-9]+
<<<<<<< HEAD
operateur \+|\*|\=|\=\=|\!\=|\<|\>|\-|\/
=======
operateur \+|\*|\=|\=\=|\!\=|\<|\>|\-|\/|\,
>>>>>>> master

bloc \{|\}

IF "if"
ELSE "else"

/* variable  @[a-zA-Z]+(\_|\-)*[0-9]*  */
variable  @(a|b|c|d) 

%%
{entier} { yylval=atoi(yytext);return INTEGER;}
{variable}  {yylval=*yytext; return WORD;}

{operateur} {return *yytext;}
"bo" {return DO;}
"ntie"  {return WHILE;}
"asu"  {return FOR;}
"nge"  {return IF;}
"së na"  {return ELSE;}
"\{"  {return AO;}
"\}"  {return AF;}
"\("  {return PO;}
"\)"  {return PF;}
"\;"  {return EOL;}
"tari" {return START;}
"open" {return OPEN;}
"close" {return CLOSE;}
"manabo" {return END;}
"til" {return PRINT; }
"lang" {return READ;}
"ndo" {return THEN;}
"man" {return DONE;}
"ya" {return TO;}
[\n\t ]+  {};
. { printf("parse error (lex) + %s -\n",yytext); }

%%

/*flex -o tp7.yy.c tp7.lex
gcc -pedantic -Wall -O2 exo15.yy.c -o exo15 -lfl
utilisation : echo "12+6*8" | ./exo15 */


