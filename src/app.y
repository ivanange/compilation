%{
#include <stdio.h>
# include "app.tab.h"
FILE *yyin;
%}

/* declare tokens */
%token NUMBER
%token ADD SUB MUL DIV ABS
%token EOL
%%
calclist: 
| calclist exp EOL { printf("= %d\n", $1); }
;
exp: factor
| exp ADD factor { $$ = $1 + $3; }
| exp SUB factor { $$ = $1 - $3; }
;
factor: term 
| factor MUL term { $$ = $1 * $3; }
| factor DIV term { $$ = $1 / $3; }
;
term: NUMBER
| ABS term { $$ = $2 >= 0? $2 : - $2; }
;
%%
main(int argc, char **argv)
{
    printf("parsing %s\n", argv[1]);
    if(argc > 1) {
        if(!(yyin = fopen(argv[1], "r"))) {
            perror(argv[0]);
            return (1);
        }
    }
yyparse();
}
yyerror(char *s)
{
fprintf(stderr, "error: %s\n", s);
}