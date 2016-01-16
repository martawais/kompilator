%option noyywrap
%option yylineno
%{
#include "kompilator.tab.h"

int yylex();
%}
%%



^DECLARE\n { return DECLARE; }
^IN\n	{ return IN; }
^END\n	{ return END; }
\n	{ return ENDLINE; }
[;]\n	{ return ENDINS; }
\:=	{ return PRZYPISANIE; }
IF	{ return IF; }
THEN	{ return THEN; }
ELSE	{ return ELSE; }
ENDIF	{ return ENDIF; }
WHILE 	{return WHILE; }
DO	{ return DO; }
ENDWHILE {return ENDWHILE;}
PUT	{ return PUT; }
\>=	{ return WIEROW; }
\<= 	{ return MNIROW; }
\>	{ return WIEKSZE; }
\<	{ return MNIEJSZE; }
\+	{ return PLUS; }
-	{ return MINUS; }
\*	{ return MNOZENIE; }
\/	{ return DZIELENIE; }
%	{ return RESZTA; }
GET[ ]	{ return GET; }
\(	{ return LNAW; }
\)	{ return PNAW; }
[0-9]*	{ return LICZBA; }
[a-zA-Z]*	{ return VARIABLE; }


%%
