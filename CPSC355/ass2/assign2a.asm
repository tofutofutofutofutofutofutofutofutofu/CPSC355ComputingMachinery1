// Author:	Christopher Lee	ID:110136117	Tutorial Section: T09
// Version 3: October 6th, 2021
// Program Features:
//	Should be complete now
//
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

formatter:	.string	"original: 0x%08X	reversed: 0x%08X \n"
		.balign 4
		.global main

define(x_r, w19)
define(y_r, w20)
define(t1r, w21)
define(t2r, w22)
define(t3r, w23)
define(t4r, w24)

main:		stp	x29, x30, [sp, -16]!	// Usual Holy Code
		mov	x29, sp 	// Usual Holy Code part 2

initx:
// x = 0x07FC07FC;
		mov	x_r, 0x07FC07FC	// change this value to change x
	
step1:
// t1 = (x & 0x55555555) << 1;
		and 	t1r, x_r, 0x55555555	// x & 0x55555555
		lsl	t1r, t1r, 1	// t1 << 1
// t2 = (x >> 1) & 0x55555555;
		lsr	t2r, x_r, 1	// t2 = x >> 1
		and	t2r, t2r, 0x55555555	// t2 = t2 & 0x55555555
// y = t1 | t2;
		orr	y_r, t1r, t2r	// y = t1 | t2

step2:
// t1 = (y & 0x33333333) << 2;
		and	t1r, y_r, 0x33333333	// t1 = y & 0x33333333
		lsl	t1r, t1r, 2	// t1 = t1 << 2
// t2 = (y >> 2) & 0x33333333
		lsr	t2r, y_r, 2	// t2 = y >> 2
		and	t2r, t2r, 0x33333333	// t2 = t2 & 0x33333333
// y = t1 | t2;
		orr	y_r, t1r, t2r	// y = t1 | t2

step3:
// t1  = (y & 0x0F0F0F0F) << 4
		and	t1r, y_r, 0x0F0F0F0F	// t1 = y & 0x0F0F0F0F
		lsl t1r, t1r, 4		// t1 = t1 << 4
// t2 = (y >> 4) & 0x0F0F0F0F
		lsr	t2r, y_r, 4		//t2 = y >> 4
		and	t2r, t2r, 0x0F0F0F0F	// t2 = t2 & 0x0F0F0F0F
// y = t1|t2
		orr y_r, t1r, t2r	// y = t1 | t2

step4:
//t1 = y << 24
		lsl	t1r, y_r, 24	// t1 = y << 24
//t2 = (y & 0xFF00) << 8
		and t2r, y_r, 0xFF00	// t2 = y & 0xFF00
		lsl	t2r, t2r, 8	// t2 = t2 << 8
//t3 = (y >> 8) & 0xFF00;
		lsr t3r, y_r, 8		// t3 = y >> 8
		and	t3r, t3r, 0xFF00	// t3 = t3 & 0xFF00
//t4 = y >> 24
		lsr	t4r, y_r, 24	// t4 = y >> 24
// y = t1 | t2 | t3 | t4
		orr y_r, t1r, t2r	// y = t1 | t2
		orr y_r, y_r, t3r	// y = y | t3
		orr y_r, y_r, t4r	// y = y | t4


// printf("original: 0x%08X reversed: 0x%08X\n, x, y);
printDB:	mov	w1, x_r		// Store the x register in w1
		mov	w2, y_r		// Store the y register in w2

		adrp	x0, formatter	// Does print stuff
		add	x0, x0, :lo12:formatter	// more print stuff
		bl	printf		// Print the print stuff

done:		ldp	x29, x30, [sp], 16	// Restoring the state
		ret				// Returning back to original Location
