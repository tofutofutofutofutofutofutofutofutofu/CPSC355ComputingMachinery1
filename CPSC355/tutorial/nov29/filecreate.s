alloc =	-(16) & -16
dealloc = -alloc


	.string "Desktop"
	
	.balign 4
	.global main
main:	stp	x29, x30, [sp, alloc]
	mov	x29, sp

	mov	x19, 1
	mov	x8, 64

	b	forLT
forTop:	mov 	x0, x19
	mov	x2, 8

	svc	0

	add	x19, x19, 1	

forLT:	cmp 	x19, 100
	




	ldp x29, x30, [sp], dealloc
	ret