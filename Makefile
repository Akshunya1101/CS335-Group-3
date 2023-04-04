run: lex.yy.o parser.tab.o
	g++ lex.yy.o parser.tab.o -o milestone3

lex.yy.o: lexer.l
	bison -d -t -v parser.y
	flex lexer.l
	g++ -c lex.yy.c

parser.tab.o: parser.y parser.tab.h
	g++ -c parser.tab.c

clean:
	rm *.o milestone3 *.c *.h *.output *.ps *.png *.csv *.txt *.out