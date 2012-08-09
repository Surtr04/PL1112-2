#include "word.h"


Word* initWord() {
	Word *w = (Word*) malloc(sizeof(Word));
	w->synonyms = init(300*sizeof(char*),NULL);

	return w;
}

List* initDictionary() {
	List* d = init(sizeof(Word),NULL);

	return d;
}

List* insertWordST(List *l, Word *w) {
	l = insertHead(l, w);

	return l;
}

Word* insertWord(Word *w, char *word) {

	w->word = strdup(word);
	return w;
}

Word* insertMeaning(Word *w, char *meaning) {

	w->meaning = strdup(meaning);
	return w;
}

Word* insertEng_W(Word *w, char *eng_w) {

	w->eng_w = strdup(eng_w);

	return w;
}

Word* insertSynonym(Word *w, char *syn) {

	w->synonyms = insertTail(w->synonyms, strdup(syn));

	return w;
}

Word* getWord(List *l, char* word) {

	Word *tmp;
	Node *ll = l->list;

	while(l->list) {
		tmp = (Word*)l->list->data;

		if(strcmp(tmp->word,word) == 0) {
			l->list = ll;
			return tmp;
		}

		l->list = l->list->next;
	}

	l->list = ll;

	return NULL;
}

void toString(Word *w) {
	printf("%s\n",w->word);
	printf("%s\n",w->meaning);
	printf("%s\n",w->eng_w);

	while(w->synonyms->list) {
		printf("%s ",(char*)w->synonyms->list->data);
		w->synonyms->list = w->synonyms->list->next;
	}

	printf("\n\n");
}

