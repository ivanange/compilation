%{
#include<stdio.h>
#include "simple.h"
#define nbMax
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
%token CHARACTERE
%token WORD
%token PO
%token PF
%token AOF
%token AF
%token EOL
%token VARIABLE
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
%token FSI
%token THEN
%token AO

%%
S:
  program  {printf("\n\n\t\t OK pourla syntaxe \n\n");}
 ;

 program :
 	START contenu END

contenu:
	stat
       | stat contenu

stat:
      bloc
     |blocSi
     |blocWhile


bloc:
      instr EOL
     |instr EOL bloc


instr:

     | VARIABLE '=' E { fprintf(yyout,"%s [%c], eax\n\n",affec,$1); }
     | PRINT VARIABLE {fprintf(yyout,"%s [%c] %s",afficher1,$2,afficher2);}
     | READ VARIABLE {fprintf(yyout,"%s %c %s",lire1,$2,lire2);}
     | VARIABLE '=' cond { fprintf(yyout,"%s [%c], eax\n\n",affec,$1); }
     /*| PRINT INTEGER {fprintf(yyout,"%s [%c] %s",afficher1,$2,afficher2);}*/

blocWhile:
     |WHILE etiquetWhile exp_bool LOOP blocIntWhile ENDWHILE {fprintf(yyout,";*************** ***** ****Réduction du bloc while\n");}

blocIntWhile:
     bloc
     |blocSi
     |blocSi blocIntWhile
     |bloc blocIntWhile

etiquetWhile:{
		compteurWhile++;
		fprintf(yyout,";********Lieu de l'étiquete\n");
		fprintf(yyout,"debutWhile%d:\n",compteurWhile);

	     }

LOOP:
      DO {
		fprintf(yyout,";*************** ***** ****Réduction du do\n");
         }

exp_bool:
     cond {
		fprintf(yyout,";*************** ***** ****Réduction de la condition\n");
		fprintf(yyout,"pop eax\ncmp eax,1\njne finWhile%d\n",compteurWhile);
	  }

ENDWHILE:
    DONE  {
	    fprintf(yyout,";*************** ***** ****Réduction du done\n");
	    fprintf(yyout,"jmp debutWhile%d\nfinWhile%d:\n",compteurWhile,compteurWhile);
	  }




blocSi:
      IF cond alo  bloc finSi
     |IF cond alo  bloc sino  bloc  finSi {fprintf(yyout,";Condition detectée 2\n");}

finSi:
      FSI{
	    if(sinonVu)
	    {
	      fprintf(yyout,"suite%d:\n",compteurSi);
	      fprintf(yyout,";Réduction du fsis%d\n",compteurSi);
	      sinonVu = 0;
	    }
	    else{
	      fprintf(yyout,"sinon%d:\n",compteurSi);
	      fprintf(yyout,";Réduction du fsi%d\n",compteurSi);
	    }


	 }


alo:
     THEN{
	    compteurSi++;
	    fprintf(yyout,";Réduction du THEN%d\n",compteurSi);
	    fprintf(yyout,"pop eax\ncmp eax,1\njne sinon%d\n",compteurSi);
	  }

sino:
     ELSE{
	    fprintf(yyout,"jmp suite%d\nsinon%d:\n",compteurSi,compteurSi);
	    fprintf(yyout,";Réduction du sinon%d\n",compteurSi);
	    sinonVu = 1;
	  }


cond:
     |PO F'=='F PF {
			compteurTest++;
			cmpEgal = ";Teste d'égalité\n";

			fprintf(yyout,"%s%sjne test%d\npush 1\njmp fintest%d \ntest%d:\npush 0\nfintest%d:\n\n\n",cmpEgal,cmp,compteurTest,compteurTest,compteurTest,compteurTest);

		      }

     |PO F'!='F PF {
			compteurTest++;
			cmpDifferent=";Teste de différence\n";

			fprintf(yyout,"%s%sjne test%d\npush 0\njmp fintest%d \ntest%d:\npush 1\nfintest%d:\n\n\n",cmpDifferent,cmp,compteurTest,compteurTest,compteurTest,compteurTest);

		      }

     |PO F'<'F PF  {
			compteurTest++;
                       cmpInferieur=";Teste d'infériorité\n";
			fprintf(yyout,"%s%sjge test%d\npush 1\njmp fintest%d \ntest%d:\npush 0\nfintest%d:\n\n\n",cmpInferieur,cmp,compteurTest,compteurTest,compteurTest,compteurTest);

		      }
     |PO F'>'F PF  {
		       compteurTest++;
		       cmpSuperieur=";Teste de superiorité\n";

		       fprintf(yyout,"%s%sjg test%d\npush 0\njmp fintest%d \ntest%d:\npush 1\nfintest%d:\n\n\n",cmpSuperieur,cmp,compteurTest,compteurTest,compteurTest,compteurTest);
		      }


E:
   T;
   | E '+' T { fprintf(yyout,"%s ",add); }


T:
   F ;
   | T '*' F { fprintf(yyout,"%s ",mul); }

F:
    INTEGER { fprintf(yyout,"push %d\n",$1);}
    | PO VARIABLE PF { fprintf(yyout,"%s [%c] \npush eax\n",take,$2);}
    |  VARIABLE  { fprintf(yyout,"%s [%c] \npush eax\n",take,$1);}





%%

int main(void)
{
 yyout=fopen("test.asm","w");
 fprintf(yyout,"%s",header);


 yyparse();

 fprintf(yyout,"%s",trailer);
fclose(yyout);
 return 0;


}

int yyerror(char *str)
{
	printf("erreur parsing %s\n",str);
	return 0;
}
