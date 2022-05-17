// Author:	Christopher Lee	ID:110136117	Tutorial Section: T09
// Version 3:	November 3nd, 2021
// Program Features:
// 	printPyramid()
// 	newPyramid()
// 	Structs
// 	relocate()
// 	expand()
// 	equalSize()
// 	main()
// 	Stack variables
// 	script
// 	Documentation
// 	Formatting
// 	Design
// Missing Features:
//	All done

// Version a:	November 2nd, 2021
// Program Features:
// 	printPyramid()
// 	newPyramid()
// 	Structs
// Missing Features:
// 	relocate()
// 	expand()
// 	equalSize()
// 	main()
// 	Stack variables
// 	script
// 	Documentation
// 	Formatting
// 	Design




INTSIZE = 4
							// struct coord{
coord_x = 0						// 	int x,
cx_size = INTSIZE					// 
coord_y = coord_x + cx_size				// 	int y;
cy_size = INTSIZE					//
coord_size = cy_size + cx_size				// }; coord memory allocation

							// struct size{
size_width = 0						// int width,
sw_size = INTSIZE					// 
size_length = size_width + sw_size			// int length;
sl_size = INTSIZE					//
si_size = sw_size + sl_size				// }; size memory allocation

							// struct pyramid{
pyramid_coord = 0					// 	struct coord center;
pc_size = coord_size					//		coord memory size
pyramid_size = pyramid_coord + pc_size			//	struct size base;
ps_size = si_size					//		size memory size
pyramid_height = pyramid_size + ps_size			//	int height;
ph_size = INTSIZE					//		height memory size
pyramid_volume = pyramid_height + ph_size		// 	int volume;
pv_size = INTSIZE					//		volume memory size
py_size = pc_size + ps_size + ph_size + pv_size		//		pyramid memory size

main_alloc = -(16 + py_size + py_size) & -16		// We've got two pyramids so far
main_dealloc = -main_alloc

fp	.req	x29
lr	.req	x30

khaf_b	.req	x19
cheo_b	.req	x20
khaf_s = 16
cheo_s = khaf_s + py_size

p_b_r	.req	x9					// try not to use x9 for other things in nPyra otherwise segmentation error
p_size = py_size
nPyra_alloc = -(16 + py_size) & -16
nPyra_dealloc = -nPyra_alloc
p_s = 16

STn_size = 4
STp_size = 4
pPyra_alloc = -(16 + STn_size + STp_size) & -16
pPyra_dealloc = -pPyra_alloc
STn_s = 16
STp_s = 20

result_size = INTSIZE
equal_alloc = -(16 + result_size) & -16
equal_dealloc = -equal_alloc
result_s = 16

line1:	.string	"Initial pyramid values:\n"
line2:	.string "khafre"
line3: 	.string "Pyramid %s\n"
line4:	.string "\tCenter = (%d, %d)\n"
line5:	.string "\tBase width = %d Base length = %d\n"
line6:	.string "\tHeight = %d\n"
line7: 	.string "\tVolume = %d\n\n"
line8:	.string "cheops"
line9: 	.string "\nNew pyramid values:\n"
line10: .string	"HUGE CHUNGUS\n"

	.balign 4
	.global main
main:	stp	fp, lr, [sp, main_alloc]!		// Same old same old
	mov	fp, sp					// You know the deal
	
	add	khaf_b, fp, khaf_s			// Creating the base register for khafre
	mov	x8, khaf_b				// Moving khafre into x8 so newPyramid can return it
	mov	x0, 10					// Preparing int width for newPyramid()
	mov	x1, 10					// int length for newPyramid()
	mov 	x2, 9					// int height for newPyramid()
	bl	nPyra					// khafre = newPyramid(10, 10, 9)

	add	cheo_b, fp, cheo_s			// Creating the base register for cheops
	mov	x8, cheo_b				// Moving cheops into x8 so newPyramid can return it
	mov	x0, 15					// Preparing int width for newPyramid()
	mov	x1, 15					// int length for newPyramid()
	mov	x2, 18					// int height for newPyramid()
	bl	nPyra					// cheops = newPyramid(15, 15, 18)

	adrp	x0, line1				// Loading "Inital pyramid values:\n"
	add	x0, x0, :lo12:line1			// Loading low 12
	bl	printf					// printf("Inital pyramid values:\n");

	ldr	x0, =line2				// Loading the *name with line2
	mov	x1, khaf_b				// Loading *p with address of khaf
	bl	pPyra					// @@@ printPyramid("khafre", &khafre);

	ldr	x0, =line8				// Loading the *name with line8
	mov	x1, cheo_b
	bl 	pPyra					// @@@ printPyramid("cheops", &cheops);

	mov	x0, khaf_b				// Loading *p1
	mov	x1, cheo_b				// Loading *p2
	bl	equal					// equalSize(&khafre, &cheops)
	
	cmp	w0, 0				// if (!equalSize(&khafre, &cheops))
	b.eq	mainIf					// branch to inside the if
	b	m_done					// branch to end to the if

