	.data
	.global	index
index:	.word	0
	
	.text
	.global HiStr
HiStr:	.string	"Hello\n"

	.balign	4
	.global	main

main:	stp	x29, x30, [sp, -16]!
	mov	x29, sp

	bl	func
	
	ldp	x29, x30, [sp], 16
	ret	
	