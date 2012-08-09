#ifndef STACK
#define STACK
#endif
#include <stdlib.h>
#include <string.h>

typedef struct stack {
	char *data;
	struct stack *next;
}Stack;

void push(Stack **s, char *str);
char* pop(Stack **s);
int isEmpty(Stack *s);