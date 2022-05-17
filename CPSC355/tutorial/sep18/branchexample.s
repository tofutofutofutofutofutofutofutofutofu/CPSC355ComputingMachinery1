formatter:	.string "Test %d \n"
		.balign 4
		.global main
main:
		stp x29, x30, [sp, -16]!
		mov x29, sp
	
		mov x0, 10
		mov x1, 10
		cmp x0, x1
		mov w1, 10
		b.eq test
		b next
test:		mov w1, 20		//should override x1 register if they are equal
next:		adrp x0, formatter	// if no override we should print 10
		add x0, x0, :lo12:formatter
		bl printf
		ldp x29, x30, [sp], 16
		ret
