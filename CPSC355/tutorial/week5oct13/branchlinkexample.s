formatter:	.string "Hello World\n"
		.balign 4
		.global main

function:
		stp x29, x30, [sp, -16]!	// all you need to do is put holy code in function and bl to it in main
		mov x29, sp

		adrp	x0, formatter	
		add	x0, x0, :lo12:formatter	
		bl printf
			
		ldp x29, x30, [sp], 16
		ret

main:
		stp x29, x30, [sp, -16]!
		mov x29, sp

call:	bl function

done:	ldp x29, x30, [sp], 16
		ret
