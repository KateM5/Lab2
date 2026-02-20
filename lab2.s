.section .data
    prompt1: .ascii "Enter string 1: \n"
    p1_len = . - prompt1
    prompt2: .ascii "Enter string 2: \n"
    p2_len = . - prompt2

.section .bss
    string1: .space 256
    string2: .space 256

.section .text
    .globl _start

_start:
    # PRINT PROMPT 1
    mov $1, %rax        # setting RD/W to high so it writes in statements
    mov $1, %rdi        # stdout
    mov $prompt1, %rsi  # buf
    mov $p1_len, %rdx   # len
    syscall

    # READING STRING 1
    mov $0, %rax        # setting RD/W to low so it reads in statements
    mov $0, %rdi        # stdin
    mov $string1, %rsi
    mov $256, %rdx
    syscall

    # PRINT PROMPT 2
    mov $1, %rax        # write
    mov $1, %rdi        # stdout
    mov $prompt2,%rsi   # buf
    mov $p2_len,%rdx    # len
    syscall

    # READING STRING 2
    mov $0, %rax        # setting RD/W to low so it reads in statements
    mov $0, %rdi        # stdin
    mov $string2, %rsi
    mov $256, %rdx
    syscall

    # COMPARING STRINGS
    mov $string1, %rsi
    mov $string2, %rdi
    mov $0, %r12            # register to store distance

compare_loop:
    movb (%rsi), %al
    movb (%rdi), %bl
    
    # stopping when newline / null is hit
    cmp $10, %al
    je done_comparing       # checking user input is not just a newline
    cmp $0, %al
    je done_comparing       # checking user input is not just a null / 0

    xor %bl, %al            # XOR to find bit differences
    mov $8, %cl             # check 8 bits per character

bit_loop:
    shr $1, %al             # shifts bit to the right
    jnc skip_inc            # skips bit if XOR comparison was 0 (no difference)
    inc %r12                # increment r12 if bit was different

skip_inc:
    dec %cl                 # decreases loop counter
    jnz bit_loop            # continues loop as long as %cl != 0

    inc %rsi                # moves to the next letter of the strings
    inc %rdi
    jmp compare_loop        # restarts compare_loop

done_comparing:
    mov %r12, %rdi          # move the final count (r12) into rdi for C
    call print_results

    mov $60, %rax           
    xor %rdi, %rdi         
    syscall

    .section .note.GNU-stack,"",@progbits
