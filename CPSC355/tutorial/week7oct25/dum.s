

	
	
formatter:	.string "Hello %d\n"
		.balign 4
		
	.global main






main:
		stp x29, x30, [sp, -16]!
		mov x29, sp
		
		mov x19, 5
		mov x20, 5
		mul	x20,x19,x20
		mul	x20,x19,x20
		mov x1, x20
		

		adrp	x0, formatter	
		add	x0, x0, :lo12:formatter	
		bl printf


done:	ldp x29, x30, [sp], 16
		ret
