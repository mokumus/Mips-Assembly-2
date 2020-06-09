.data
	B_usage: .asciiz "===BINARY SEARCH USAGE===\nMax list size is 32, only positive integers, ordered list.\nEnter '-1' to conclude list\n"
	B_promt1: .asciiz "Enter list item: "
	B_promt2: .asciiz "Enter target number: "
	B_promt3: .asciiz "Target found in the list! Index: "
	B_promt4: .asciiz "Target not found :("
	B_newline: .asciiz "\n"
	B_coma: .asciiz ", "
	B_arr: .word  -1:32
	
.text
	B_main: 
		jal B_print_usage
		
		addi $t0, $zero, 0 #Index(Offset) = $t0, to be increment by 4
		addi $t1, $zero, 0 #counter for number of elements entered
	
	B_input_list_loop:
		beq $v0, -1, B_input_target	#Exit on -1
		beq $t1, 32, B_input_target	#Exit on max list size is reached
		
		#Promt the user to enter list item
		jal B_print_promt1
		li $v0, 5
		syscall
		
		#Store result in arr(offset)
		sw $v0, B_arr($t0)
		
		addi $t0, $t0, 4 #Increment offset
		addi $t1, $t1, 1 #Increment number of elements entered
		
		j B_input_list_loop
	
	B_input_target:
		#Promt the user to enter list item
		jal B_print_promt2
		li $v0, 5
		syscall
		
		#Store result in $s7
		move $s7, $v0
		
		#Prepare for search
		sub $t1, $t1, 1 # Subtrack exit input from list size
		
		li $a0, 0
		la $a1, ($t1)
		la $a2, B_arr
		la $a3, ($v0)

		jal B_binary_search
		
		j B_exit
		
				
	#binary_search($a0 = low, $a1 = high, $a2 = *arr, $a3 = key)						
	B_binary_search:
		move $s0, $a0
        move $s1, $a1
        move $s2, $a2
        move $s3, $a3
        
      
       B_binary_search_loop:
       		addi $t0, $s0, 1		# $t0 = low + 1
        	beq  $t0, $s1, B_end_search	# if low+1 == high, end the search
        	
        	add $s4, $s0, $s1		# calculate size = $s4
        	srl $s4, $s4, 1			# calculate mid point = $s4/2
        	sll $t0, $s4, 2			# calculate address of mid point
        	add $t0, $t0, $s2		# calculate address of mid point
        	lw $t1, 0($t0)			# calculate address of mid point = $t1
        	slt $t0, $s3, $t1		# if (value < nums[mid] $t0 = 1; otherwise it equals 0     $t0 = 1 if key < arr[mid]
        	beq $t0, $zero, B_check_right_half	# if key > arr[mid]
        		#ELSE: # check right side if key < arr[mid]
        		B_check_left_half:  
        			#Prepare for binary_search()
        			move $a1, $s4			# update high bound
        			move $a0, $s0			
        			jal B_binary_search		
        			move $a1, $s1			# Restore caller $a1 argument(high)
       				j B_binary_search_loop	
       	
       		B_check_right_half: # check right side
       			#Prepare for binary_search() 
				move $a0, $s4			# update low bound
				jal B_binary_search		
				move $a0, $s0			# Restore caller $a0 argument(low)
				j B_binary_search_loop
				
		B_end_search:
        	beq $s4, -1,  B_not_found
        	bne $s3, $s1, B_not_found
        	B_found:
        		jal B_print_promt3
				li $v0, 1
				move $a0, $s0
				syscall
				j B_exit		
			 B_not_found:
        		jal B_print_promt4
        		j B_exit
	B_exit:
		jal B_print_newline
		li $v0, 10	
		syscall	
	
###Printing procedures###
	B_print_usage:
		li $v0, 4
		la $a0, B_usage
		syscall
		jr $ra

	B_print_promt1:
		li $v0, 4
		la $a0, B_promt1
		syscall
		jr $ra
		
	B_print_promt2:
		li $v0, 4
		la $a0, B_promt2
		syscall
		jr $ra
		
	B_print_promt3:
		li $v0, 4
		la $a0, B_promt3
		syscall
		jr $ra
	
	B_print_promt4:
		li $v0, 4
		la $a0, promt4
		syscall
		jr $ra	
		
	B_print_newline:
		li $v0, 4
		la $a0, B_newline
		syscall
		jr $ra
		
	B_print_coma:
		li $v0, 4
		la $a0, B_coma
		syscall
		jr $ra
