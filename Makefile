kompilator: kompilator.y kompilator.l
	bison -d kompilator.y
	flex kompilator.l
	gcc -o kompilator lex.yy.c kompilator.tab.c 
