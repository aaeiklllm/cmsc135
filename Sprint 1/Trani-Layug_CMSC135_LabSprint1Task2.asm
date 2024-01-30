; CMSC 135 Laboratory Sprint #1 (Task 2)
; Layug, Mikaella Louise D.
; Trani, Giancarlo Gabriel T.

.model small
.data
    message_num1 db 13, 10, "Enter first number: ", "$"
    message_num2 db 13, 10, "Enter second number: ", "$"
    message_sum db 13, 10, "The sum of ", "$"
    message_difference db 13, 10, "The difference of ", "$"
    message_and db  " and ", "$"
    message_is db " is ", "$"
    message_period db ".", "$"
    newline db 13, 10, "$"

    input_first_ones db ?
    input_first_tens db ?
    input_second_ones db ?
    input_second_tens db ?
    input2_first_ones db ?
    input2_first_tens db ?
    input2_second_ones db ?
    input2_second_tens db ?

.stack 100h
.code
    main proc near
        mov ax, @data
        mov ds, ax

        ; display message (enter second number)
        lea dx, message_num1
        mov ah, 09h
        int 21h

        ; get tens
        mov ah, 01h
        int 21h
        mov bh, al
        mov input_first_tens, al

        ; get ones
        mov ah, 01h
        int 21h
        mov bl, al
        mov input_first_ones, al
        
        ; display message (enter second number)
        lea dx, message_num2
        mov ah, 09h
        int 21h

        ; get tens
        mov ah, 01h
        int 21h
        mov ch, al
        mov input_second_tens, al
        
        ; get ones
        mov ah, 01h
        int 21h
        mov cl, al
        mov input_second_ones, al

        ; new line
        lea dx, newline
        mov ah, 09h
        int 21h

        ; ADDITION
        ; addition of ones 
        mov al, input_first_ones
        mov ah, 00h  
        add al, input_second_ones
        aaa

        ; converting to ascii code
        add ax, 3030h 
        mov input_first_ones, al
        
        ; addition of tens
        ; carry is in ah
        mov al, ah
        mov ah, 00h
        add al, input_first_tens
        add al, input_second_tens
        aaa 

        ; converting to ascii code
        add ax, 3030h
        mov input_first_tens, al
        mov input_second_ones, ah

        ; DISPLAYING MESSAGE (SUM)
        lea dx, message_sum
        mov ah, 09h
        int 21h

        ; DISPLAYING MESSAGE (FIRST TENS)
        mov ah, 02h
        mov dl, bh
        int 21h

        ; DISPLAYING MESSAGE (FIRST ONES)
        mov ah, 02h
        mov dl, bl
        int 21h

        ; DISPLAYING MESSAGE (AND)
        lea dx, message_and
        mov ah, 09h
        int 21h

        ; DISPLAYING MESSAGE (SECOND TENS)
        mov ah, 02h
        mov dl, ch
        int 21h

        ; DISPLAYING MESSAGE (SECOND ONES)
        mov ah, 02h
        mov dl, cl
        int 21h

        ; DISPLAYING MESSAGE (IS)
        lea dx, message_is
        mov ah, 09h
        int 21h

        ; print carry
        mov dl, input_second_ones
        mov ah, 02h 
        int 21h 

        ; print next digit
        mov dl, input_first_tens
        mov ah, 02h 
        int 21h 

        ; print last digit
        mov dl, input_first_ones
        mov ah, 02h 
        int 21h 

        ; DISPLAYING MESSAGE (.)
        lea dx, message_period
        mov ah, 09h
        int 21h


        ; DISPLAY MESSAGE (DIFFERENCE)
        lea dx, message_difference
        mov ah, 09h
        int 21h

        ; DISPLAYING MESSAGE (FIRST TENS)
        mov ah, 02h
        mov dl, bh
        int 21h

        ; DISPLAYING MESSAGE (FIRST ONES)
        mov ah, 02h
        mov dl, bl
        int 21h

        ; DISPLAYING MESSAGE (AND)
        lea dx, message_and
        mov ah, 09h
        int 21h

        ; DISPLAYING MESSAGE (SECOND TENS)
        mov ah, 02h
        mov dl, ch
        int 21h

        ; DISPLAYING MESSAGE (SECOND ONES)
        mov ah, 02h
        mov dl, cl
        int 21h

        ; DISPLAYING MESSAGE (IS)
        lea dx, message_is
        mov ah, 09h
        int 21h

        ; SUBTRACTION
        mov al, bl
        mov ah, 00h  ;clear ah before aaa
        sub al, cl
        aas
        mov cl, ah

        ; converting to ascii code
        add al, 30h
        mov bl, al ;store in bl, since al will be used for the addition of higher digits

        mov ah, 00h
        sub bh, ch 
        mov al, bh 
        aas

        add al, cl
        add al, 30h
        mov bh, al ;store higher digit in bh


        ; print first digit
        mov dl, bh
        mov ah, 02h 
        int 21h 

        ; print last digit
        mov dl, bl
        mov ah, 02h 
        int 21h 

        ; DISPLAYING MESSAGE (.)
        lea dx, message_period
        mov ah, 09h
        int 21h

        ; new line
        lea dx, newline
        mov ah, 09h
        int 21h
        
        ; returning to ms dos
        mov ax, 4c00h
        int 21h

        main endp
    end main