mainIf: mov	x0, cheo_b				// Loading &cheops
	mov 	x1, 9					// Loading 9
	bl	expand					// @@@ expand(&cheops, 9);

	mov	x0, cheo_b				// Loading &cheops
	mov	x1, 27					// Loading 27
	mov	w2, -10					// Loading -10
	bl 	relo					// @@@ relocate(&cheops, 27, -10);

	mov 	x0, khaf_b				// Loading &kahfre
	mov	w1, -23					// Loading -23
	mov	w2, 17					// Loading 17
	bl	relo					// @@@ relocate(&khafre, -23, 17);

m_done:	adrp	x0, line9				// Loading "\nNew pyramid values:\n"
	add	x0, x0, :lo12:line9			// Loading :lo12:"\nNew pyramid values:\n"
	bl	printf					// @@@ printf("\nNew pyramid values:\n");

	ldr	x0, =line2				// Loading the *name with line2
	mov	x1, khaf_b				// Loading *p with address of khaf
	bl	pPyra					// @@@ printPyramid("khafre", &khafre);

	ldr	x0, =line8				// Loading the *name with line8
	mov	x1, cheo_b
	bl 	pPyra					// @@@ printPyramid("cheops", &cheops);

	ldp	fp, lr, [sp], main_dealloc		// GoodBye I'm done with my data
	ret						// I want to go back to calling code

nPyra:	stp	fp, lr, [sp, nPyra_alloc]!		// Allocate memory for one pyramid
	mov	fp, sp					// Move fp
	
	add 	p_b_r, fp, p_s				// Prepare the p variable base register
	str	wzr, [p_b_r, pyramid_coord + coord_x]	// p.center.x = 0
	str	wzr, [p_b_r, pyramid_coord + coord_y]	// p.center.y = 0
	str	w0, [p_b_r, pyramid_size + size_width]	// p.base.width = width
	str	w1, [p_b_r, pyramid_size + size_length]	// p.base.length = length
	str	w2, [p_b_r, pyramid_height]		// p.height = height
	mul	x10, x0, x1				// (p.base.width * p.base.length)
	mul 	x10, x10, x2				// (p.base.width * p.base.length) * p.height
	mov	x11, 3					// Preparing to divide by 3
	sdiv	x10, x10, x11				// (p.base.width * p.base.length * p.height) / 3
	str	w10, [p_b_r, pyramid_volume]		// p.volume = (p.base.width * p.base.length * p.height) / 3
	
	ldr	w10, [p_b_r, pyramid_coord + coord_x]	// return p;
	str	w10, [x8, pyramid_coord + coord_x]	// return p;
	ldr	w10, [p_b_r, pyramid_coord + coord_y]	// return p;
	str	w10, [x8, pyramid_coord + coord_y]	// return p;
	ldr	w10, [p_b_r, pyramid_size + size_width]	// return p;
	str	w10, [x8, pyramid_size + size_width]	// return p;
	ldr	w10, [p_b_r, pyramid_size + size_length]// return p;
	str	w10, [x8, pyramid_size + size_length]	// return p;
	ldr	w10, [p_b_r, pyramid_height]		// return p;
	str	w10, [x8, pyramid_height]		// return p;
	ldr	w10, [p_b_r, pyramid_volume]		// return p;
	str	w10, [x8, pyramid_volume]		// return p;

	ldp	fp, lr, [sp], nPyra_dealloc		// Dealloc memory
	ret						// go back to calling code

pPyra:	stp	fp, lr, [sp, pPyra_alloc]!		// Allocating memory for *p and *n
	mov	fp, sp					// every time my man
	
	str 	x0, [fp, STn_s]				// char *name
	str	x1, [fp, STp_s]				// struct pyramid *p
	
	mov	x1, x0					// loading *name
	adrp	x0, line3				// loading "Pyramid %s/n"
	add	x0, x0, :lo12:line3			// loading the low12 bits
	bl	printf					// @@@ printf("Pyramid %s\n", name);

	ldr	x15, [fp, STp_s]			// Because printf messes up the registers we have to reload the address pointer argument
	ldr	w1, [x15, pyramid_coord + coord_x]	// loading p->center.x
	ldr	w2, [x15, pyramid_coord + coord_y]	// loading p->center.y
	adrp	x0, line4				// loading "\tCenter = (%d, %d)\n"
	add 	x0, x0, :lo12:line4			// loading low12
	bl	printf					// @@@ printf("\tCenter = (%d, %d)\n", p->center.x, p->center.y);
	
	ldr 	w1, [x15, pyramid_size + size_width]	// loading p->base.width
	ldr	w2, [x15, pyramid_size + size_length]	// loading p->base.length
	adrp 	x0, line5				// loading "\tBase width = %d Base length = %d\n"
	add	x0, x0, :lo12:line5			// loading low12
	bl 	printf					// @@@ printf("\tBase width = %d Base length = %d\n", p->base.width, p->base.length)

	ldr 	w1, [x15, pyramid_height]		// loading p->height
	adrp 	x0, line6				// loading "\tHeight = %d\n"
	add	x0, x0, :lo12:line6			// loading low12
	bl 	printf					// @@@ printf("\tHeight = %d\n", p->height);

	ldr 	w1, [x15, pyramid_volume]		// loading p->volume
	adrp 	x0, line7				// loading "\tVolume = %d\n\n"
	add	x0, x0, :lo12:line7			// loading low12
	bl 	printf					// @@@ printf("\tVolume = %d\n\n", p->volume);

	ldp	fp, lr, [sp], pPyra_dealloc		// deallocating memory for pPyra
	ret						// return to call

