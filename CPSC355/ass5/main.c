#include <stdio.h>

void clear();
void testPrint();
void testSP();
int push(int f);
int pop();


extern int sp;

int main()
{
	testSP();
	testPrint();	
	clear();
	testPrint();
	
	int a;
	for (a = 0; a < 100; a++){
	push(10);
	testPrint();
	}


	pop();
	testPrint();
	clear();
	pop();
	testPrint();


	return 0;
}
