%option noyywrap
%{
# include "test.tab.h"
%}

entier [0-9]+
operateur_ari \+|-
operateur_geo \*|\/|%
operateur_log ==|!=|=!|<|>|<=|>=

bloc \{|\}

IF "if"
ELSE "else"

/* variable  @[a-zA-Z]+(\_|\-)*[0-9]*  */
variable  @(a|b|c|d) 

%%
{entier} { yylval.ival = atoi(yytext); return INTEGER;}
{variable}  {yylval.sval = strdup(yytext); return WORD;}

{operateur_ari} {yylval.sval = strdup(yytext); return AOP;}
{operateur_log} {yylval.sval = strdup(yytext); return LOP;}
{operateur_geo} {yylval.sval = strdup(yytext); return GOP;}
"=" {return EQUAL;}
"-" {return UMINUS;}
"bo" {return DO;}
"ntie"  {return WHILE;}
"asu"  {return FOR;}
"nge"  {return IF;}
"së na"  {return ELSE;}
"\("  {return PO;}
"\)"  {return PF;}
"\."  {return EOL;}
"tari" {return START;}
"manabo" {return END;}
"til" {return PRINT; }
"lang" {return READ;}
"ndo" {return THEN;}
"man" {return DONE;}
"ya" {return TO;}
[\n\t ]+  {};
. { printf("parse error (lex) + %s -\n",yytext); }

%%



