.data
newline: .asciiz "\n"
semicolon: .asciiz ": "
success: .asciiz ": Palindrome"
failure: .asciiz ": Not Palindrome"
input_str: .space 64
input_yn: .space 2
input_y: .word 'y'
input_n: .byte 'n'
promt1: .asciiz "Do you want to continue (y/n)?\n"
promt2: .asciiz "\nPlease enter the last word:\n"   
promt3: .asciiz "said yes\n"
promt4: .asciiz "\nGoodbye...\n"

_1:     .asciiz "WoW: Palindrome" 
_2:     .asciiz "illi: Palindrome"
_3:     .asciiz "kayak: Palindrome"
_4:     .asciiz "level: Palindrome"
_5:     .asciiz "lol: Palindrome"
_6:     .asciiz "mom: Palindrome"
_7:     .asciiz "tek: Not Palindrome"
_8:     .asciiz "racecar: Palindrome"
_9:     .asciiz "radar: Palindrome"
_10:    .asciiz "kek: Palindrome"
_11:    .asciiz "cok: Not Palindrome"
_12:    .asciiz "fazla: Not Palindrome"
_13:    .asciiz "odevim: Not Palindrome"
_14:    .asciiz "var: Not Palindrome"
_15:    .asciiz "projeler: Not Palindrome"
_16:    .asciiz "bitmiyor: Not Palindrome"
_17:    .asciiz "neden: Palindrome"
_18:    .asciiz "bes: Not Palindrome"
_19:    .asciiz "tane: Not Palindrome"
_20:    .asciiz "ders: Not Palindrome"
_21:    .asciiz "ve: Not Palindrome"
_22:    .asciiz "bitirme: Not Palindrome"
_23:    .asciiz "projesi: Not Palindrome"
_24:    .asciiz "aldim: Not Palindrome"
_25:    .asciiz "bilmiyorum: Not Palindrome"
_26:    .asciiz "abcd: Not Palindrome"
_27:    .asciiz "123: Not Palindrome"
_28:    .asciiz "321: Not Palindrome"
_29:    .asciiz "5511: Not Palindrome"
_30:    .asciiz "cse: Not Palindrome"
_31:    .asciiz "ysa: Not Palindrome"
_32:    .asciiz "operating: Not Palindrome"
_33:    .asciiz "systems: Not Palindrome"
_34:    .asciiz "was: Not Palindrome"
_35:    .asciiz "ar: Not Palindrome"
_36:    .asciiz "mistake: Not Palindrome"
_37:    .asciiz "arthas: Not Palindrome"
_38:    .asciiz "did: Palindrome"
_39:    .asciiz "nothing: Not Palindrome"
_40:    .asciiz "wrong: Not Palindrome"
_41:    .asciiz "demon: Not Palindrome"
_42:    .asciiz "hunters: Not Palindrome"
_43:    .asciiz "are: Not Palindrome"
_44:    .asciiz "OP: Not Palindrome"
_45:    .asciiz "shadow: Not Palindrome"
_46:    .asciiz "lands: Not Palindrome"
_47:    .asciiz "gtude: Not Palindrome"
_48:    .asciiz "BES: Not Palindrome"
_49:    .asciiz "SENE: Not Palindrome"
_50:    .asciiz "dile: Not Palindrome"
_51:    .asciiz "kolay: Not Palindrome"
_52:    .asciiz "never: Not Palindrome"
_53:    .asciiz "gonna: Not Palindrome"
_54:    .asciiz "give: Not Palindrome"
_55:    .asciiz "you: Not Palindrome"
_56:    .asciiz "up: Not Palindrome"
_57:    .asciiz "never: Not Palindrome"
_58:    .asciiz "gonna: Not Palindrome"
_59:    .asciiz "let: Not Palindrome"
_60:    .asciiz "you: Not Palindrome"
_61:    .asciiz "down: Not Palindrome"
_62:    .asciiz "never: Not Palindrome"
_63:    .asciiz "gonna: Not Palindrome"
_64:    .asciiz "run: Not Palindrome"
_65:    .asciiz "around: Not Palindrome"
_66:    .asciiz "and: Not Palindrome"
_67:    .asciiz "desert: Not Palindrome"
_68:    .asciiz "you: Not Palindrome"
_69:    .asciiz "never: Not Palindrome"
_70:    .asciiz "gona: Not Palindrome"
_71:    .asciiz "make: Not Palindrome"
_72:    .asciiz "you: Not Palindrome"
_73:    .asciiz "cry: Not Palindrome"
_74:    .asciiz "never: Not Palindrome"
_75:    .asciiz "gonna: Not Palindrome"
_76:    .asciiz "say: Not Palindrome"
_77:    .asciiz "goodbye: Not Palindrome"
_78:    .asciiz "never: Not Palindrome"
_79:    .asciiz "gonna: Not Palindrome"
_80:    .asciiz "tell: Not Palindrome"
_81:    .asciiz "ar: Not Palindrome"
_82:    .asciiz "lie: Not Palindrome"
_83:    .asciiz "and: Not Palindrome"
_84:    .asciiz "hurt: Not Palindrome"
_85:    .asciiz "you: Not Palindrome"
_86:    .asciiz "UART: Not Palindrome"
_87:    .asciiz "I2C: Not Palindrome"
_88:    .asciiz "tursu: Not Palindrome"
_89:    .asciiz "yogurt: Not Palindrome"
_90:    .asciiz "ekmek: Not Palindrome"
_91:    .asciiz "perde: Not Palindrome"
_92:    .asciiz "monitor: Not Palindrome"
_93:    .asciiz "su: Not Palindrome"
_94:    .asciiz "mips: Not Palindrome"
_95:    .asciiz "assembly: Not Palindrome"
_96:    .asciiz "bbq: Not Palindrome"
_97:    .asciiz "logitech: Not Palindrome"
_98:    .asciiz "nvidia: Not Palindrome"
_99:    .asciiz "amd: Not Palindrome"
_100:   .asciiz "intel: Not Palindrome"


