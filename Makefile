run: lex.yy.o parser.tab.o
	g++ lex.yy.o parser.tab.o

lex.yy.o: lexer.l
	bison -d -t -v parser.y
	flex lexer.l
	g++ -c lex.yy.c

parser.tab.o: parser.y parser.tab.h
	g++ -c parser.tab.c

clean:
	rm *.o *.c *.h *.output *.ps *.png *.dot a.out