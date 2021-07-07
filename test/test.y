%{
#include <stdio.h>
# include "utils.h"
%}

%union
{
    int ival;
}


%union
{
    char *sval;
}


%token<ival> INTEGER
%token<sval> WORD
%token<sval> PO PF
%token<sval> EOL
%token<sval> IF ELSE THEN
%token<sval> DO DONE
%token<sval> WHILE
%token<sval> FOR TO
%token<sval> START END
%token<sval> PRINT READ
%token<sval> AOP GOP LOP UMINUS EQUAL

%type <sval> S program contenu bloc instr blocsi blocwhile blocfor
%type <ival> E L T N F 

%left '+' '-'
%left '*' '/'
%nonassoc UMINUS '%'


%%
S:
  program	{
	  printf("\n compiled in \n"); 
	}
;
 
program:
	START contenu END {
	}
;

contenu:
	bloc
	|blocsi
	|blocwhile
	|blocfor 
;	

bloc:
	instr EOL
	|instr  EOL contenu 
	
;
	
instr:
	WORD EQUAL E {
		printf("instr ----> WORD = E \t WORD = %s \t E = %d\n", $1, $3);
		assign($1);
	}

	|PRINT E { 
		printf("instr ----> print E \t E = %d\n", $2);
		print();
	}

	|READ WORD { 
		printf("instr ----> read WORD \t WORD = %s\n", $2);
		read($2);
	}
;

blocsi:
	IF E THEN contenu DONE 
	|IF  E THEN contenu ELSE contenu DONE
;

blocwhile: 
	 WHILE E DO contenu DONE
;	

blocfor:
	FOR WORD EQUAL E TO E ',' E 	DO contenu  DONE  
;	 

E:
  E LOP L {
	  printf("E ----> E LOP L \t E=%d\t LOP=:%s \t L=%d \t $$=%d ", $1, $2, $3, $$);
	  lop($2);
	}

  |L {
	  printf("E ----> L \t L=%d \t $$=%d ", $1, $$);
	}
;

L:
  L AOP T {
	  printf("L ----> L AOP T    L=%d\t AOP=:%s \t T=%d \t $$=%d", $1, $2, $3, $$);
	  aop($2); 
	}


  |T {
	   printf("L ----> T \t T=%d \t $$=%d", $1, $$); 
   }
;

T:
   T GOP N {
	   printf("T ----> T GOP F    T=%d\t GOP=:%s \t F=%d \t $$=%d", $1, $2, $3, $$); 
	   gop($2);
	}

  |N  {
	printf("T ----> N \t N=%d  \t $$=%d", $1, $$); 
   }  
;

N:  
	F {
		printf("N ----> F \t N=%d  \t $$=%d", $1, $$); 
	}
;

F:
  	INTEGER {
	  printf("F ----> int \t int=%d \t $$=%d ", $1, $$);
	  integer($1);
	}

 	|WORD {
	  printf("F ----> var \t var=%s \t $$=%d", $1, $$); 
	  word($1);
 	}

 	|PO E PF { 
	  $$ = $2; 
	  printf("F ----> (E)  \t PO=%d \t E=%d \t PF=%d \t $$=%d", $1, $2, $3, $$); 
	}
; 
 
%%

main(int argc, char **argv)
{
    printf("parsing %s\n", argv[1]);
    if(argc > 1 && (yyin = fopen(argv[1], "r"))) {
        yyout=fopen("test.asm","w");
    }
	else {
		perror(argv[1]);
		return (1);
	}

	head();
	yyparse();
 	tail();
	fclose(yyout);

}

yyerror(char *s) {
	fprintf(stderr, "error: %s\n", s);
}

	// UMINUS F { 
	//    printf("L ----> -T \t T=%d  \t $$=%d", $2, $$); 
	//    unary_minus();
	//    $$ = $2;
    // }