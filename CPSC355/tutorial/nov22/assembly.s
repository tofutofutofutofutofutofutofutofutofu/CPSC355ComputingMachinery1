	.text

HiStr:	.string "Number of args: %d, Args: %s %s\n"

	.balign 4
	.global prog

prog:	stp	x29, x30, [sp, -16]!
	mov	x29, sp

	adrp	x19, ArgC
	add 	x19, x19, :lo12:ArgC
	ldr	x1, [x19]

	adrp 	x19, ArgV
	add 	x19, x19, :lo12:ArgV
	ldr 	x2, [x19]
	ldr	x3, [x19, 8]


	adrp	x0, HiStr
	add	x0, x0, :lo12:HiStr
	bl	printf


	ldp	x29, x30, [sp], 16
	ret
