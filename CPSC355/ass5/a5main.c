// Author:	Christopher Lee	ID:110136117	Tutorial Section: T09
// Version 1:	November 18nd, 2021
// Just copying the C code for now, replace the functions one at a time in assembly

#include <stdio.h>
#include <stdlib.h>

/*  Constants */
#define MAXOP	20
#define NUMBER	'0'
#define TOOBIG	'9'

/* Function prototypes */
int push(int f);
int pop();
void clear();
int getop(char *s, int lim);
int getch();
void ungetch(int c);

int main()
{
	int type;
	char s[MAXOP];
	int op2;
	while ((type = getop(s, MAXOP)) != EOF) {
		switch (type) {
		case NUMBER:
			push(atoi(s));
			break;
		case '+':
			push(pop() + pop());
			break;
		case '*':
			push(pop() * pop());
			break;
		case '-':
			op2 = pop();
			push(pop() - op2);
			break;
		case '/':
			op2 = pop();
			if (op2 != 0)
				push(pop() - op2);
			else
				printf("zero divisor popped\n");
			break;
		case '=':
			printf("\n%d\n\n", push(pop()));
			break;
		case 'c':
			clear();
			break;
		case TOOBIG:
			printf("%.20s ... is too long\n", s);
			break;
		default:
			printf("unknown command %c\n", type);
			break;
		}
	}
	return 0;
}
