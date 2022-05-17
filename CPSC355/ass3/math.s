


















varsize is 16 + 100 * 4 + 4 + 4 + 4 + 4
tempi is 16 + 100 * 4 + 4 + 4 + 4

	.global main

main:	
	stp fp, lr, [sp,-(16 + 16 + 100 * 4 + 4 + 4 + 4 + 4) & -16]!
	mov fp, sp

	mov x10, 123
	str x10,[fp, 16 + 100 * 4]
	ldr x12, [fp, 16 + 100 * 4]

	mov x11, 234
	str x11, [fp, 16 + (2*4)]
	ldr x13, [fp, 16 + (2*4)]

db:
	ldp fp, lr, [sp], --(16 + 16 + 100 * 4 + 4 + 4 + 4 + 4) & -16