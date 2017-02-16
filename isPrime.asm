#is_Prime

# isPrime(m)
# $s0 = m
# $s1 = temp from mult or div
# $s2 = counter i
# $s3 = 
# $s4 = counter i + 2
# $s5 = divisor
.data
	prompt:	.asciiz "Enter a number: "
	tru:		.asciiz "Prime\n"
	falze:	.asciiz "Not Prime\n"

.text
main:
	li 	$v0,	4		#prints prompt, "Enter a number:"
	la	$a0,	prompt	#prints prompt
	syscall			#execute
	
	li 	$v0, 5		#takes in "m" and stores it
	syscall			#execute
	add	$s0, $v0, $zero#move the result "m" to s0

isPrime:
	beq $s0, 1, false	#return false if m = 1
	beq $s0, 2, true
	beq $s0, 3, true
	add $s5, $zero, 2	#divisor 2
	div $s0 , $s5		#divide m by 2
	mfhi $s1
	beq $s1 $zero, false	#return false if m mod 2 = 0
	add $s5, $zero, 3	#divisor 3
	div $s0, $s5		#divide m by 3
	mfhi $s1
	beq $s1 $zero, false	#return false if m mod 3 = 0
	
	add $s2, $zero, 5	#iterator = 5
	mult $s0, $s0		#i * i = $s1
	mflo $s1
loop:
	bgt $s1, $s0, true	#return true if i*i <= m
	div $s0, $s2		#divide m by i
	mfhi $s1
	beq $s1 $zero, false	#return false if n mod i = 0
	add $s4, $s1, 2		#i+2
	div $s0, $s4		#divide m by (i+2)
	mfhi $s1
	beq $s1 $zero, false	#return false if n mod (i+2) = 0 
	add $s2, $s2, 6
false:
	li 	$v0,	4		#prints falze, "Not prime..." 
	la	$a0,	falze	#prints falze
	syscall			#execute
	j end
true:
	li 	$v0,	4		#prints tru, "Prime..."
	la	$a0,	tru		#prints tru
	syscall			#execute
	
end:
	j main
