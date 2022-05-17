// Author:	Christopher Lee	ID:10136117	Tutorial Section: T09

// Version 1:	September 27th, 2021
// Program Features:	Same as before
// Missing Features:	Use Macros and put the loop test at the bottom? how is it still a pretest loop?

formatter:	.string	"Current x value: %d	 Current y value: %d	 Current maximum: %d \n" // This is the string 
		.balign	4	// %d's will be replaced with w1-3. Put the values of each register in these loops!
		.global	main	// makes the code globally visible












main:		stp	x29, x30, [sp,-16]!	// Stores current info for returning later
		mov	x29, sp 	// Holy Code to start the program


// Make a loop to run x through -10 to 10.
	// Inside this loop we will do the calculations. It may be easier to do them hardcoded with only so many registers.
	// Remember! We only have registers x19-x28 to do work in. x0-x7 can be used to pass args to print.
	// Also, this is the pre-test loop version, where the test is at the start.
	// No macros allowed. only mul add and mov instructions are allowed for calculations.

initialize:	mov	x19, -10	// x19 will be the x loop register.
		mov	x20, 0		// x20 will be the y register.
		mov	x21, -9000	// x21 will be the maximum register.
		mov	x22, 0		// x22 will be the loop power number
		mov	x23, 0		// x23 will be the power loop increment
		mov	x24, 0		// x24 will be used to store the caculuating power
					// x25-28 are used for calculating the y value

// In this pre-test version with loop control at the bottom.
// Add a unconditional branch to the bottom here.
unconBranch:	b	xLoopTest

powers:		cmp	x22, x23	// Compare the loop increment with the loop number
		b.le	bCheck		// Branch off of the loop if x22 is less than x23
		mul	x24, x24, x19	// You have to store the current x19 into x24 before running this function
		add	x23, x23, 1	// Increment the loop increment by 1. Don't forget to reset this before going into the function as well!
		b	powers

bCheck:		cmp	x22, 4		// Compare the power number with 4
		b.eq	calculateT2	// If the power number was 4, we continue on to T2
		b	calculateT3	// Otherwise we go to T3

top:

calculateT1:	mov	x24, x19	// Put the current x value into another register
		mov	x22, 4		// Store the exponent we want in x22
		mov	x23, 1		// Reset the increment register for the power loop
		b	powers		// Branch to the power function and calulate x^4

calculateT2:	mov	x28, -3		// for the mul opcode immediate
		mul	x25, x24, x28 	// This finishes calculating the first term of the polynomial
		mov	x24, x19	// Reset x24 back down the the current x value
		mov	x22, 2		// This time we want to go up to 2 powers
		mov	x23, 1		// Reset the increment register for the power loop
		b	powers		// Branch to the power function and calculate x^2

calculateT3:	mov	x28, 267	// mul opcode doesn't let you use immediate values lol
		mul	x26, x24, x28	// Finish calculating the second term of the polynomal
		mov 	x28, 47		// Changing x28 for the third term.


// Change this to a madd
		mov 	x20, -43
		madd	x27, x19, x28, x20

// The two following lines were repleaced with the madd... Test to see if it works with immediate.
// Otherwise you can probably store it in the y register.

//		mul	x27, x19, x28	 This calculates the third term of the polynomal
//		add	x27, x27, -43	 Since we don't have to store any more powers, we can just subtract 43 from the other stored value

calculateY:	add	x25, x25, x26	// Finally, simple addition to calculate the current y value.
		add	x25, x25, x27	// Adding 25, 26 and 27 together.

compareMax:	cmp	x25, x21	// Compare the current y value with the current maximum
		b.le	printDB		// if the current y is lower, branch over replacing the max
		mov	x21, x25	// else, replace the maximum with the new y value.

printDB:	mov	w1, w19		// This this puts registers 19-21 into w 1-3. x=1, y=2 max=3
		mov	w2, w25		// It should update as we procede through the loop.
		mov	w3, w21		// We use w registers because the print function is weird.

		adrp	x0, formatter	// Following three lines are used to call printf
		add	x0, x0, :lo12:formatter // Puts something into x0 to print
		bl	printf		// Prints

resetYDB:	mov	x25, 0		// Reset the Y value before looping again.

incrementDB:	add	x19, x19, 1	// Increments x register by one.

// Put the test here

xLoopTest:	cmp	x19, 10		// Does a subs on x19 and a hardcoded value
		b.le	calculateT1 	// Should branch to the print statement if x19 is less than 10

done:		ldp	x29, x30, [sp], 16 	//Holy Code to end the program
		ret				//Return
