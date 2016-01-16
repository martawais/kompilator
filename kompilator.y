%{
#define YYSTYPE int
#define STACK_SIZE 20
#include<stdio.h>
#include<string.h>

extern int yylineno; // z lex-a
extern char *yytext;
extern FILE *yyin;
extern int yylex();

char zadeklarowaneZmienne[256][256];
int wartosciZmiennych[256];
int iloscZadeklarowanych[256];
int licznik = 0;

int deklaracja = 1;
int cialoFunkcji = 0;
char zmiennaPodKtoraPodstawiam[256];
int pozycja1 = 0;
int pozycja2 = 0;
int licznikDlugosciPetli = 0;
int licznikPoczatkuPetli = 0;
int k = 0;

char komendy[256][256];
char bufor[20];



int sprawdzenieDeklaracjiZmiennej(char *yytext) {
	int pozycja = 10000;
	int i;
	for(i=0; i<licznik; i++) {
		int compare = strcmp(zadeklarowaneZmienne[i], yytext);
		if(	compare == 0) {
			return i;
		}
	}
	

	return pozycja;
}

void pobranieLiczby(int i) {
	scanf("%d", &wartosciZmiennych[i]);
};

%}

%token DECLARE
%token ENDLINE
%token WHILE
%token DO
%token ENDWHILE
%token VARIABLE
%token PLUS
%token MINUS
%token MNOZENIE
%token DZIELENIE
%token RESZTA
%token IF
%token THEN
%token ELSE
%token ENDIF
%token PUT
%token WIEROW
%token MNIROW
%token WIEKSZE
%token MNIEJSZE
%token END
%token IN
%token ENDINS
%token PRZYPISANIE
%token GET
%token LNAW
%token PNAW
%token LICZBA


%%
input:
    | input line
;
line: DECLARE expe ENDLINE 	{	
									printf("			koniec deklaracji\n");
									int i;
									for(i=0; i<licznik; i++) {
										printf("			%s",zadeklarowaneZmienne[i]);
										printf(":	%d\n",iloscZadeklarowanych[i]);
									}
									deklaracja = 0;
									cialoFunkcji = 1;
								}
	| IN expe expc END	{	
									printf("			koniec ciala funkcji\n");
									 
									cialoFunkcji = 0;
									int i;
									for(i=0; i<licznik; i++) {
										printf("			%s",zadeklarowaneZmienne[i]);
										printf(":	%d\n",wartosciZmiennych[i]);
									}
									printf("			-----HALT-----\n");
									strcpy(komendy[k],"HALT");
									
									for(i=0; i<k+1; i++) {
										printf("%d:  %s\n",i,komendy[i]);
									}
									return 0;
								}
	
;
expe: VARIABLE	{	
						if (deklaracja == 1) {
							//printf("			!- %s\n", yytext); 
							strcpy(zadeklarowaneZmienne[licznik], yytext);
							iloscZadeklarowanych[licznik] = 0;
							licznik++;
						}
						if (cialoFunkcji == 1) {
							strcpy(zmiennaPodKtoraPodstawiam, yytext);
							
							printf("			!- cos sie dzieje???%s\n", yytext); 
							}
					}

	
	| expe ENDINS expt	{ }
	| expe expt	{ }
	| GET VARIABLE 	{ 
						if (cialoFunkcji == 1) {
							int pozycja = sprawdzenieDeklaracjiZmiennej(yytext);
							if (pozycja == 10000) {
								printf("uzycie niezadeklarowanej zmiennej!\n");
								return 0;
							}
							else {
								printf("			- ZADEKLAROWANA ZMIENNA\n");
								pobranieLiczby(pozycja);
								printf("			- %d\n", wartosciZmiennych[pozycja]);
							}
							printf("			-----READ %d-----\n",pozycja);
							sprintf(bufor, "READ %d", pozycja);
							strcpy(komendy[k],bufor);
							k++;
						}
					}
	
;

