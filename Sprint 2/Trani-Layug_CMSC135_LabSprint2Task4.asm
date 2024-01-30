; CMSC 135 Laboratory Sprint #2 (Task 4)
; Layug, Mikaella Louise D.
; Trani, Giancarlo Gabriel T.

.model small
.stack 100h
.data
    message_num1 db 13, 10, "Enter first number: ", "$"
    message_num2 db 13, 10, "Enter second number: ", "$"
    message_gcf db 13, 10, "The greatest common factor of ", "$"
    message_and db  " and ", "$"
    message_is db " is ", "$"
    message_period db ".", "$"
    
    input_first_hundreds db ?
    input_first_tens dw ?
    input_first_ones dw ?

    disp_first_hundreds db ?
    disp_first_tens dw ?
    disp_first_ones dw ?

    input_second_hundreds db ?
    input_second_tens dw ?
    input_second_ones dw ?

    disp_second_hundreds db ?
    disp_second_tens dw ?
    disp_second_ones dw ?

    num_1 dw ?
    num_2 dw ?
    gcf dw ?

.code
    main proc near
        mov ax, @data
        mov ds, ax

        ; display message (enter first number)
        lea dx, message_num1
        mov ah, 09h
        int 21h

        ; get hundreds
        mov ah, 01h
        int 21h
        mov input_first_hundreds, al
        mov disp_first_hundreds, al

        ; get tens
        mov ah, 01h
        int 21h
        xor ah, ah              ; clear
        mov input_first_tens, ax
        mov disp_first_tens, ax

        ; get ones
        mov ah, 01h
        int 21h
        xor ah, ah              ; clear
        mov input_first_ones, ax
        mov disp_first_ones, ax

        mov ah, 09h
        sub input_first_hundreds, 048         ; sub 048 from digits
        sub input_first_tens, 048
        sub input_first_ones, 048

        mov al, input_first_hundreds
        mov bl, 10
        mul bl

        mov num_1, ax
        mov bx, input_first_tens
        add num_1, bx

        mov al, 10        
        mov bx, num_1      
        mul bx            
        mov num_1, ax      

        mov bx, input_first_ones
        add num_1, bx
        
        ; display message (enter second number)
        lea dx, message_num2
        mov ah, 09h
        int 21h

        ; get hundreds
        mov ah, 01h
        int 21h
        mov input_second_hundreds, al
        mov disp_second_hundreds, al

        ; get tens
        mov ah, 01h
        int 21h
        xor ah, ah              ; clear
        mov input_second_tens, ax
        mov disp_second_tens, ax

        ; get ones
        mov ah, 01h
        int 21h
        xor ah, ah              ; clear
        mov input_second_ones, ax
        mov disp_second_ones, ax

        ; sub 048 from digits
        mov ah, 09h
        sub input_second_hundreds, 048         
        sub input_second_tens, 048
        sub input_second_ones, 048

        mov al, input_second_hundreds
        mov bl, 10
        mul bl

        mov num_2, ax
        mov bx, input_second_tens
        add num_2, bx

        mov al, 10        
        mov bx, num_2      
        mul bx            
        mov num_2, ax      

        mov bx, input_second_ones
        add num_2, bx

        mov ax, num_1
        mov bx, num_2

        l1:
            cmp ax, bx      ; compare the two numbers  
            je exit         ; if equal, return any of the two same numbers
            xchg ax, bx     ; else, exchange values 
            jmp l2         

        l2: 
            mov dx, 0       ; initialize dx with zero
            div bx          ; div ax with bx, remainder in dx, quotient in ax
            cmp dx, 0       ; check remainder if zero
            je exit         ; exit if remainder is zero

            ; if remainder not yet zero, move to ax and repeat the process
            mov ax, dx
            jmp l1          

        exit:
            mov gcf, bx
            
            ; DISPLAYING MESSAGE
            lea dx, message_gcf
            mov ah, 09h
            int 21h

            ; DISPLAYING MESSAGE (FIRST HUNDREDS)
            mov ah, 02h
            mov dl, disp_first_hundreds
            int 21h

            ; DISPLAYING MESSAGE (FIRST TENS)
            mov ah, 02h
            mov dx, disp_first_tens
            int 21h

            ; DISPLAYING MESSAGE (FIRST ONES)
            mov ah, 02h
            mov dx, disp_first_ones
            int 21h

            ; DISPLAYING MESSAGE
            lea dx, message_and
            mov ah, 09h
            int 21h

            ; DISPLAYING MESSAGE (FIRST HUNDREDS)
            mov ah, 02h
            mov dl, disp_second_hundreds
            int 21h

            ; DISPLAYING MESSAGE (FIRST TENS)
            mov ah, 02h
            mov dx, disp_second_tens
            int 21h

            ; DISPLAYING MESSAGE (FIRST ONES)
            mov ah, 02h
            mov dx, disp_second_ones
            int 21h
        
            ; DISPLAYING MESSAGE
            lea dx, message_is
            mov ah, 09h
            int 21h

            call print

            ; DISPLAYING MESSAGE
            lea dx, message_period
            mov ah, 09h
            int 21h

            ; return to ms-dos
            mov ax, 4c00h
            int 21h

    print proc          
        mov ax, gcf
        mov cx, 0
        mov dx, 0

        label1:
            cmp ax, 0       ; check if ax is 0
            je print1     
            
            mov bx, 10      ; initialize bx to 10
            
            div bx                 
            push dx         ; push remainder to stack           
            
            inc cx          ; increment count  
            
            xor dx, dx      ; clear dx
            jmp label1

        print1:
            cmp cx, 0       ; check if count is greater than 0
            je ext
            
            pop dx          ; pop stack
            add dx, 48      ; convert to ASCII
            
            mov ah, 02h     ; print char
            int 21h
            
            dec cx          ; decrease count
            jmp print1

        ext:                    ; exit
            ret
    print endp
    main endp
    end main