// Author:	Christopher Lee	ID:10136117	Tutorial Section: T09

// Version 1:	September 27th, 2021
// Program Features:	Same as before
// Missing Features:	Use Macros and put the loop test at the bottom? how is it still a pretest loop?

formatter:	.string	"Current x value: %d	 Current y value: %d	 Current maximum: %d \n" // This is the string 
		.balign	4	// %d's will be replaced with w1-3. Put the values of each register in these loops!
		.global	main	// makes the code globally visible

define(x_r, x19)
define(y_r, x20)
define(max_r, x21)
define(power_r, x22)
define(i_r, x23)
define(current_r, x24)
define(t1_r, x25)
define(t2_r, x26)
define(t3_r, x27)
define(immediate_r, x28)

main:		stp	x29, x30, [sp,-16]!	// Stores current info for returning later
		mov	x29, sp 	// Holy Code to start the program


// Make a loop to run x through -10 to 10.
	// Inside this loop we will do the calculations. It may be easier to do them hardcoded with only so many registers.
	// Remember! We only have registers x19-x28 to do work in. x0-x7 can be used to pass args to print.
	// Also, this is the pre-test loop version, where the test is at the start.
	// No macros allowed. only mul add and mov instructions are allowed for calculations.

initialize:	mov	x_r, -10	// x19 will be the x loop register.
		mov	y_r, 0		// x20 will be the y register.
		mov	max_r, -9000	// x21 will be the maximum register.
		mov	power_r, 0		// x22 will be the loop power number
		mov	i_r, 0		// x23 will be the power loop increment
		mov	current_r, 0		// x24 will be used to store the caculuating power
					// x25-28 are used for calculating the y value

// In this pre-test version with loop control at the bottom.
// Add a unconditional branch to the bottom here.
unconBranch:	b	xLoopTest

powers:		cmp	power_r, i_r	// Compare the loop increment with the loop number
		b.le	bCheck		// Branch off of the loop if x22 is less than x23
		mul	current_r, current_r, x_r	// You have to store the current x19 into x24 before running this function
		add	i_r, i_r, 1	// Increment the loop increment by 1. Don't forget to reset this before going into the function as well!
		b	powers

bCheck:		cmp	power_r, 4		// Compare the power number with 4
		b.eq	calculateT2	// If the power number was 4, we continue on to T2
		b	calculateT3	// Otherwise we go to T3

top:

calculateT1:	mov	current_r, x_r	// Put the current x value into another register
		mov	power_r, 4		// Store the exponent we want in x22
		mov	i_r, 1		// Reset the increment register for the power loop
		b	powers		// Branch to the power function and calulate x^4

calculateT2:	mov	immediate_r, -3		// for the mul opcode immediate
		mul	t1_r, current_r, immediate_r 	// This finishes calculating the first term of the polynomial
		mov	current_r, x_r	// Reset current_r back down the the current x value
		mov	power_r, 2		// This time we want to go up to 2 powers
		mov	i_r, 1		// Reset the increment register for the power loop
		b	powers		// Branch to the power function and calculate x^2

calculateT3:	mov	immediate_r, 267	// mul opcode doesn't let you use immediate values lol
		mul	t2_r, current_r, immediate_r	// Finish calculating the second term of the polynomal
		mov 	immediate_r, 47		// Changing x28 for the third term.


// Change this to a madd
		mov 	y_r, -43
		madd	t3_r, x_r, immediate_r, y_r

// The two following lines were repleaced with the madd... Test to see if it works with immediate.
// Otherwise you can probably store it in the y register.

//		mul	t3_r, x_r, immediate_r	 This calculates the third term of the polynomal
//		add	t3_r, t3_r, -43	 Since we don't have to store any more powers, we can just subtract 43 from the other stored value

calculateY:	add	t1_r, t1_r, t2_r	// Finally, simple addition to calculate the current y value.
		add	t1_r, t1_r, t3_r	// Adding 25, 26 and 27 together.

compareMax:	cmp	t1_r, max_r	// Compare the current y value with the current maximum
		b.le	printDB		// if the current y is lower, branch over replacing the max
		mov	max_r, t1_r	// else, replace the maximum with the new y value.

printDB:	mov	w1, w19		// This this puts registers 19-21 into w 1-3. x=1, y=2 max=3
		mov	w2, w25		// It should update as we procede through the loop.
		mov	w3, w21		// We use w registers because the print function is weird.

		adrp	x0, formatter	// Following three lines are used to call printf
		add	x0, x0, :lo12:formatter // Puts something into x0 to print
		bl	printf		// Prints

resetYDB:	mov	t1_r, 0		// Reset the Y value before looping again.

incrementDB:	add	x_r, x_r, 1	// Increments x register by one.

// Put the test here

xLoopTest:	cmp	x_r, 10		// Does a subs on x19 and a hardcoded value
		b.le	calculateT1 	// Should branch to the print statement if x19 is less than 10

done:		ldp	x29, x30, [sp], 16 	//Holy Code to end the program
		ret				//Return
