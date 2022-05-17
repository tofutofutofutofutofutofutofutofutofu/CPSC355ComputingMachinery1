		.data
		.global sp
		.global bufp
sp:		.word	0
bufp:		.word	0

		.bss
		.global val
		.global buf
val:		.skip	100*4
buf:		.skip	100*1

		.text
testStr:	.string "Test: %c\n"
pushStr:	.string "error: stack full\n"
popStr:		.string	"error: stack empty\n"
ungetchStr:	.string	"ungetch: too many characters\n"
MAXVAL = 100
BUFSIZE = 100
NUMBER = '0'
TOOBIG = '9'
c_s = 16
i_s = 20

		.balign	4
		.global clear
clear:							// clear doesn't need to save link info since it doesn't bl
		mov	w10, 0				// Load 0 to store in sp

		adrp 	x9, sp				// Load first part of sp variable
		add	x9, x9, :lo12:sp		// Load second part of sp variable
		str	w10, [x9]			// sp = 0
		ret					// return

		.global testPrint
testPrint:	stp	x29, x30, [sp, -16]!		// test function
		mov	x29, sp

		mov	w1, w0

		adrp	x0, testStr
		add	x0, x0, :lo12:testStr
		bl 	printf

		ldp x29, x30, [sp], 16
		ret


		.global	push
push:		stp	x29, x30, [sp, -16]!		// This is push(int f)
		mov	x29, sp				// Need this because we bl somewhere in here

		mov	w11, w0				// Move int f into a temporary register

		adrp 	x9, sp				// Moving address of variable sp
		add	x9, x9, :lo12:sp		// Move lo12 of sp address
		ldr	w10, [x9]			// Put sp variable into w10

		cmp	w10, MAXVAL			// if (sp < MAXVAL)
		b.lt	pushIf				// Go to if true
		b	pushElse			// Go to else

pushIf:		adrp	x12, val			// Move address of val
		add	x12, x12, :lo12:val		// Lo12 val
		str	w11, [x12, w10, SXTW2]		// val[sp] = w11 = f
		add	w10, w10, 1			// sp ++
		str	w10, [x9]			// store sp in stack
		mov 	w0, w11				// return val[sp++] = f;
		b	pushDone			// jump to ret

pushElse: 	adrp	x0, pushStr			// Move address of "error: stack full"
		add	x0, x0, :lo12:pushStr		// Lo12 of address
		bl	printf				// print thing
		bl	clear				// clear the stack
		mov	x0, 0				// return 0

pushDone: 	ldp	x29, x30, [sp], 16		// Deallocate memory
		ret					// return



		.global pop
pop:		stp	x29, x30, [sp, -16]!		// int pop()
		mov 	x29, sp				// it bls

		adrp 	x9, sp				// getting sp
		add	x9, x9, :lo12:sp		// more sp address
		ldr	w10, [x9]			// w10 = sp

		cmp 	w10, 0				// if sp > 0
		b.gt	popIf				// b to inner if
		b	popElse				// b to else

popIf:		sub	w10, w10, 1			// --sp
		str	w10, [x9]			// store sp

		adrp	x12, val			// get val address
		add	x12, x12, :lo12:val		// get val address 2
		ldr	w0, [x12, w10, SXTW2]		// return val[--sp];
		b	popDone				// b to done

popElse:	adrp	x0, popStr			// "error stack empty" address
		add	x0, x0, :lo12:popStr		// lo12 of "" address
		bl	printf				// printf
		bl	clear				// clear
		mov	x0, 0				// return 0

popDone: 	ldp	x29, x30, [sp], 16		// deallocating memory
		ret					// return


		.global ungetch
ungetch:	stp	x29, x30, [sp, -16]!		// void ungetch(int c)
		mov 	x29, sp				// bls printf somewhere

		mov	w11, w0				// move c to w11

		adrp 	x9, bufp			// get bufp address
		add	x9, x9, :lo12:bufp		// get bufp address lo12
		ldr	w10, [x9]			// w10 = bufp
		cmp 	w10, BUFSIZE			// if(bufp > BUFSIZE)
		b.gt	ungetchIf			// branch to if true
		b	ungetchElse			// branch else

ungetchIf:	adrp	x0, ungetchStr			// get "too many characters" string address
		add	x0, x0, :lo12:ungetchStr	// get lo12 address
		bl	printf				// print the thing
		b	ungetchD			// finish

ungetchElse:	adrp	x12, buf			// get buf address
		add	x12, x12, :lo12:buf		// get lo12 buf address
		strb	w11, [x12, x10]			// buf[bufp] = c;
		add	w10, w10, 1			// bufp++
		str	w10, [x9]			// store bufp

ungetchD:	ldp	x29, x30, [sp], 16		// deallocate memory
		ret					// return


		.global getch
getch:		stp	x29, x30, [sp, -16]!		// int getch();
		mov	x29, sp				// bl's getchar() somewhere

		adrp	x9, bufp			// bufp address
		add 	x9, x9, :lo12:bufp		// lo12 bufp address
		ldr	w10, [x9]			// w10 = bufp

		cmp	w10, 0				// bufp > 0 ?
		b.gt	getchT				// b if True
		b	getchF				// b if False

