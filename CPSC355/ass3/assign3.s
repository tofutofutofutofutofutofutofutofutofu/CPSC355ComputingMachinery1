// Author:	Christopher Lee	ID:110136117	Tutorial Section: T09
// Version 3:	October 21nd, 2021
// Program Features:
//	Loop to initialize Array
//	Display of unsorted array
//	Use of macros/equates for stack variable offsets
//	Outer loop of Sort
//	First inner loop of Sort
//	Innermost loop of sort
//	Comparison of array elements
//	Exchange of array elements
//	Display of sorted Array
//	Optimization
//	Complete documentation and commenting
//	Formatting
//	Design Quality
// Missing Features:
// ALL DONE

// Version 2:	October 20nd, 2021
// Program Features:
//	Loop to initialize Array
//	Display of unsorted array
//	Use of macros/equates for stack variable offsets
// Missing Features:
//	Outer loop of Sort
//	First inner loop of Sort
//	Innermost loop of sort
//	Comparison of array elements
//	Exchange of array elements
//	Display of sorted Array
//	Optimization
//	Complete documentation and commenting
//	Formatting
//	Design Quality
// Version 1:	October 20nd, 2021
// Program Features:
//	Nothing yet
// Missing Features:
//	Make sure equates are at the top
//	Make sure to align all comments


SIZE = 100
intSize = 4

gapSize = intSize
iSize = intSize
jSize = intSize
tempSize = intSize
vSize = SIZE * intSize

alloc = -(16 + gapSize + iSize + jSize + tempSize + vSize) & -16
dealloc = -alloc

gap_s = 16
i_s = gap_s + gapSize
j_s = i_s + iSize
temp_s = j_s + jSize
v_s = temp_s + tempSize

fp	.req	x29
lr	.req	x30

i_r	.req	w19
imm_r	.req	w20
vs_r	.req	x21
rand_r	.req	w0
imm2_r	.req	w22
gap_r	.req	w23
j_r	.req	w24
vj_r	.req	w25
vjg_r	.req	w26
temp_r	.req	w27

line1:	.string	"Unsorted array:\n" 
	.balign 4

line2:	.string	"v[%d] = %d\n"
	.balign 4

line3:	.string "Sorted array:\n"
	.balign 4

priDB:	.string "bug cat\n"
	.balign 4

	.global main

main:	stp	fp, lr, [sp, alloc]!		// Holy code is changed for more RAM allocation, size is combined size of all variables 
	mov	fp, sp				// Still have to do this one


						//*** Initialize array to random positive integers mod 512 *****************************************************

	mov	i_r, 0				// i = 0; of the init loop
	str	i_r, [fp, i_s]			// Store the i_r value in i_s
	b	initLT				// Branch to initLT (LT stands for Loop Test)

init:	ldr	i_r, [fp, i_s]			// Load current i for loop cycle
	add	vs_r, fp, v_s			// Adding the frame pointer and base location value of v

						//@@@ v[i] = rand() & 0x1FF; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	bl	rand				// Invokes a random number, stores in x0
	and	rand_r, rand_r, 0x1FF		// does mod 512 somehow
	str	rand_r, [vs_r, i_r, SXTW 2]	// Stores the modulated rand_r into v[i]

	ldr	i_r, [fp, i_s]			// Loading i to increment
	add	i_r, i_r, 1			// i++
	str	i_r, [fp, i_s]			//Store i back into the stack


						//@@@ for (i = 0; i < SIZE; i++) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
initLT:	ldr	i_r, [fp, i_s]			// Load i from RAM
	cmp 	i_r, SIZE			// Compare i with SIZE, which is 100
	b.lt	init				// branch if i < SIZE


						//*** Display the Unsorted Array *******************************************************************************

print:	adrp	x0, line1			//@@@ printf("Unsorted Array:\n"); @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	add	x0, x0, :lo12:line1		// Sticks string line1 into x0
	bl	printf				// Calls print function

	mov	i_r, 0				// i = 0 in the for loop below
	str	i_r, [fp, i_s]			// Stores i into i_s
	b	p2LT				// Branch to the print2LoopTest

						//@@@ printf("v[%d] = %d\n", i, v[i]); @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
print2: ldr	w1, [fp, i_s]			// Loads i for the print function

	add 	vs_r, fp, v_s			// Doing the same thing as before but this time to load elements of the array
	ldr	w2, [vs_r, i_r, SXTW2]		// Access v[i] for the print function

	ldr	i_r, [fp, i_s]			// Access [i]
	add	i_r, i_r, 1			// i++
	str	i_r, [fp, i_s]			// Store i at i_s

	adrp	x0, line2			// Print stuff
	add	x0, x0, :lo12:line2		// Store line 2
	bl	printf				// Print

						//@@@ for (i = 0; i <SIZE; i++) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
