.data
	C_usage: .asciiz "===Collatz Conjecture===\n"
	C_promt: .asciiz "Enter a positive integer: "
	C_newline: .asciiz "\n"
	C_coma: .asciiz ", "
	C_colon: .asciiz ": "
	
.text
	C_main: 
		jal C_print_usage
		#Promt the user to enter a number
		jal C_print_promt
		#Take input
		li $v0, 5
		syscall
		
		
		#Store user input at $s0
		move $s0, $v0
		#Make a copy of input at $t0
		move $t0, $s0
		
		#Print input
		li $v0, 1
		move $a0, $t0
		syscall
		jal C_print_colon
		
		#Load 1 to  $t1
		li $t1, 1
		#Load 3 to $t3
		li $t3, 3
		#Load 2 to $t4
		li $t4, 2
		
		C_loop:
			#Exit if collatz 
			#Series reach 1
			#The input is smaller or equal to 1
			ble $t0, $t1, C_exit
			
			#Get LSB of $t0 and put it in $t2
			andi $t2, $t0, 1
			
			#The number is even
			beqz $t2, C_even
			
			C_odd:
				mult $t0, $t3
				mflo $t0
				addi $t0, $t0, 1
				
				#print number
				li $v0, 1
				move $a0, $t0
				syscall
				jal C_print_coma
			
			C_even:
				div $t0, $t4
				mflo $t0
				
				#print number
				li $v0, 1
				move $a0, $t0
				syscall
				jal C_print_coma
			

			j C_loop

	C_exit:
		jal C_print_newline
		li $v0, 10	
		syscall	
	
###Printing procedures###
	C_print_usage:
		li $v0, 4
		la $a0, C_usage
		syscall
		jr $ra

	C_print_promt:
		li $v0, 4
		la $a0, C_promt
		syscall
		jr $ra
		
	C_print_newline:
		li $v0, 4
		la $a0, C_newline
		syscall
		jr $ra
		
	C_print_coma:
		li $v0, 4
		la $a0, C_coma
		syscall
		jr $ra
		
	C_print_colon:
		li $v0, 4
		la $a0, C_colon
		syscall
		jr $ra		
