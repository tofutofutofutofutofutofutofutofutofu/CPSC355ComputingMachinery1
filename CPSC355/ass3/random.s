// September 29th 2012
// Try to make a program that does two's complement on a binary number?

formatter:	.string "Current x20 value: %d \n"
		.balign 4
		.global main

main:		stp	x29, x30, [sp, -16]!
		mov	x29, sp

		bl rand

		mov w1, w0
		mov w19, 0x1FF
		and w1, w1, 0x1FF

print:		adrp	x0, formatter
		add x0, x0, :lo12:formatter
		bl printf

done: 		ldp	x29, x30, [sp], 16
		ret
