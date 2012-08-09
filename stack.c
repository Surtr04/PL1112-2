#include "stack.h"


void push(Stack **s, char *str) {

	if(!*s) {
		*s = (Stack*) malloc (sizeof(Stack));
		(*s)->data = strdup(str);
		(*s)->next = NULL;
	}
	else {
		Stack *tmp = (Stack*) malloc (sizeof(Stack));
		tmp->data = strdup(str);
		tmp->next = *s;
		*s = tmp;
	}	
}

char* pop(Stack **s) {

	if(!*s)
		return NULL;

	char *str = (*s)->data;
	(*s) = (*s)->next;
	
	return str;
}

int isEmpty(Stack *s) {

	if(s->data == NULL || s == NULL)
		return 1;

	return 0;

}