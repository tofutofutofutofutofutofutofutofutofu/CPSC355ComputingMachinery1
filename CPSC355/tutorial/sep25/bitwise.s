// September 29th 2012
// Try to make a program that does two's complement on a binary number?

formatter:	.string "Current x20 value: %d \n"
		.balign 4
		.global main

main:		stp	x29, x30, [sp, -16]!
		mov	x29, sp

		mov 	x20, 25		// This mov sets which number you want to negate

		mvn 	x20, x20	// does a not operation on x20
		add	x20, x20, 0b1 	// adds 1 bit


		mov w1, w20

print:		adrp	x0, formatter
		add x0, x0, :lo12:formatter
		bl printf

done: 		ldp	x29, x30, [sp], 16
		ret
