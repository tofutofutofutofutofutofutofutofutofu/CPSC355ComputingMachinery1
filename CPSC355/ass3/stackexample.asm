define(size, 100)
define(int_size, 4)
define(v_size, size * int_size)
define(gap_size, int_size)
define(v_i, 16)
define(gap_i, v_i + v_size)

define(i_i, gap_i + int_size)
define(j_i, i_i + int_size)
define(temp_i, j_i + int_size)

define(var_size, temp_i + 4)
define(alloc, -(16 + var_size) & -16)
define(dealloc, -alloc)

define(x29, fp)
define(x30, lr)


varsize is var_size
tempi is temp_i

	.global main

main:	
	stp fp, lr, [sp,alloc]!
	mov fp, sp

	mov x10, 123
	str x10,[fp, gap_i]
	ldr x12, [fp, gap_i]

	mov x11, 234
	str x11, [fp, v_i + (2*int_size)]
	ldr x13, [fp, v_i + (2*int_size)]

db:
	ldp x29, x30, [sp], dealloc