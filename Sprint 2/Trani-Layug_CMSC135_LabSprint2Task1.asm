; Giancarlo Gabriel Trani
; Mikaella Louise Layug

.model small
.data
    enter_string db 13, 10, "Enter string: ", "$"
    transformed_string db 13, 10, "Transformed string: ", "$"
    newline db 13, 10, "$" 
    inputted_string db 12, ?, 12 dup("$")

.stack 100h    
.code

    main proc near
        mov ax, @data
        mov ds, ax
        
       ; enter string prompt
        lea dx, enter_string
        mov ah, 09h
        int 21h

        ; getting a string
        mov ah, 0ah
        lea dx, inputted_string
        int 21h

        ; enter string prompt
        lea dx, transformed_string
        mov ah, 09h
        int 21h

        ; setting up si and bx
        mov si, 0h ; clearing si 
        lea bx, [inputted_string + 2] ; the string we inputted

        @iterate:
        mov cl, [bx+si] 
        cmp cl, '$' ; checking if end of string
        je @terminate ; if end, terminate loop

        cmp cl, 90
        jle @check_if_uppercase
        jg @check_if_lowercase

        @check_if_uppercase:
        cmp cl, 65
        jge @make_lowercase
        jl @print_character

        @check_if_lowercase:
        cmp cl, 97
        jge @check_if_lowercase_ii
        jl @print_character

        @check_if_lowercase_ii:
        cmp cl, 122
        jle @make_uppercase
        jg @print_character

        

        @make_uppercase:
        sub cl, 32 
        mov dl, cl
        mov ah, 02h
        int 21h
        jmp @increment

        @make_lowercase:
        add cl, 32
        mov dl, cl
        mov ah, 02h
        int 21h
        jmp @increment

        @print_character:
        mov dl, cl
        mov ah, 02h
        int 21h
        jmp @increment

        @increment:
        ; if not end of string, increment si & repeat loop
        inc si 
        jmp @iterate

        @terminate:
        mov ax, 4c00h
        int 21h

    main endp
end main

