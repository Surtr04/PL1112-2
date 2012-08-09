OBJS = y.tab.o lex.yy.o stack.o word.o linkedlist.o
CC = gcc
CFLAGS = 
LIBS = -lfl -ly
YACC = grammar.y
PARSER = parser.fl
FILES = parser.fl grammar.y linkedlist.c linkedlist.h stack.c stack.h word.c word.h files dict.txt makefile

dictionary:$(OBJS)
	$(CC) $(CFLAGS) -o sttc $(OBJS) $(LIBS) -g

lex.yy.c: $(PARSER)
	flex $(PARSER)

lex.yy.o: lex.yy.c y.tab.h
	$(CC) $(CFLAGS) -c lex.yy.c

y.tab.c: $(YACC)
	yacc -d --debug --verbose $(YACC)

y.tab.o: y.tab.c
	$(CC) $(CFLAGS) -c y.tab.c

stack.o: stack.c stack.h
	$(CC) $(CFLAGS) -c stack.c

linkedlist.o: linkedlist.c linkedList.h
	$(CC) $(CFLAGS) -c linkedlist.c	

word.o: word.c word.h linkedlist.h
	$(CC) $(CFLAGS) -c word.c

clean:
	rm *.o
	rm sttc
	rm lex.yy.c
	rm y.tab.c	

install:
	cp sttc /usr/bin		

remove:
	rm /usr/bin/sttc


tar:
	mkdir sttc
	cp -r relatorio sttc/relatorio
	cp -r originals sttc/originals
	cp -r text sttc/text
	cp $(FILES) sttc
	tar -pczf sttc.tar.gz sttc
	rm -r sttc