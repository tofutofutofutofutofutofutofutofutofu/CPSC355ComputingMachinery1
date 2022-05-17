formatter:	.string	"x19: %d \n"
		.balign	4
		.global	main

main:		stp	x29, x30, [sp, -16]!
		mov	x29, sp

		mov 	x19, 53	//110 101 > 110 110
		mov	x20, 1
		mov	x21, 1
		b	test

topDB:		eor	x19, x19, x20
		lsl	x20, x20, 1

test:		ands	x22, x19, x20
		b.ne topDB

		orr	x19, x19, x20

		mov	w1, w19
print:		adrp	x0, formatter
		add	x0, x0, :lo12:formatter
		bl printf

done:		ldp 	x29, x30, [sp], 16
		ret
