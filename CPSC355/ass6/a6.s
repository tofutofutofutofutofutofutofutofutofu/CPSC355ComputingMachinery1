// Author:	Christopher Lee	ID:110136117	Tutorial Section: T09
// Version 1:	December 5th, 2021
// Program Features:
// None
		.data
t_m:		.word	1
x_m:		.double	0.0
arcx_m:		.double 0.0
switch_m:	.word	0


		.text
i_r	.req	w19
argc_r	.req	w20
argv_r	.req	x21
fd_r	.req	x22

x_r	.req	d16
total_r .req	d17
term_r	.req	d18


term_min:	.double	1.0e-13
zero_f:		.double	0.0

AT_FDCWD = -100
openFile_mode = 00
buf_size = 8
alloc = -(16 + buf_size) & -16
dealloc = -alloc

headerfmt:	.string "x value		|arctan(x)\n"
headerfmt2:	.string "__________________________________\n"
fmtTest:	.string	"%.10lf	|%.10lf\n"
NIerror:	.string "Please enter a file name using the format './exe filename.bin'\n"
OPerror:	.string "Could not open the file \n"

		.balign 4
		.global main
main:		stp	x29, x30, [sp, alloc]!
		mov	x29, sp

		mov	argc_r, w0
		mov	argv_r, x1

		cmp	argc_r, 1
		b.eq	noInputError

openfile:	mov	x0, AT_FDCWD
		mov	i_r, 1
		ldr	x1, [argv_r, i_r, SXTW 3]
		mov	w2, 0
		mov	w3, 0
		mov	x8, 56
		svc	0

		mov	fd_r, x0

		cmp 	fd_r, 0
		b.lt	openError

headerPrint:	adr	x0, headerfmt
		bl	printf
		adr	x0, headerfmt2
		bl 	printf
		

readFileLoop:	mov	x0, fd_r
		add	x1, x29, 16
		mov	x2, buf_size
		mov	x8, 63
		svc	0

test:		cmp	x0, 0
		b.le	close



		ldr	d8, [x29, 16]
		ldr	d0, [x29, 16]
 
		adrp	x23, x_m
		add	x23, x23, :lo12:x_m
		str	d0, [x23]

		bl 	arctan
postarc:	fmov	d1, d0


		fmov	d0, d8
		adr	x0, fmtTest		
		bl	printf


							// Test Print
							// bl to a arc function here





		b	readFileLoop

close:		mov	w0, w19
		mov	x8, 57
		svc	0
		b	done


openError:	adrp	x0, OPerror
		add	x0, x0, :lo12:OPerror
		bl	printf
		b	done

noInputError:	adrp	x0, NIerror
		add	x0, x0, :lo12:NIerror
		bl	printf

done:		ldp	x29, x30, [sp], dealloc
		ret


arctan:		stp	x29, x30, [sp, -16]!
		mov	x29, sp

		fmov 	x_r, d0

		adr	x9, zero_f
		ldr	d29, [x9]

		fmov	total_r, d29
		fmov	term_r, x_r
	
		b	arcLT

arcLtop:	adrp	x9, switch_m
		add	x9, x9, :lo12:switch_m
		ldr	x10, [x9]
		cmp	x10, 0
		b.ne	switch2

switch1:	fadd	total_r, total_r, term_r
		mov	x10, 1
		str	x10, [x9]
		b	switch_done

switch2:	fsub	total_r, total_r, term_r
		mov	x10, 0
		str	x10, [x9]		

switch_done:	adrp	x9, t_m
		add	x9, x9, :lo12:t_m
		ldr	w11, [x9]
		add	w11, w11, 2
		str	w11, [x9]

		fmov	d0, x_r
		mov	w0, w11
		bl	powers
		
		adrp	x9, t_m
		add	x9, x9, :lo12:t_m
		ldr	w11, [x9]

		scvtf	d18, w11
		fdiv	term_r, d0, d18

arcLT:		adrp	x9, term_min
		add	x9, x9, :lo12:term_min
		ldr	d19, [x9]
		
		fabs	d20, term_r
		fcmp	d20, d19
		b.ge	arcLtop

		fmov	d0, total_r
		
		adr	x9, zero_f
		adr	x10, switch_m
		adr	x11, t_m
	
		mov	x12, 0
		str	x12, [x10]
		mov	x12, 1
		str	x12, [x11]

		ldr	d29, [x9]	
		fmov	total_r, d29
		fmov 	term_r, d29
	

		
arctandone:	ldp	x29, x30, [sp], 16
		ret

powers:		mov	w9, w0
		mov	w10, 1
		fmov	d21, d0
		b	powersLT
		
powersLtop:	fmul	d21, d21, d0
		add	w10, w10, 1

powersLT:	cmp	w10, w9
		b.lt	powersLtop
		fmov	d0, d21
		ret	




