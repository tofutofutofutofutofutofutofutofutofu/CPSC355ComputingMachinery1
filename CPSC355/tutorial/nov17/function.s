		.text

		.balign 4
	 	.global func
func:		stp	x29, x30, [sp, -16]!
		mov	x29, sp
	
		adrp	x20, index
		add	x20, x20, :lo12:index
		ldr	x19, [x20]
		cmp	x19, 10
		b.ge	skip
		add	x19, x19, 1
		str	x19, [x20]
		adrp	x0, HiStr
		add	x0, x0, :lo12:HiStr
		bl	printf
		bl	func

skip:		ldp	x29, x30,[sp], 16
		ret


	