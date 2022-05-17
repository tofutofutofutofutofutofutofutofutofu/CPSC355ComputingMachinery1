define(comment)
comment(cube(1=input register, 2= output register))
define(cube, `mul	$2,$1,$2
		mul	$2,$1,$2')	
	
formatter:	.string "Hello %d\n"
		.balign 4
		
	.global main






main:
		stp x29, x30, [sp, -16]!
		mov x29, sp
		
		mov x19, 5
		mov x20, 5
		cube(x19,x20)
		mov x1, x20
		

		adrp	x0, formatter	
		add	x0, x0, :lo12:formatter	
		bl printf


done:	ldp x29, x30, [sp], 16
		ret
