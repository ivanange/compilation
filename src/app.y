%{
#include <stdio.h>
# include "app.tab.h"
FILE *yyin;
%}

%token INTEGER
%token WORD
%token PO
%token PF
%token AOF
%token AF
%token EOL
%token IF
%token ELSE
%token DO
%token WHILE
%token FOR
%token START
%token OPEN
%token CLOSE
%token END
%token PRINT
%token READ
%token DONE
%token TO
%token THEN
%token AO


%%
S:
  program	{printf("\n Réduction S ----> E    Fin!!!\n"); }
  
program :
	START contenu END

contenu :
	bloc
	|blocsi
	|blocwhile
	|blocfor 
	
bloc :
	instr EOL
	|instr  EOL contenu 
	
	
instr :
	WORD '=' E
	|PRINT E { printf("%s", $1); }
	|READ E
	|WORD '=' cond
	
blocsi :
	IF PO cond PF THEN contenu DONE 
	|IF  PO cond PF THEN contenu ELSE contenu DONE
	
	
	
blocwhile : 
	
	 WHILE PO cond PF DO contenu DONE
	 
blocfor :
	FOR PO instr TO E ',' E PF	DO contenu  DONE  
	 
	
	 

E:
  E '+' T {printf("\n Réduction E ----> E + T    $1=%d\t $2=%d \t $3=%d \t $$=%d",$1,$2,$3,$$); }
 |E '*' T {printf("\n Réduction E ----> E * T    $1=%d\t $2=%d \t $3=%d \t $$=%d",$1,$2,$3,$$); }
 |E '-' T {printf("\n Réduction E ----> E - T    $1=%d\t $2=%d \t $3=%d \t $$=%d",$1,$2,$3,$$); }
 |E '/' T {printf("\n Réduction E ----> E / T    $1=%d\t $2=%d \t $3=%d \t $$=%d",$1,$2,$3,$$); }
 |T	  {printf("\n Réduction E ----> T        $1=%d\t$$=%d",$1,$$); }

T:
  T '*' F {printf("\n Réduction T ----> T * F    $1=%d\t $2=%d \t $3=%d \t $$=%d",$1,$2,$3,$$); }
 |T '+' F {printf("\n Réduction T ----> T + F    $1=%d\t $2=%d \t $3=%d \t $$=%d",$1,$2,$3,$$); }
 |T '/' F {printf("\n Réduction T ----> T / F    $1=%d\t $2=%d \t $3=%d \t $$=%d",$1,$2,$3,$$); }
 |T '-' F {printf("\n Réduction T ----> T - F    $1=%d\t $2=%d \t $3=%d \t $$=%d",$1,$2,$3,$$); }
 |F       {printf("\n Réduction T ----> F        $1=%d\t$$=%d",$1,$$); }
 
F:
  INTEGER {printf("\n Réduction F ----> int      $1=%d\t$$=%d",$1,$$); }
 |PO E PF    {printf("\n Réduction F ----> (E)     $1=%d\t $2=%d \t $3=%d \t $$=%d",$1,$2,$3,$$); }
 
 
 cond:
     | F'=='F

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