expt: VARIABLE		{	
						if (deklaracja == 1) {
							//printf("			!- %s\n", yytext); 
							int pozycja = sprawdzenieDeklaracjiZmiennej(yytext);
							if (pozycja == 10000) {
								strcpy(zadeklarowaneZmienne[licznik], yytext);
								iloscZadeklarowanych[licznik] = 0;
								licznik++;
							}
							else {
								printf("\nPODWOJNE ZADEKLAROWANIE TEJ SAMEJ ZMIENNEJ!\n");
								return 0;
							}
							
						}
						if (cialoFunkcji == 1) {
							strcpy(zmiennaPodKtoraPodstawiam, yytext);
							
							printf("			!- cos sie dzieje???%s\n", yytext); 
							}
						
					}
	| expt LNAW expq PNAW		{  }
	| WHILE expz DO ENDLINE {}
	| ENDWHILE ENDLINE	{
							printf("			-----JUMP %d-----\n",licznikPoczatkuPetli); 
							sprintf(bufor, "JUMP %d", licznikPoczatkuPetli);
							strcpy(komendy[k],bufor);
							
							sprintf(bufor, "%s %d",komendy[licznikPoczatkuPetli],k);
							strcpy(komendy[licznikPoczatkuPetli],bufor);
							k++;
						}
	| IF expy THEN expy ENDINS ELSE expy ENDINS ENDIF ENDLINE{ printf("\nWEJSCIE DO IF!\n"); }
	| PRZYPISANIE expq {}
	| GET VARIABLE	{ 
						printf("			!- ciałfsadvfavd unkcji%s\n", yytext); 
						if (cialoFunkcji == 1) {
							int pozycja = sprawdzenieDeklaracjiZmiennej(yytext);
							if (pozycja == 10000) {
								printf("uzycie niezadeklarowanej zmiennej!\n");
								return 0;
							}
							else {
								printf("			- ZADEKLAROWANA ZMIENNA\n");
								pobranieLiczby(pozycja);
								printf("			- %d\n", wartosciZmiennych[pozycja]);
							}
						
							printf("			- GET %s\n", yytext);
							printf("			-----READ-----\n");
							sprintf(bufor, "READ %d", pozycja);
							strcpy(komendy[k],bufor);
							k++;
						}
					}
;

expq: LICZBA		{	
						if (deklaracja == 1) {
							//printf("			- %s\n", yytext);
							iloscZadeklarowanych[licznik-1] = atoi(yytext);
						}
						if (cialoFunkcji == 1) {
							printf("			!- przypisanie- liczba %s\n", yytext); 
							pozycja1 = sprawdzenieDeklaracjiZmiennej(zmiennaPodKtoraPodstawiam);
							if (pozycja1 == 10000) {
								printf("\nUZYCIE NIEZADEKLAROWANEJ ZMIENNEJ!\n");
								return 0;
							}
							else {
								wartosciZmiennych[pozycja1] = atoi(yytext);
								
							}
						}
					}
	
	| VARIABLE 		{ 
						if (cialoFunkcji == 1) {
							printf("			!- przypisanie- variable  %s\n", yytext); 
							pozycja1 = sprawdzenieDeklaracjiZmiennej(zmiennaPodKtoraPodstawiam);
							if (pozycja1 == 10000) {
								printf("\nUZYCIE NIEZADEKLAROWANEJ ZMIENNEJ!\n");
								return 0;
							}
							else {
								pozycja2 = sprawdzenieDeklaracjiZmiennej(yytext);
								wartosciZmiennych[pozycja1] = wartosciZmiennych[pozycja2];
								if( pozycja1 != pozycja2) {
									printf("			-----COPY %d %d-----\n",pozycja1,pozycja2);
									sprintf(bufor, "COPY %d %d", pozycja1,pozycja2);
									strcpy(komendy[k],bufor);
									
									k++;
								}
							}
						}
					}
	| expq expw	{ }
