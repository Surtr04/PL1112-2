%{
#include <stdio.h>;	
#include <stdlib.h>;
#include "stack.h";
#include "word.h";
#include <unistd.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;
extern int yylineno;
extern char* yytext;

int yydebug = 0;

char *dictfile;
int dictRead = 0;
char *reviewFile;
FILE *reviewWrite;

int fileNum;

Word *w;
List* dictl;

Stack *s = NULL;
Stack *appendix = NULL;

%}

%token DICTIONARY COLON FILES ENDLINE
%token WORD MEANING ENG_W SYN COMMA FINAL
%token STRING TEXT

%union {
	char *str;	
}

%type<str> STRING
%type<str> TEXT
%%

cinemaFiles: dictPath files dictionaryL strings;

dictPath: DICTIONARY COLON STRING ENDLINE {		
		dictfile = strdup($3);
	};

files: file
	| files file;

file: FILES COLON STRING ENDLINE {		
		push(&s,$3);
	};


dictionaryL: dictionary
		| dictionaryL dictionary

dictionary: word meaning english_word synonym {
	dictl = insertWordST(dictl,w);	
};

word: WORD COLON STRING ENDLINE {	
	w = initWord();
	w = insertWord(w,$3);		
};

meaning: MEANING COLON STRING ENDLINE {
	w = insertMeaning(w,$3);
};

english_word: ENG_W COLON STRING ENDLINE{
	w = insertEng_W(w,$3);	
};

synonyms: STRING
		{			
			w = insertSynonym(w,$1);
		};
		| synonyms COMMA STRING{			
			w = insertSynonym(w,$3);
		};
		| ;		

synonym: SYN COLON synonyms ENDLINE;

string: TEXT {	
		Word *tmp = getWord(dictl,$1);
		if(tmp) {
			fprintf(reviewWrite,"\\underline{%s}",$1);		
			fprintf(reviewWrite,"\\footnote{%s}",tmp->eng_w);
			push(&appendix,tmp->meaning);
			push(&appendix,tmp->word);
		}	
		else {
			fprintf(reviewWrite,"%s",$1);		
		}		
	};
		| FINAL {
			char *tmpWord;
			
			fprintf(reviewWrite,"\\section{Significados}");
			
			while(tmpWord = pop(&appendix)) {
				fprintf(reviewWrite,"{\\bf %s} - ",tmpWord);
				fprintf(reviewWrite,"%s\\\\\n",pop(&appendix));
			}
			fprintf(reviewWrite,"\\end{document}");

		}

strings: string 
		| strings string

%%

int yyerror() {
	  fprintf(stderr,"ERROR");
}

int yywrap() {
	if(!dictRead) {
		yyin = fopen(dictfile,"r");

		dictRead = 1;
		return 0;	
	}
	else 
		if (reviewFile = pop(&s)) {				
			yyin = fopen(reviewFile,"r");
			
			char *r = (char*) malloc(50 * sizeof(char));
			strcpy(r,"reviewTex");
			strcat(r,STRINGIFY(1));
			strcat(r,".tex");			
			reviewWrite = fopen(r,"w");
			yyout = reviewWrite;
			return 0;
		}
	
	return 1;
}



int main (int argc, char **argv) {

	dictl = initDictionary();	
	fileNum = 0;


	if(argv[1] && strcmp(argv[1],"-v") == 0) {
		yyout = stdout;					

		if(argv[2]) {
			yyin = fopen(argv[2],"r");
			yyparse();
		}			
	}

	if(argv[1] && strcmp(argv[1],"-d") == 0) {
		yydebug = 1;					

		if(argv[2]) {
		yyin = fopen(argv[2],"r");
		yyparse();
		}		
	}

	if(argv[1] && (strcmp(argv[1],"-dv") == 0 || strcmp(argv[1],"-vd") == 0)) {
		yyout = stdout;
		yydebug = 1;					

		if(argv[2]) {
		yyin = fopen(argv[2],"r");
		yyparse();
		}		
	}

	if(argv[1] && !argv[2]) {
		yyout = fopen(".dump","w");				

		if(argv[1]) {
		yyin = fopen(argv[1],"r");
		yyparse();
		}		
	
	}

	if(strcmp(argv[1],"--maketex") == 0) {
		execl("pdflatex","reviewTex1.tex",NULL);
		execl("rm","reviewTex1.aux", "reviewTex1.log", "reviewTex1.out","reviewTex1.toc",NULL);		
	}

	if(!argv[1]) {
		
		fprintf(stderr,"->no file was specified\n");
		fprintf(stderr,"->reading from stdin\n");
		yyin = stdin;
		yyparse();
		
	}




	return 0;
}