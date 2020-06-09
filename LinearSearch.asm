.data
	L_usage: .asciiz "===LINEAR SEARCH USAGE===\nMax list size is 32, only positive integers.\nEnter '-1' to conclude list\n"
	L_promt1: .asciiz "Enter list item: "
	L_promt2: .asciiz "Enter target number: "
	L_promt3: .asciiz "Target found in the list! Index: "
	L_promt4: .asciiz "Target not found :("
	L_newline: .asciiz "\n"
	L_coma: .asciiz ", "
	L_arr: .word  -1:32
	
.text
	L_main: 
		jal L_print_usage
		
		addi $t0, $zero, 0 #Index(Offset) = $t0, to be increment by 4
		addi $t1, $zero, 0 #counter for number of elements entered
	
	L_input_list_loop:
		beq $v0, -1, L_input_target	#Exit on -1
		beq $t1, 32,  L_input_target	#Exit on max list size is reached
		
		#Promt the user to enter list item
		jal L_print_promt1
		li $v0, 5
		syscall
		
		#Store result in arr(offset)
		sw $v0, L_arr($t0)
		
		addi $t0, $t0, 4 #Increment offset
		addi $t1, $t1, 1 #Increment number of elements entered
		
		j L_input_list_loop
	
	L_input_target:
		#Promt the user to enter list item
		jal L_print_promt2
		li $v0, 5
		syscall
		
		#Store result in $s7
		move $s7, $v0
		
		#Prepare for search
		la $a1, L_arr
		move $a2, $s7
		jal L_search_array
		
		j L_exit
		
	#search_array($a1 = array adress, $a2 = key) $v1 = 1 if found, zero if not found
	L_search_array:
		addi $t8, $a1, 0  	#Start of the array
		addi $t9, $a1, 256 	#End of the array 32*4(sizeof int)
		addi $t6, $zero, 0  #Loop counter
		addi $t5, $zero, -1
		
		L_search_loop:
			lw $t7, 0($t8)	#$t7 = current element
			beq $t8, $t9, L_not_found
			beq $t7, $t5, L_not_found
			beq $t7, $a2, L_found
			addi $t8, $t8, 4 #increment counter
			
			
			addi $t6, $t6, 1
			j L_search_loop
			L_not_found:
				jal L_print_promt4
				j L_exit
				
			L_found:
				jal L_print_promt3
				li $v0, 1
				move $a0, $t6
				syscall
				j L_exit
		
	L_exit:
		jal L_print_newline
		li $v0, 10	
		syscall	
	
###Printing procedures###
	L_print_usage:
		li $v0, 4
		la $a0, L_usage
		syscall
		jr $ra

	L_print_promt1:
		li $v0, 4
		la $a0, L_promt1
		syscall
		jr $ra
		
	L_print_promt2:
		li $v0, 4
		la $a0, L_promt2
		syscall
		jr $ra
		
	L_print_promt3:
		li $v0, 4
		la $a0, L_promt3
		syscall
		jr $ra
	
	L_print_promt4:
		li $v0, 4
		la $a0, L_promt4
		syscall
		jr $ra	
		
	L_print_newline:
		li $v0, 4
		la $a0, L_newline
		syscall
		jr $ra
		
	L_print_coma:
		li $v0, 4
		la $a0, L_coma
		syscall
		jr $ra
