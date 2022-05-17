	.global main
main:	stp 	x29, x30, [sp, -16]!
	mov	x29, sp

startDB:
	mov	x19, 2			//This part moves the numbers into register 19 and 20
	mov	x20, 12
addDB:
	add	x0, x19, x20		//This part adds the two registers together and stores them into register 0
afterAddDB:					//oh god 


	ldp x29, x30, [sp],16
	ret
