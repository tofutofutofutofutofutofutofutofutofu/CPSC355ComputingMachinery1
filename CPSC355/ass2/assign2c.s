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

formatter:	.string	"original: 0x%08X	reversed: 0x%08X \n"
		.balign 4
		.global main








main:		stp	x29, x30, [sp, -16]!	// Usual Holy Code
		mov	x29, sp 	// Usual Holy Code part 2

initx:
// x = 0x01FF01FF;
		mov	w19, 0x01FF01FF	// 0000 0111 1111 1100
	
step1:
// t1 = (x & 0x55555555) << 1;
		and 	w21, w19, 0x55555555	// x & 0x55555555
		lsl	w21, w21, 1	// t1 << 1
// t2 = (x >> 1) & 0x55555555;
		lsr	w22, w19, 1	// t2 = x >> 1
		and	w22, w22, 0x55555555	// t2 = t2 & 0x55555555
// y = t1 | t2;
		orr	w20, w21, w22	// y = t1 | t2

step2:
// t1 = (y & 0x33333333) << 2;
		and	w21, w20, 0x33333333	// t1 = y & 0x33333333
		lsl	w21, w21, 2	// t1 = t1 << 2
// t2 = (y >> 2) & 0x33333333
		lsr	w22, w20, 2	// t2 = y >> 2
		and	w22, w22, 0x33333333	// t2 = t2 & 0x33333333
// y = t1 | t2;
		orr	w20, w21, w22	// y = t1 | t2

step3:
// t1  = (y & 0x0F0F0F0F) << 4
		and	w21, w20, 0x0F0F0F0F	// t1 = y & 0x0F0F0F0F
		lsl w21, w21, 4		// t1 = t1 << 4
// t2 = (y >> 4) & 0x0F0F0F0F
		lsr	w22, w20, 4		//t2 = y >> 4
		and	w22, w22, 0x0F0F0F0F	// t2 = t2 & 0x0F0F0F0F
// y = t1|t2
		orr w20, w21, w22	// y = t1 | t2

step4:
//t1 = y << 24
		lsl	w21, w20, 24	// t1 = y << 24
//t2 = (y & 0xFF00) << 8
		and w22, w20, 0xFF00	// t2 = y & 0xFF00
		lsl	w22, w22, 8	// t2 = t2 << 8
//t3 = (y >> 8) & 0xFF00;
		lsr w23, w20, 8		// t3 = y >> 8
		and	w23, w23, 0xFF00	// t3 = t3 & 0x0FF
//t4 = y >> 24
		lsr	w24, w20, 24	// t4 = y >> 24
// y = t1 | t2 | t3 | t4
		orr w20, w21, w22	// y = t1 | t2
		orr w20, w20, w23	// y = y | t3
		orr w20, w20, w24	// y = y | t4


// printf("original: 0x%08X reversed: 0x%08X\n, x, y);
printDB:	mov	w1, w19		// Store the x register in w1
		mov	w2, w20		// Store the y register in w2

		adrp	x0, formatter	// Does print stuff
		add	x0, x0, :lo12:formatter	// more print stuff
		bl	printf		// Print the print stuff

done:		ldp	x29, x30, [sp], 16	// Restoring the state
		ret				// Returning back to original Location
