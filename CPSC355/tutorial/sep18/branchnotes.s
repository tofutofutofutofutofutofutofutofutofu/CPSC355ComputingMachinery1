	.global main
main:	stp x29, x30, [sp, -16]!
	mov x29, sp
startDB:
	mov x0, 10
	b final		//This skips over to the label final
	mov x0, 20	//This instruction will never run
endDB:			//great for loops if while loops and everything for program flow
final:	ldp x29, x30, [sp],16
	ret


// Usually we will not use branches like this 
// Usually it will be b.eq b equal 
// b.nq b not equal
// b.lt branch lower than
// b.gt brand greater than
//b.le branch less than or equal
//b.ge  brand greater than or equal

// flags z for zero
// 	n for negative
// 	v for overflow
// 	c for carry

// move x0,10
// move x1,10
//subs x3,x0,x1
// s on the end stands for set lags
// after this line, the z flag will be 1 since 10-10 is 0
//n will be 0 since it's not negative
// v =0 
// c= 0 no overflow or carry happening
//each register will have these flags

// if z =1 we branch with b.eq
// if z =0 then b.nq happens

// b.eq test
//b next
//test : mov x1,20
//bl printf 
