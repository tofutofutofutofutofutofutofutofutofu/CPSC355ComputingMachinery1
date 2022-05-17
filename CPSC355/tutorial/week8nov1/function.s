
adder:	stp	x29, x30, [sp, -16]!
	mov	x29, sp

	add	x1, x0, x1
	add	x1, x1 , x2


	
	bl	printf

	ldp	x29, x30, [sp], 16
	ret


	.global main
main:	stp	x29, x30, [sp, -16]!
	mov 	x29, sp

	mov	x0, 3
	mov	x1, 4
	mov	x2, 5

	bl	adder




	ldp	x29, x30, [sp], 16
	ret