;
expw: PLUS	expr		{
						printf("			...+... \n");
					}
	| MINUS	expr		{
						printf("			...-... \n");
					}
	| MNOZENIE	expr		{
						printf("			-----SHL %d-----\n",pozycja1); 
						sprintf(bufor, "SHL %d", pozycja1);
						strcpy(komendy[k],bufor);
						k++;
					}
	| DZIELENIE	expr		{
						printf("			-----SHR %d-----\n",pozycja1);
						sprintf(bufor, "SHR %d", pozycja1);
						strcpy(komendy[k],bufor);						
						k++;
					}
	| RESZTA	expr		{
						printf("			...%... \n");
					}

			
;

expr: VARIABLE		{
						pozycja1 = sprawdzenieDeklaracjiZmiennej(zmiennaPodKtoraPodstawiam);
								if (pozycja1 == 10000) {
									printf("\nUZYCIE NIEZADEKLAROWANEJ ZMIENNEJ!\n");
									return 0;
								}
								else {
									pozycja2 = sprawdzenieDeklaracjiZmiennej(yytext);
									wartosciZmiennych[pozycja1] = wartosciZmiennych[pozycja2];
									if (pozycja1 != pozycja2) {
										printf("			-----COPY %d %d-----\n",pozycja1,pozycja2);
										sprintf(bufor, "COPY %d %d", pozycja1,pozycja2);
										strcpy(komendy[k],bufor);	
										k++;
									}
								}
						
					}
	| LICZBA		{
					
						printf("			-g %s\n", yytext);
					}

  
;

expy: VARIABLE	{
						pozycja1 = sprawdzenieDeklaracjiZmiennej(yytext);
								if (pozycja1 == 10000) {
									printf("\nUZYCIE NIEZADEKLAROWANEJ ZMIENNEJ!\n");
									return 0;
								}
								else {
										printf("			-----COPY %d %d-----\n",licznik,pozycja1);
										sprintf(bufor, "COPY %d %d", licznik,pozycja1);
										strcpy(komendy[k],bufor);
										k++;
								}
					}
	| expy expu
	| PUT LICZBA {
						printf("			-----WRITE %d-----\n",licznik);
						sprintf(bufor, "WRITE %d", licznik);
						strcpy(komendy[k],bufor);
						k++;
					}	
;
expu: WIEKSZE VARIABLE {
						pozycja2 = sprawdzenieDeklaracjiZmiennej(yytext);
						printf("			-----SUB %d %d-----\n",licznik,pozycja2);
						sprintf(bufor, "SUB %d %d", licznik, pozycja2);
						strcpy(komendy[k],bufor);
						k++;
					}
	| MNIEJSZE VARIABLE {
						pozycja2 = sprawdzenieDeklaracjiZmiennej(yytext);
						printf("			-----SUB %d %d-----\n",licznik,pozycja2);
						sprintf(bufor, "SUB %d %d", licznik, pozycja2);
						strcpy(komendy[k],bufor);
						k++;
					}
;
expz: VARIABLE	{
						pozycja1 = sprawdzenieDeklaracjiZmiennej(yytext);
								if (pozycja1 == 10000) {
									printf("\nUZYCIE NIEZADEKLAROWANEJ ZMIENNEJ!\n");
									return 0;
								}
							
					}
	| expz expx
;
expx: WIEKSZE LICZBA {
						if ( atoi(yytext) == 0 ) {
							printf("			-----JZERO %d-----\n",pozycja1);
							sprintf(bufor, "JZERO %d", pozycja1);
							strcpy(komendy[k],bufor);
							licznikPoczatkuPetli = k;
							printf("\n!!!!!!!!!!!!!!!%d\n",k);
							k++;
						}
					}
;
expc: ENDINS
	| 
;
%%
int yyerror(char *s)
{
    printf("%s\n",s);	
    return 0;
}

int main( int argc, char **argv )
{
	++argv, --argc;  /* skip over program name */
	if ( argc > 0 ) {
		yyin = fopen( argv[0], "r" );
	}

    do {
		yyparse();
	} while (!feof(yyin));
    printf("Przetworzono linii: %d\n",yylineno-1);
    return 0;
}
