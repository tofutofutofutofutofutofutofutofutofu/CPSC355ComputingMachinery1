// Author:	Christopher Lee	ID:110136117	Tutorial Section: T09
// Version 2: October 5th, 2021
// Program Features:
//	Figured out how to store the numbers in the registers
//	Step 1 & 2 complete
// Missing Features
//	Step 3 & 4 
// Version 1: October 2nd, 2021
// Program Features:
//	Nothing yet
// Missing Features:
//	Variables
//	Bit reversals
//	ORS

formatter:	.string	"original: 0x%08X	reversed: %X \n"
		.balign 4
		.global main

define(x_r, w19)
define(y_r, w20)
define(t1r, w21)
define(t2r, w22)
define(t3r, w23)
define(t4r, w24)
define(i_r, w25)

main:		stp	x29, x30, [sp, -16]!	// Usual Holy Code
		mov	x29, sp 	// Usual Holy Code part 2

initx:
// x = 0x07FC07FC;
		mov	x_r, 0x07FC07FC	// 0000 0111 1111 1100
		//orr	x_r, x_r, x_r, lsl 16 // This seems to work.

				

step1:
// i_r = 0x55555555;
		mov	i_r, 0x55555555	// 0101 0101 0101 0101
		orr	i_r, i_r, i_r, lsl 16	// 0x5555 5555
// t1 = (x & 0x55555555) << 1;
		and 	t1r, i_r, x_r	// x & 0x55555555
		lsl	t1r, t1r, 1	// t1 << 1
// t2 = (x >> 1) & 0x55555555;
		lsr	t2r, x_r, 1	// t2 = x >> 1
		and	t2r, t2r, i_r	// t2 = t2 & 0x55555555
// y = t1 | t2;
		orr	y_r, t1r, t2r	// y = t1 | t2

step2:
//i_r = 0x33333333
		mov	i_r, 0x3333	// i = 0x3333
		orr	i_r, i_r, i_r, lsl 16	// i = 0x33333333
// t1 = (y & 0x33333333) << 2;
		and	t1r, y_r, i_r	// t1 = y & 0x33333333
		lsl	t1r, t1r, 2	// t1 = t1 << 2
// t2 = (y >> 2) & 0x33333333
		lsr	t2r, y_r, 2	// t2 = y >> 2
		and	t2r, t2r, i_r	// t2 = t2 & 0x33333333
// y = t1 | t2;
		orr	y_r, t1r, t2r	// y = t1 | t2

step3:
//i_r = 0F0F0F0F
		mov	i_r, 0x0F0F	// i = 0x0F0F
		orr	i_r, i_r, i_r, lsl 16
// t1  = (y & 0x0F0F0F0F)
		and	t1r, y_r, i_r	// 


// printf("original: 0x%08X reversed: 0x%08X\n, x, y);
printDB:	mov	w1, x_r		// Store the x register in w1
		mov	w2, y_r		// Store the y register in w2

		adrp	x0, formatter	// Does print stuff
		add	x0, x0, :lo12:formatter	// more print stuff
		bl	printf		// Print the print stuff

done:		ldp	x29, x30, [sp], 16	// Restoring the state
		ret				// Returning back to original Location
