.data
	command: .space 100
	p1: .asciiz "Collatz.asm"
	p1_label: .asciiz "C_main"
	p2: .asciiz "BinarySearch.asm"
	p2_label: .asciiz "B_main"
	p3: .asciiz "LinearSearch.asm"
	p3_label: .asciiz "L_main"
	arrow: .asciiz "MuhammedOS>"
.text
	main:
		#Initilize OS
		li $v0, 19
		syscall

		#Init process
		li $v0, 23
		la $a0, p1
		la $a1, p1_label
		syscall

		#Init process
		li $v0, 23
		la $a0, p2
		la $a1, p2_label
		syscall

		#Init process
		li $v0, 23
		la $a0, p3
		la $a1, p3_label
		syscall

		#Execute
		li $v0, 20
		syscall

		loop:
		# read command
		li $v0, 8
		la $a0, command
		li $a1, 100
		syscall
	

	
		li $v0, 18
		la $a0, command
		syscall
		j loop


	
	li $v0 10
	syscall