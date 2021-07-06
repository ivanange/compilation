%{
#include <stdio.h>
# include "test.tab.h"
FILE *yyin;
int compteurSi = 0, compteurTest = 0, compteurWhile = 0;
FILE *yyout;

char *header="extern printf,scanf \nsection .data\n; declaration des variables en memoire\na:  dd  0\nb:  dd  0\nc:  dd  0\nd:  dd  0\nfmt:db \"%d\", 10, 0 \nfmtlec:db \"%d\",0\nsection .text\nglobal _start\n\n_start:\n\n";

char *trailer="mov eax,1 ; sys_exit \nmov ebx,0; Exit with return code of 0 (no error)\nint 80h";
char *add=" ; addition\npop eax\npop ebx\nadd eax,ebx\npush eax\n\n";
char *mul=" ;multiplication\npop eax\npop ebx\nmul ebx\npush eax\n\n";
char *affec=" ;affectation\npop eax\nmov";
char *take=" ;recuperation en memoire\nmov eax,";
char *affec1=";affectation\n";
char *afficher1=";affiher\nmov eax,";
char *afficher2="\npush eax\npush dword fmt\ncall printf\n\n";
char *lire1=";lire\npush ";
char *lire2="\npush dword fmtlec\ncall scanf\n\n";
char *cmp = "pop ebx\npop eax\ncmp eax, ebx\n\n";
char *cmpEgal;
char *testGene;
char *cmpDifferent;
char *cmpSuperieur;
char *cmpInferieur;
char *tmp1,*tmp2;
int sinonVu = 0;
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
	|PRINT E { printf("\n%d\n", $2); fprintf(yyout,"%s %d %s", afficher1, $2, afficher2); }
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
 |T	  { printf("\n Réduction E ----> T        $1=%d\t$$=%d",$1,$$); }

T:
  T '*' F {printf("\n Réduction T ----> T * F    $1=%d\t $2=%d \t $3=%d \t $$=%d",$1,$2,$3,$$); }
 |T '+' F {printf("\n Réduction T ----> T + F    $1=%d\t $2=%d \t $3=%d \t $$=%d",$1,$2,$3,$$); }
 |T '/' F {printf("\n Réduction T ----> T / F    $1=%d\t $2=%d \t $3=%d \t $$=%d",$1,$2,$3,$$); }
 |T '-' F {printf("\n Réduction T ----> T - F    $1=%d\t $2=%d \t $3=%d \t $$=%d",$1,$2,$3,$$); }
 |F       {printf("\n Réduction T ----> F        $1=%d\t$$=%d",$1,$$); }
 
F:
  INTEGER {printf("\n Réduction F ----> int      $1=%d\t$$=%d",$1,$$);}
 |PO E PF    { $$ = $2; printf("\n Réduction F ----> (E)     $1=%d\t $2=%d \t $3=%d \t $$=%d",$1,$2,$3,$$);}
 
 
 cond:
     | F
%%


main(int argc, char **argv)
{

    printf("parsing %s\n", argv[1]);
    if(argc > 1) {
        if(!(yyin = fopen(argv[1], "r"))) {
            perror(argv[1]);
            return (1);
        }
        yyout=fopen("test.asm","w");
 	fprintf(yyout,"%s",header);
    }
yyparse();
 fprintf(yyout,"%s",trailer);
fclose(yyout);
}
yyerror(char *s)
{
fprintf(stderr, "error: %s\n", s);
}