getchT:		adrp	x12, buf			// buf address
		add	x12, x12, :lo12:buf		// lo12 buf address

		ldr	w10, [x9]			// w10 = bufp
		sub 	w10, w10, 1			// --bufp
		str	w10, [x9]			// store bufp

		ldrb	w0, [x12, x10]			// return buf[--bufp]

		b	getchDone			// jump to return

getchF:		bl	getchar				// return getchar();

getchDone:	ldp	x29, x30, [sp], 16		// deallocate memory
		ret					// return





alloc = -(16 + 4 + 4) & -16				// 4 for i, 4 for c: maybe could use -4 for local memory but it messed up when jumping
dealloc = -alloc					// deallocation memory

		.global getop
getop:		stp 	x29, x30, [sp, alloc]!		// int getop(char *s, int lim)
		mov	x29, sp

							// wasn't there a thing to store what was stored in these
		mov 	x19, x0				// store char *s in x19
		mov	w20, w1 			// rn lim is in w20

whileLT:	bl	getch				// branch to get ch
		str	w0, [x29, c_s]			// c = getch()
		ldr	w9, [x29, c_s]			// load c
		cmp 	w9, ' '				// c == ' '
		b.eq	whileLT				// repeat loop
		cmp	w9, '\t'			// c == '\t'
		b.eq	whileLT				// repeat loop
		cmp	w9, '\n'			// c == '\n\
		b.eq	whileLT				// repeat loop
							// Since the inner loop does nothing its just the test

							// if ( c < '0' || c > '9')
getopIf:	ldr	w9, [x29, c_s]			// w9 = c
		cmp	w9, '0'				// c < '0'
		b.lt	ifT				// branch to if true
		cmp 	w9, '9'				// c > '9'
		b.gt	ifT				// branch to if true
		b	ifF				// branch to if false

ifT:		ldr	w0, [x29, c_s]			// return c;
		b	getopDone			// branch to return

ifF:		str	w9, [x19]			// s[0] = c
		mov	w9, 1				// w9 = 1
		str	w9, [x29, i_s]			// i = 1
		b	forLT				// for (i = 1;...; initialized, jump to the condition

forTop:		ldr	w9, [x29, i_s]			// w9 = i
		cmp	w9, w20				// if ( i < lim )
		b.lt	forIfTrue			// branch if True
		b	forIfFalse			// branch if False

forIfTrue:	ldr	w9, [x29, c_s]			// w9 = c
		ldr	w10, [x29, i_s]			// w10 = i
		str	w9, [x19, x10] 			// s[i] = c : This needs to be str not strb idk why

							// note that this section still goes through on true
forIfFalse:	ldr	w9, [x29, i_s]			// w9 = i
		add	w9, w9, 1			// for(... i++);
		str	w9, [x29, i_s]			// store i in memory

forLT:		bl	getchar				// getchar
		str	w0, [x29, c_s]			// c == get char
		ldr	w9, [x29, c_s]			// w9 = c
		cmp	w9, '0'				// c >= '0'
		b.ge	forLT2				// still need to check the && condition
		b	forDone				// break loop if for is done

forLT2:		ldr	w9, [x29, c_s]			// w9 = c
		cmp 	w9, '9'				// c <= '9'
		b.le	forTop				// branch if for True

forDone:	ldr	w9, [x29, i_s]			// w9 = i
		cmp	w9, w20				// if (i < lim) number 2
		b.lt	if2True				// branch if True
		b	if2Else				// branch if False

if2True:	ldr	w0, [x29, c_s]			// store c as an input
		bl	ungetch				// ungetch(c)
		ldr	w9, [x29, i_s]			// w9 = i
		mov	w10, '\0'			// w10 = '\0'
		str	w10, [x19, w9, SXTW 2] 		// s[i] = '\0' : I have no idea why this needs to be sign extended so it stops giving extra 0's
		mov 	w0, NUMBER			// return NUMBER;
		b	getopDone			// branch to return

if2Else:	b	ewLT				// branch to while(c != 'n' && c != EOF)

ewTrue:		bl	getchar				// getchar
		str	w0, [x29, c_s]			// c = getchar()


ewLT:		ldr	w9, [x29, c_s]			// w9 = c
		cmp	w9, '\n'			// c != 'n'
		b.ne	ewLT2				// branch to && condition if true
		b	ewDone				// branch if condition is false

ewLT2:		cmp	w9, -1				// c != EOF
		b.ne	ewTrue				// branch to loop if true
							// continues to done if false
ewDone:		mov	w9, w20				// w9 = lim
		sub	w9, w9, 1			// w9 = lim - 1
		mov	w10, '\0'			// w10 = '\0'
		str	w10, [x19, w9, SXTW 2] 		// s[lim - 1] = '\0'
 		mov	w0, TOOBIG			// return TOOBIG


getopDone:	ldp	x29, x30, [sp], dealloc		// deallocate memory for i and c
		ret					// return