# Here each value in str_array is a label that gets replaced by the label
# address by the assembler. Each such label is a address (pointer) to a
# null terminated string. Hence this is an array of pointer to strings, that is,
# an array of strings.

palindrome_dictionary: .word _100, _2, _3, _4, _5, _6, _7, _8, _9, 
                _10, _11, _12, _13, _14, _15, _16, _17, _18, _19,
                _20, _21, _22, _23, _24, _25, _26, _27, _28, _29,
                _30, _31, _32, _33, _34, _35, _36, _37, _38, _39,
                _40, _41, _42, _43, _44, _45, _46, _47, _48, _49,
                _50, _51, _52, _53, _54, _55, _56, _57, _58, _59,
                _60, _61, _62, _63, _64, _65, _66, _67, _68, _69,
                _70, _71, _72, _73, _74, _75, _76, _77, _78, _79,
                _80, _81, _82, _83, _84, _85, _86, _87, _88, _89,
                _90, _91, _92, _93, _94, _95, _96, _97, _98, _99, _1
                
.text

main:   
    li $s1, 0           # Initialize array offset.
    li $s2, 396         # Last offset. 99 strings address * 4 bytes 
    li $s3, 1           # Index

loop:
    
    # print index
    li $v0, 1
    move $a0, $s3
    syscall
    
    #increment index
    addi $s3, $s3, 1
    
    # print semicolon
    jal print_semicolon
    
    # print array element
    li $v0, 4                           
    lw $a0, palindrome_dictionary($s1)  
    syscall

    jal print_newline
    
    addi $s1, $s1, 4    # Increment offset for next item
    ble $s1, $s2, loop  # Keep looing while $s1 <= $s2

user_input:
    # Ask user for (y/n)
    jal print_promt1
    
    # Get user input for continuing
    li $v0, 8
    la $a0, input_yn
    li $a1, 2
    syscall
    
evaluate:
    lb $t1, 0($a0)
    lw $t2, input_y
    bne $t1,$t2, exit
    
    jal print_promt2
    
    # Get user input string
    li $v0, 8
    la $a0, input_str
    li $a1, 64
    syscall
    
    # Print 101:
    li $v0, 1
    li $a0, 101
    syscall
    jal print_semicolon
    
    # user input
    li $v0, 4
    la $a0, input_str
    syscall
    

strlen:
    la $t0, input_str

strlen_loop:
    lb   $t1, 0($t0)
    beq  $t1, $zero, strlen_end
    addi $t0, $t0, 1
    j   strlen_loop

strlen_end:
    la      $t1, input_str
    sub     $t3, $t0, $t1 
    subi    $t3, $t3, 1 # Strlen of input is in $t3
    
    la  $s5, input_str
    la  $s6, ($t3)

is_palindrome:
    # Check base case
    slti    $t0, $s6, 2
    bne     $t0, $zero, succ

    # Make sure first and last are equal
    lb      $t0, 0($s5)
    addi    $t1, $s6, -1
    add     $t1, $t1, $s5
    lb      $t1, 0($t1)
    bne     $t0, $t1, fail
    
    # Shift pointer, length, recurse
    addi    $s6, $s6, -2
    addi    $s5, $s5, 1
    j       is_palindrome
    
fail:
    jal print_failure
    j   exit


succ:
    jal print_success
    j   exit


exit:
    jal print_promt4
    li $v0, 10          # Exit the program.
    syscall
    
    
print_newline:
        li $v0, 4
        la $a0, newline
        syscall
        jr $ra

print_semicolon:
        li $v0, 4
        la $a0, semicolon
        syscall
        jr $ra

print_promt1:
        li $v0, 4
        la $a0, promt1
        syscall
        jr $ra
        
print_promt2:
        li $v0, 4
        la $a0, promt2
        syscall
        jr $ra
        
print_promt3:
        li $v0, 4
        la $a0, promt3
        syscall
        jr $ra
        
print_promt4:
        li $v0, 4
        la $a0, promt4
        syscall
        jr $ra

print_success:
        li $v0, 4
        la $a0, success
        syscall
        jr $ra

print_failure:
        li $v0, 4
        la $a0, failure
        syscall
        jr $ra
        