equal:	stp	fp, lr, [sp, equal_alloc]!		// Allocate space for the int result
	mov	fp, sp					// Stack bois

	mov	w13, 0				// Loading 0
	str	w13, [fp, result_s]			// @@@ int result = 0;
	
	ldr	w9, [x0, pyramid_size + size_width]	// Loading p1->base.width
	ldr	w10, [x1, pyramid_size + size_width]	// Loading p2->base.width
	cmp	w9, w10					// @@@ if (p1->base.width == p2->base.width)
	b.eq	ifL					// 	then branch to next if
	b	eq_dne					// 	skip to eq_dne

ifL:	ldr	w9, [x0, pyramid_size + size_length]	// Loading p1->base.length
	ldr	w10, [x1, pyramid_size + size_length]	// Loading p2->base.length
	cmp	w9, w10					// @@@ if (p1->base.length == p2->base.length)
	b.eq	ifH					// 	then branch to next if
	b	eq_dne					// 	skip to eq_dne

ifH:	ldr	w9, [x0, pyramid_height]		// Loading p1->height
	ldr	w10, [x1, pyramid_height]		// Loading p2->height
	cmp	w9, w10					// @@@ if (p1->height == p2->height)
	b.eq	letsgo					// 	lets go!
	b	eq_dne					// 	skip to eq_dne

letsgo:	mov	w13, 1				// Loading True
	str	w13, [fp, result_s]			// @@@ int result = 1;

eq_dne:	ldr	w0, [fp, result_s]			// return result;
	ldp	fp, lr, [sp], equal_dealloc		// Deallocating memory for equalSize()
	ret						// Return to call

expand:	stp	fp, lr, [sp, -16]!			// Only need to allocate memory for the frame record for this function
	mov	fp, sp					// Moving frame pointer

	ldr 	w9, [x0, pyramid_size + size_width] 	// Loading p->base.width
	mul	w9, w1, w9				// w9 = p->base.width * factor
	str	w9, [x0, pyramid_size + size_width]	// Store new p->base.width
	
	ldr	w10, [x0, pyramid_size + size_length]	// Loading p->base.length
	mul	w10, w1, w10				// w9 = p->base.length * factor
	str 	w10, [x0, pyramid_size + size_length]	// Store new p->base.length
	
	ldr	w11, [x0, pyramid_height]		// Loading p->height
	mul	w11, w1, w11				// @@@ p->height *= factor;
	str	w11, [x0, pyramid_height]		// Store new p->height

	mul	x12, x9, x10				// (p.base.width * p.base.length)
	mul 	x12, x12, x11				// (p.base.width * p.base.length) * p.height
	mov	x11, 3					// Preparing to divide by 3
	sdiv	x12, x12, x11				// (p.base.width * p.base.length * p.height) / 3

	str	w12, [x0, pyramid_volume]		// Store new p->volume

	ldp	fp, lr, [sp], 16			// Deallocating memory for this SUBROUTINE
	ret						// Returning to calling code

relo:	stp	fp, lr, [sp, -16]!			// No variables to only frame record memory
	mov 	fp, sp					// Moving frame pointer
	
	ldr	w9, [x0, pyramid_coord + coord_x]	// Loading p->center.x
	add	w9, w1, w9				// p->center.x +=deltaX
	str	w9, [x0, pyramid_coord + coord_x]	// Store new p->center.x value

	ldr	w10, [x0, pyramid_coord + coord_y]	// Loading p->center.y
	add	w10, w2, w10				// p->center.x +=deltaY
	str	w10, [x0, pyramid_coord + coord_y]	// Store new p->center.y value

	ldp	fp, lr, [sp], 16			// Deallocating memory for the subroutine
	ret						// Returning to calling code

