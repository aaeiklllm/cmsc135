; CMSC 135 Laboratory Sprint #2 (Task 3)
; Layug, Mikaella Louise D.
; Trani, Giancarlo Gabriel T.

.model small
.stack 100h
.data
    message_enterRows db 13, 10, "Enter number of rows: ", "$"
    message_error db 13, 10, "Enter a number between 01 to 20 only.", "$"
    newline db 13, 10, "$"
    input_tens db ?
    input_ones dw ?
    rows dw ?

.code
    main proc near

        ; initializing data
        mov ax, @data
        mov ds, ax

        ; display msg
        lea dx, message_enterRows
        mov ah, 09h
        int 21h

        ; get tens
        mov ah, 01h
        int 21h
        mov input_tens, al

        ; get ones
        mov ah, 01h
        int 21h
        
        xor ah, ah              ; clear
        mov input_ones, ax

        ; sub 048 from digits
        mov ah, 09h
        sub input_ones, 048
        sub input_tens, 048

        mov al, input_tens
        mov bl, 10
        mul bl

        mov rows, ax
        mov bx, input_ones
        add rows, bx

        cmp rows, 20d       ; check if greater than 20
        jle @cont           ; continue if less than 20
        jg @displayError    ; display error and terminate 

        @cont:
            lea dx, newline
            mov ah, 09h
            int 21h

            mov bx, 1           ; count to increment rows
            mov cx, rows        
            
            @l1:
                push cx         ; push to store number of rows
                mov cx, bx
    
            @l2:
                mov ah, 02h     
                mov dl, '*'     ; print asterisk
                int 21h     
            
                loop @l2

                lea dx, newline
                mov ah, 09h
                int 21h

                inc bx      ; increment counter
                pop cx
            
                loop @l1
                jmp @end_condition
        
        @displayError:
            mov ah, 09h
            lea dx, message_error
            int 21h

        @end_condition:
            mov ax, 4c00h
            int 21h
            
        main endp
    end main