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
testStr:	.string "sp is currently %d\n"
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
clear:		
		mov	w10, 0

		adrp 	x9, sp
		add	x9, x9, :lo12:sp		
		str	w10, [x9]
		ret

		.global testPrint
testPrint:	stp	x29, x30, [sp, -16]!
		mov	x29, sp

		adrp	x0, testStr
		add	x0, x0, :lo12:testStr
		
		adrp 	x9, sp
		add	x9, x9, :lo12:sp
		ldr	w1, [x9]
		bl 	printf

		ldp x29, x30, [sp], 16
		ret
		
		.global testSP
testSP:		
		mov	w10, 1

		adrp 	x9, sp
		add	x9, x9, :lo12:sp		
		str	w10, [x9]
		ret


		.global	push
push:		stp	x29, x30, [sp, -16]!
		mov	x29, sp
		
		mov	w11, w0

		adrp 	x9, sp
		add	x9, x9, :lo12:sp
		ldr	w10, [x9]
		
		cmp	w10, MAXVAL
		b.lt	pushIf
		b	pushElse

pushIf:		adrp	x12, val
		add	x12, x12, :lo12:val
		str	w11, [x12, w10, SXTW2]
		add	w10, w10, 1
		str	w10, [x9]
		mov 	w0, w11
		b	pushDone

pushElse: 	adrp	x0, pushStr
		add	x0, x0, :lo12:pushStr
		bl	printf
		bl	clear
		mov	x0, 0

pushDone: 	ldp	x29, x30, [sp], 16
		ret	

		.global pop
pop:		stp	x29, x30, [sp, -16]!
		mov 	x29, sp
		
		adrp 	x9, sp
		add	x9, x9, :lo12:sp
		ldr	w10, [x9]
		
		cmp 	w10, 0
		b.gt	popIf
		b	popElse

popIf:		sub	w10, w10, 1
		str	w10, [x9]
	
		adrp	x12, val
		add	x12, x12, :lo12:val
		ldr	w0, [x12, w10, SXTW2]
		b	popDone

popElse:	adrp	x0, popStr
		add	x0, x0, :lo12:popStr
		bl	printf
		bl	clear
		mov	x0, 0

popDone: 	ldp	x29, x30, [sp], 16
		ret		

		
		.global ungetch
ungetch:	stp	x29, x30, [sp, -16]!
		mov 	x29, sp
	
		mov	w11, w0

		adrp 	x9, bufp
		add	x9, x9, :lo12:bufp
		ldr	w10, [x9]
		cmp 	w10, BUFSIZE
		b.gt	ungetchIf
		b	ungetchElse

ungetchIf:	adrp	x0, ungetchStr
		add	x0, x0, :lo12:ungetchStr
		bl	printf
		b	ungetchD

ungetchElse:	adrp	x12, buf
		add	x12, x12, :lo12:buf
		strb	w11, [x12, x10]
		add	w10, w10, 1
		str	w10, [x9]

ungetchD:	ldp	x29, x30, [sp], 16
		ret


		.global getch
getch:		stp	x29, x30, [sp, -16]!
		mov	x29, sp

		adrp	x9, bufp
		add 	x9, x9, :lo12:bufp
		ldr	w10, [x9]
		
		cmp	w10, 0
		b.le	getchF

getchT:		adrp	x12, buf
		add	x12, x12, :lo12:buf
		
		sub 	w10, w10, 1
		str	w10, [x9]
		
		ldrb	w0, [x12, x10]
		
		b	getchDone

getchF:		bl	getchar

getchDone:	ldp	x29, x30, [sp], 16
		ret



alloc = -(16 + 4 + 4) & -16
dealloc = -alloc

		.global getop
getop:		stp 	x29, x30, [sp, alloc]!
		mov	x29, sp

					// wasn't there a thing to store what was stored in these
		mov 	x19, x0		// store char *s in x19
		mov	w20, w1 	// rn lim is in w20

whileLT:	bl	getch
		str	w0, [x29, c_s]
		
		ldr	w9, [x29, c_s]
		cmp 	w9, ' '
		b.eq	whileLT
		cmp	w9, '\t'
		b.eq	whileLT
		cmp	w9, '\n'
		b.eq	whileLT

		
getopIf:	ldr	w9, [x29, c_s]
		cmp	w9, '0'
		b.lt	ifT
		cmp 	w9, '9'
		b.gt	ifT
		b	ifF

ifT:		ldr	w0, [x29, c_s]
		b	getopDone
		
ifF:		str	w9, [x19]	// I don't really understand but ok
	
		mov	w22, 1
		str	w22, [x29, i_s]			
		b	forLT
forTop:		ldr	w14, [x29, i_s]
		cmp	w14, w20
		b.lt	forIfNext
		b	forLT

forIfNext:	ldr	w15, [x29, c_s]
		str	w15, [x19, x14]	// I think someone was saying you have to sign extend this one

forLT:		bl	getchar
		str	w0, [x29, c_s]
		ldr	w9, [x29, c_s]
		cmp	w9, '0'
		b.ge	LT2
		b	forDone

LT2:		cmp 	w9, '9'
		b.le	forTop	

forDone:	ldr	w9, [x29, i_s]
		cmp 	w9, w20
		b.lt	if2top
		b	if2else

if2top:		ldr	w0, [x29, c_s]
		bl	ungetch
		ldr	w9, [x29, i_s]
		mov	w10, '\0'
		str	w10, [x19, x9]
		mov	w0, NUMBER
		b	getopDone

if2else:	b	ewLT
		
elseWhile:	bl	getchar
		str	w0, [x29, c_s]

ewLT:		ldr	w9, [x29, c_s]
		cmp	w9, '\n'
		b.ne	ewLT2
		b	ewDone

ewLT2:		cmp	w9, -1
		b.ne	elseWhile

ewDone:		mov	w0, TOOBIG		

getopDone:	ldp	x29, x30, [sp], dealloc
		ret


		
				
		

		
		
		