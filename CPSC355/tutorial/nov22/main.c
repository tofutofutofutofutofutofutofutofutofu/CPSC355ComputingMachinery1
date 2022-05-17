#include <stdio.h>

void prog();
int ArgC;
char ** ArgV;
 
int main( int argc, char ** argv )
{
	ArgC = argc;
	ArgV = argv;
	
	prog();
	return 0;
}
