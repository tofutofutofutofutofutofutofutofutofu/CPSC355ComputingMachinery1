define(size, 100)
define(int_size,4)
define(v_size, size * 4)
define(gap_size,4)
define(v_i,16)
define(gap_i, v_i+v_size)

define(var_size, v_size + gap_size)
define(alloc, -(16+var_size)&-16)
define(dealloc, -alloc)

define(x29, fp)
define(x30, lr)

	.global main
main:	stp fp, lr, [sp,alloc]!
	mov fp, sp

	mov x10, 123
	str x10,[fp, gap_i]
	ldr x12, [fp, gap_i]

	mov x11, 234
	str x11, [fp, v_i + (2*int_size)]
	ldr x13, [fp, v_i + (2*int_size)]

db:
	ldp x29, x30, [sp], dealloc