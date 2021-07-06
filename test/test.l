%option noyywrap
%{
# include "test.tab.h"
int yylval;
%}

entier [0-9]+
operateur \+|\*|\=|\=\=|\!\=|\<|\>|\-|\/

bloc \{|\}

IF "if"
ELSE "else"

/* variable  @[a-zA-Z]+(\_|\-)*[0-9]*  */
variable  @(a|b|c|d) 

%%
{entier} { yylval=atoi(yytext);return INTEGER;}
{variable}  {yylval=*yytext; return WORD;}

{operateur} {return *yytext;}
"do" {return DO;}
"while"  {return WHILE;}
"for"  {return FOR;}
"if"  {return IF;}
"else"  {return ELSE;}
"\{"  {return AO;}
"\}"  {return AF;}
"\("  {return PO;}
"\)"  {return PF;}
"\;"  {return EOL;}
"start" {return START;}
"open" {return OPEN;}
"close" {return CLOSE;}
"end" {return END;}
"print" {return PRINT; }
"read" {return READ;}
"then" {return THEN;}
"done" {return DONE;}
"to" {return TO;}
[\n\t ]+  {};
. { printf("parse error (lex) + %s -\n",yytext); }


%%



