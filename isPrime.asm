# File: isPrime.asm
# Author: Corey Naas
# Date: 2017/02/16
# Desc: A program to determine if a given number is prime or not prime.

# Changelog:
# 2017/02/16, 05:30: Inital creation
# 2017/02/16, 22:00: formatting, isPrime tweaking

## Numbers of interest
# 49, 55, 15,485,863

.data
	prompt:	.asciiz	"Enter a number: "
	tru:		.asciiz	"Prime\n"
	falze:		.asciiz	"Not Prime\n"

.text
#****************
# Testing wrapper for isPrime(m)
#
# Register Usage
# $s0 = result of isPrime: 0 if false, 1 if true
#****************
main:
	li 	$v0,	4		#prints prompt, "Enter a number:"
	la	$a0,	prompt		#prints prompt
	syscall			#execute
	
	li 	$v0, 5			#takes in "m" and stores it
	syscall			#execute
	add	$a0, $v0, $zero	#move the result "m" to s0
	jal	isPrime
	
	add	$s1,	$v0,	$zero
	beq	$s1,	0,	__fals	#branch if m is not a prime
	beq	$s1,	1	__true	#branch if m is a prime
	
__true:
	li 	$v0,	4		#prints tru, "Prime..."
	la	$a0,	tru		#prints tru
	syscall			#execute
	j	__end
	
__fals:
	li 	$v0,	4		#prints falze, "Not prime..." 
	la	$a0,	falze		#prints falze
	syscall			#execute
	j	__end
	
__end:
	j	main			#creates a looping prompt for testing purposes
	li 	$v0,	10		#exit
	syscall
	
#****************
# isPrime(m)
# Tests to see whether input m is a prime number.
#
# Input:
#	value stored at $a0
# Output:
#	value stored at $v0
#
# Register Usage:
# $t0 = m
# $t1 = temp from mult or div
# $t2 = counter i
# $t3 = counter i + 2
# $t4 = divisor temp
#****************
isPrime:
	move	$t0,	$a0		#move argument to s0
	
	##backup $ra
	sub 	$sp,	$sp,	4	#move stack pointer
	sw 	$ra,	0($sp)		#save $ra to the stack + 0
	
	##test for basic cases
	beq	$t0,	1,	isFals	#return false if m = 1
	beq	$t0,	2,	isTrue	#return true if m = 2
	beq	$t0,	3,	isTrue	#return true if m = 3
	
	##m mod 2 test
	add	$t4,	$zero,	2	#divisor 2
	div	$t0,	$t4		#divide m by 2
	mfhi	$t1			#store remainder in $t1
	beq	$t1,	$zero,	isFals	#return false if m mod 2 = 0
	
	##m mod 3 test
	add	$t4,	$zero,	3	#divisor 3
	div	$t0,	$t4		#divide m by 3
	mfhi	$t1
	beq	$t1,	$zero,	isFals	#return false if m mod 3 = 0
	
	##set up loop
	add	$t2,	$zero,	5	#i = 5
	mult	$t0,	$t0		#i * i = $t1
	mflo	$t1
primeLoop:
	bgt	$t1,	$t0,	isTrue	#return true if i*i > m
	
	##m mod i test
	div	$t0,	$t2		#divide m by i
	mfhi	$t1
	beq	$t1,	$zero,	isFals	#return false if n mod i = 0
	
	##m mod (i+2) test
	add	$t3,	$t2,	2	#i+2
	div	$t0,	$t3		#divide m by (i+2)
	mfhi	$t1
	beq	$t1,	$zero,	isFals	#return false if n mod (i+2) = 0 
	
	#increment and iterate loop
	add	$t2,	$t2,	6	#i = i+6
	mult	$t0,	$t0		#i*i = $t1
	mflo	$t1
	j 	primeLoop
isFals:
	add	$v0, 	$zero,	0
	j	primeReturn
isTrue:
	add	$v0,	$zero,	1
	j	primeReturn
primeReturn:
	##restores $ra to register and returns to caller
  	lw	$ra,	0($sp)		#load $ra from stack + 0
  	add	$sp,	$sp,	4	#move stack pointer
	jr 	$ra