; Giancarlo Gabriel Trani
; Mikaella Louise Layug

.model small
.data
    enter_expression db 13, 10, "Enter expression: ", "$"
    invalid_input db 13, 10, "Invalid input!", "$"
    sum db 13, 10, "The sum of ", "$"
    difference db 13, 10, "The difference of ", "$"
    product db 13, 10, "The product of ", "$"
    quotient db 13, 10, "The quotient is ", "$"
    remainder db " and remainder is ", "$"
    and_ db " and ", "$"
    is db " is ", "$"
    newline db 13, 10, "$" 
    expression db 6 dup("$")

    first_num_ones db ?
    first_num_tens db ?
    second_num_ones db ?
    second_num_tens db ?
    answer_ones db ?
    answer_tens db ?
    answer_carry db ?
    answer_remainder db ?
    first_number db ?
    second_number db ?
  
.stack 100h    
.code

    printdig proc
        push dx 
        mov dl, al  
        add dl, 30h

        mov ah,02h
        int 21h
        pop dx
        ret
    printdig endp

    main proc near
        mov ax, @data
        mov ds, ax

        ; enter expression prompt
        lea dx, enter_expression
        mov ah, 09h
        int 21h

        lea si, expression
        xor cx, cx
        mov cx, 6

        ; loop to get user input as array
        @get_user_input: ; [si] -> value at that index
        mov ah, 01h
        mov [si], al
        int 21h

        inc si
        loop @get_user_input

        ; newline
        lea dx, newline
        mov ah, 09h
        int 21h

        ; ; getting operator
        ; mov ah, 02h
        ; mov dl, expression[3]
        ; int 21h

        ; if statement
        .if expression[3] == '+'
        jmp @perform_addition

        .elseif expression[3] == '-'
        jmp @compare_tens

        .elseif expression[3] == '*'
        jmp @perform_multiplication

        .elseif expression[3] == '/'
        jmp @perform_division

        .else
        lea dx, invalid_input
        mov ah, 09h
        int 21h
        .endif

        @perform_addition:
        mov bh, expression[1]
        mov first_num_tens, bh
        xor bx, bx

        mov bl, expression[2]
        mov first_num_ones, bl
        xor bx, bx

        mov bh, expression[4]
        mov second_num_tens, bh
        xor bx, bx

        mov bl, expression[5]
        mov second_num_ones, bl
        xor bx, bx

        mov bl, second_num_tens
        cmp first_num_tens, bl
        mov bl, 00h

        ; addition of ones 
        mov al, first_num_ones
        mov ah, 00h  
        add al, second_num_ones
        aaa

        ; converting to character
        add ax, 3030h 
        mov answer_ones, al

        ; addition of tens    
        mov al, ah ; carry is in ah
        mov ah, 00h
        add al, first_num_tens
        add al, second_num_tens
        aaa 

        ; converting to character
        add ax, 3030h
        mov answer_tens, al
        mov answer_carry, ah

        ; printing answer
        ; sum prompt
        lea dx, sum
        mov ah, 09h
        int 21h

        mov dl, first_num_tens
        mov ah, 02h 
        int 21h

        mov dl, first_num_ones
        mov ah, 02h 
        int 21h

        lea dx, and_
        mov ah, 09h
        int 21h

        mov dl, second_num_tens
        mov ah, 02h 
        int 21h

        mov dl, second_num_ones
        mov ah, 02h 
        int 21h

        lea dx, is
        mov ah, 09h
        int 21h

        ; print carry
        mov dl, answer_carry
        mov ah, 02h 
        int 21h 

        ; print tens
        mov dl, answer_tens
        mov ah, 02h 
        int 21h 

        ; print ones
        mov dl, answer_ones
        mov ah, 02h 
        int 21h 

        ; converting to character
        add ax, 3030h
        mov answer_tens, al
        mov answer_carry, ah
        jmp @terminate

        @compare_tens:
        mov bh, expression[1]
        mov first_num_tens, bh
        xor bx, bx

        mov bl, expression[2]
        mov first_num_ones, bl
        xor bx, bx

        mov bh, expression[4]
        mov second_num_tens, bh
        xor bx, bx

        mov bl, expression[5]
        mov second_num_ones, bl
        xor bx, bx

        mov bl, second_num_tens
        cmp first_num_tens, bl
        mov bl, 00h

        jg @normal_subtraction
        jl @reverse_subtraction
        je @compare_ones

        @compare_ones:
        mov bl, second_num_ones
        cmp first_num_ones, bl
        mov bl, 00h
        jge @normal_subtraction
        jl @reverse_subtraction

        @normal_subtraction:
        ; subtracting ones
        mov ax, 00h 
        mov al, first_num_ones
        sub al, second_num_ones
        aas
        mov answer_carry, ah ;carry?
        
        ; converting to character
        add al, 30h
        mov answer_ones, al

        ; subtracting tens
        mov ah, 00h
        mov al, first_num_tens
        sub al, second_num_tens
        aas

        add al, answer_carry
        add al, 30h
        mov answer_tens, al 

        ; difference prompt
        lea dx, difference
        mov ah, 09h
        int 21h

        mov dl, first_num_tens
        mov ah, 02h 
        int 21h

        mov dl, first_num_ones
        mov ah, 02h 
        int 21h

        lea dx, and_
        mov ah, 09h
        int 21h

        mov dl, second_num_tens
        mov ah, 02h 
        int 21h

        mov dl, second_num_ones
        mov ah, 02h 
        int 21h

        lea dx, is
        mov ah, 09h
        int 21h

        ; print tens
        mov dl, answer_tens
        mov ah, 02h 
        int 21h 

        ; print ones
        mov dl, answer_ones
        mov ah, 02h 
        int 21h 
        jmp @terminate

        @reverse_subtraction:
        xor bx, bx

        mov bh, expression[1]
        mov second_num_tens, bh
        xor bx, bx

        mov bl, expression[2]
        mov second_num_ones, bl
        xor bx, bx

        mov bh, expression[4]
        mov first_num_tens, bh
        xor bx, bx

        mov bl, expression[5]
        mov first_num_ones, bl
        xor bx, bx

        ; subtracting ones
        mov ax, 00h 
        mov al, first_num_ones
        sub al, second_num_ones
        aas
        mov answer_carry, ah ;carry?
        
        ; converting to character
        add al, 30h
        mov answer_ones, al

        ; subtracting tens
        mov ah, 00h
        mov al, first_num_tens
        sub al, second_num_tens
        aas

        add al, answer_carry
        add al, 30h
        mov answer_tens, al 

        ; difference prompt
        lea dx, difference
        mov ah, 09h
        int 21h

        mov dl, second_num_tens
        mov ah, 02h 
        int 21h

        mov dl, second_num_ones
        mov ah, 02h 
        int 21h

        lea dx, and_
        mov ah, 09h
        int 21h

        mov dl, first_num_tens
        mov ah, 02h 
        int 21h

        mov dl, first_num_ones
        mov ah, 02h 
        int 21h

        lea dx, is
        mov ah, 09h
        int 21h

        .if answer_tens != 0
        ; print negative sign
        mov dl, 45
        mov ah, 02h 
        int 21h 
        .endif

        ; print tens
        mov dl, answer_tens
        mov ah, 02h 
        int 21h 

        ; print ones
        mov dl, answer_ones
        mov ah, 02h 
        int 21h 
        jmp @terminate

        @perform_multiplication:
        mov bh, expression[1]
        mov first_num_tens, bh
        xor bx, bx

        mov bl, expression[2]
        mov first_num_ones, bl
        xor bx, bx

        mov bh, expression[4]
        mov second_num_tens, bh
        xor bx, bx

        mov bl, expression[5]
        mov second_num_ones, bl
        xor bx, bx

        ; product prompt
        lea dx, product
        mov ah, 09h
        int 21h

        mov dl, first_num_tens
        mov ah, 02h 
        int 21h

        mov dl, first_num_ones
        mov ah, 02h 
        int 21h

        lea dx, and_
        mov ah, 09h
        int 21h

        mov dl, second_num_tens
        mov ah, 02h 
        int 21h

        mov dl, second_num_ones
        mov ah, 02h 
        int 21h

        lea dx, is
        mov ah, 09h
        int 21h

        mov al, first_num_tens
        sub al, 30h ; character to decimal 
        mov bl, 0Ah
        mul bl ; multiply al with 10

        mov first_number, al ; first_number now stores the tens (i.e. if you entered 8 it's now 80)
     
        xor al, al
        mov al, first_num_ones
        sub al, 30h ; character to decimal 
    
        add first_number, al ; now your two-digit number is completely in mynumber1

        mov al, second_num_tens
        sub al, 30h ; character to decimal 
        mov bl, 0Ah
        mul bl ; multiply al with 10

        mov second_number, al ; first_number now stores the tens (i.e. if you entered 8 it's now 80)
     
        xor al, al
        mov al, second_num_ones
        sub al, 30h ; character to decimal 
    
        add second_number, al ; now your two-digit number is completely in mynumber1

        ; multiplying both digits
        mov al, first_number
        mov bl, second_number
        mul bl

        .if first_num_tens == 0
        xor ah,ah
        xor dx,dx
        mov bx,000Ah
        div bx
        call printdig

        ;remainder from last div still in dx
        mov al, dl
        mov dl, al  
        add dl,30h 
        mov ah,02h
        int 21h

        .elseif second_num_tens == 0
        xor ah,ah
        xor dx,dx
        mov bx,000Ah
        div bx
        call printdig

        ;remainder from last div still in dx
        mov al, dl
        mov dl, al  
        add dl,30h 
        mov ah,02h
        int 21h

        .else 
        ; printing 4 digits
        xor dx, dx
        mov bx, 03E8h ; 1000
        div bx
        call printdig ; dx contains remainder (in character form)

        mov ax,dx 
        xor dx,dx
        mov bx, 0064h
        div bx
        call printdig

        mov ax,dx
        xor dx,dx
        mov bx,000Ah
        div bx
        call printdig

        ;remainder from last div still in dx
        mov al, dl
        mov dl, al  
        add dl,30h 
        mov ah,02h
        int 21h
        .endif

        jmp @terminate

        @perform_division:
        ; quotient prompt
        lea dx, quotient
        mov ah, 09h
        int 21h

        mov bh, expression[1]
        mov first_num_tens, bh
        xor bx, bx

        mov bl, expression[2]
        mov first_num_ones, bl
        xor bx, bx

        mov bh, expression[4]
        mov second_num_tens, bh
        xor bx, bx

        mov bl, expression[5]
        mov second_num_ones, bl
        xor bx, bx

        mov al, first_num_tens
        sub al, 30h ; character to decimal 
        mov bl, 0Ah
        mul bl ; multiply al with 10

        mov first_number, al ; first_number now stores the tens (i.e. if you entered 8 it's now 80)
     
        xor al, al
        mov al, first_num_ones
        sub al, 30h ; character to decimal 
    
        add first_number, al ; now your two-digit number is completely in mynumber1

        mov al, second_num_tens
        sub al, 30h ; character to decimal 
        mov bl, 0Ah
        mul bl ; multiply al with 10

        mov second_number, al ; first_number now stores the tens (i.e. if you entered 8 it's now 80)
     
        xor al, al
        mov al, second_num_ones
        sub al, 30h ; character to decimal 
    
        add second_number, al ; now your two-digit number is completely in mynumber1

        ; dividing both digits
        mov al, first_number
        mov bl, second_number
        div bl
        ; answer is in al
        jmp @compare_tens1
       
        @compare_tens1:
        mov bh, expression[1]
        mov first_num_tens, bh
        xor bx, bx

        mov bl, expression[2]
        mov first_num_ones, bl
        xor bx, bx

        mov bh, expression[4]
        mov second_num_tens, bh
        xor bx, bx

        mov bl, expression[5]
        mov second_num_ones, bl
        xor bx, bx

        mov bl, second_num_tens
        cmp first_num_tens, bl
        mov bl, 00h

        jg @divison
        jl @answer_remainder
        je @compare_ones1

        @compare_ones1:
        mov bl, second_num_ones
        cmp first_num_ones, bl
        mov bl, 00h
        jge @divison
        jl @answer_remainder

        @divison:
        mov answer_remainder, ah

        xor ah, ah
        xor dx, dx
        mov bx, 000Ah
        div bx
        call printdig
       
        ;remainder from last div still in dx
        mov al, dl
        mov dl, al  
        add dl,30h 
        mov ah,02h
        int 21h

        ; remainder prompt
        lea dx, remainder
        mov ah, 09h
        int 21h

        mov dl, answer_remainder
        add dl, 48
        mov ah, 02
        int 21h
     
        jmp @terminate

        @answer_remainder:
        ; printing quotient
        mov dl, '0'
        mov ah, 02h 
        int 21h

        ; remainder prompt
        lea dx, remainder
        mov ah, 09h
        int 21h

        ; printing remainder
        mov dl, first_num_tens
        mov ah, 02
        int 21h

        mov dl, first_num_ones
        mov ah, 02
        int 21h

        jmp @terminate

        @terminate:
        mov ax, 4c00h
        int 21h

    main endp
end main