p2LT:	ldr	i_r, [fp, i_s]			// Load i from RAM
	cmp	i_r, SIZE			// Compare i with SIZE, which is 100
	b.lt	print2				// branch if i < SIZE


						//*** Sort the array into descending order using a shell sort *************************************************

	mov	imm_r, SIZE			//@@@ for (gap = size/2; ...) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	mov 	imm2_r, 2			// Preparing for udiv
	udiv	gap_r, imm_r, imm2_r		// Calculating size/2
	str	gap_r, [fp, gap_s]		// Store size/2 into gap_s
	b	outLT				// Branch to loop test

outTop:	ldr	i_r, [fp, gap_s]		// @@@for (i = gap...) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	str	i_r, [fp, i_s]			// Store i_r into i_s
	b	midLT				// Begin middle loop

midTop:	ldr	i_r, [fp, i_s]			// load i register
	ldr	gap_r, [fp, gap_s]		// load gap register
	sub	j_r, i_r, gap_r			// for (j = i - gap;...)
	str	j_r, [fp, j_s]			// store j value
	b	inLT

inTop:	str	vj_r, [fp, temp_s]		//@@@ temp = v[j];@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	str	vjg_r, [vs_r, j_r, SXTW2]	// I think this stores the values of v[j+gap] into where v[j] was
	ldr	temp_r, [fp, temp_s]		// Loads temp for putting into v[j + gap]
	str	temp_r, [vs_r, imm_r, SXTW2]	// Stores temp into v [j+gap]

	ldr	j_r, [fp, j_s]			// load j register
	ldr	gap_r, [fp, gap_s]		// load gap register
	sub	j_r, j_r, gap_r			// @@@ for (... j -= gap) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	str	j_r, [fp, j_s]

inLT:	ldr	j_r, [fp, j_s]			// load j register
	cmp 	j_r, 0				// @@@for (... j>= 0...) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	b.ge	inLT2				// @@@for (... && ...)@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	b	inDone				// if first test fails we can just exit loop

inLT2:	ldr	j_r, [fp, j_s]			// load j for v[j]
	ldr	gap_r, [fp, gap_s]		// load gap for v[j+gap]
	ldr	vj_r, [vs_r, j_r, SXTW2]	// Accessing v[j]
	
	add	imm_r, j_r, gap_r		// j + gap into imm register
	ldr	vjg_r, [vs_r, imm_r, SXTW2]	// Accessing v[j + gap]

	cmp	vj_r, vjg_r			// @@@ for (... v[j] < v[j+gap];...)@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 	b.lt	inTop				// branch inner loop if true

inDone:
	ldr	i_r, [fp, i_s]			// Load i into i register
	add	i_r, i_r, 1			// @@@ for (... i++) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	str	i_r, [fp, i_s]			// Store i back into i_s

midLT:	ldr	i_r, [fp, i_s]			// Load i into i register
	cmp	i_r, SIZE			// Compare i with SIZE
	b.lt	midTop				// @@@ for(...i < SIZE;...)@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@




	ldr	gap_r, [fp, gap_s]		// Access gap
	udiv	gap_r, gap_r, imm2_r		// @@@ for(... gap /= 2) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	str	gap_r, [fp, gap_s]		// Store gap at gap_s

outLT:	ldr	gap_r, [fp, gap_s]		// Load gap from RAM
	cmp	gap_r, 0			// Compare gap with 0
	b.gt	outTop				// branch if gap > 0;


						//*** Display the sorted array ********************************************************************************

print3:	adrp	x0, line3			//@@@ printf("Sorted Array:\n"); @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	add	x0, x0, :lo12:line3		// Sticks string line3 into x0
	bl	printf				// Calls print function

	mov	i_r, 0				// i = 0 in the for loop below
	str	i_r, [fp, i_s]			// Stores i into i_s
	b	p4LT				// Branch to the print4LoopTest

						//@@@ printf("v[%d] = %d\n", i, v[i]); @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
print4: ldr	w1, [fp, i_s]			// Loads i for the print function
	ldr	w2, [vs_r, i_r, SXTW2]		// Access v[i] for the print function

	ldr	i_r, [fp, i_s]			// Access [i]
	add	i_r, i_r, 1			// i++
	str	i_r, [fp, i_s]			// Store i at i_s

	adrp	x0, line2			// Print stuff
	add	x0, x0, :lo12:line2		// Store line 2
	bl	printf				// Print

						//@@@ for (i = 0; i <SIZE; i++) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
p4LT:	ldr	i_r, [fp, i_s]			// Load i from RAM
	cmp	i_r, SIZE			// Compare i with SIZE, which is 100
	b.lt	print4				// branch if i < SIZE



done:	ldp	fp, lr, [sp], dealloc		// You need to change the unload code as well
	ret					//@@@ return 0; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



