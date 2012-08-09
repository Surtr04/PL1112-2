#ifndef _WORD
#define _WORD
#endif

#define STRINGIFY(x) #x

#include <string.h>
#include <stdio.h>
#include "linkedlist.h"

typedef struct word {
	char *word;
	char *meaning;
	char* eng_w;
	List *synonyms;
}Word;


Word* initWord();
List* initDictionary();
List* insertWordST(List *l, Word *w);
Word* insertWord(Word *w, char *word);
Word* insertMeaning(Word *w, char *meaning);
Word* insertEng_W(Word *w,char *eng_w);
Word* insertSynonym(Word *w, char *syn);
Word* getWord(List *l, char* word);

//for debugging purposes
void toString(Word *w);