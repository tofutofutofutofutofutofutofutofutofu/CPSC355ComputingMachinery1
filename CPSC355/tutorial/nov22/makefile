exec: main.c assembly.s
	gcc -c main.c
	as assembly.s -o assembly.o
	gcc main.o assembly.o -o exec
