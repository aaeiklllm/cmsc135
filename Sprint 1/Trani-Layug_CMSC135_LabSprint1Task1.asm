; CMSC 135 Laboratory Sprint #1
; Layug, Mikaella Louise D.
; Trani, Giancarlo Gabriel T.

.model small
.data
    message_firstc db 13, 10, "Enter first character (x): ", "$"
    message_secondc db 13, 10, "Enter second character (y): ", "$"
    message_newx db 13, 10, "The new value of x is ", "$"
    message_newy db 13, 10, "The new value of y is ", "$"
    character_x db ?
    character_y db ?
    temp db ?
    newline db 13, 10, "$"


.stack 100h
.code
    main proc near
        mov ax, @data
        mov ds, ax

        ; display msg
        lea dx, message_firstc
        mov ah, 09h
        int 21h

        ; get char x
        mov ah, 01h 
        int 21h

        ; move x to variable character_x
        mov character_x, al

        ; display msg
        lea dx, message_secondc
        mov ah, 09h
        int 21h

        ; get char y
        mov ah, 01h 
        int 21h

        ; move y to variable character_y
        mov character_y, al

        ; print new line
        lea dx, newline
        mov ah, 09h
        int 21h

        ; move value of x to temp
        mov al, character_x ; dest, src
        mov temp, al
        
        ; move value of y to x
        mov bl, character_y 
        mov character_x, bl

        ; move value of temp to y
        mov al, temp 
        mov character_y, al

        ; display msg
        lea dx, message_newx
        mov ah, 09h
        int 21h

        ; print character x
        mov ah, 02h
        mov dl, character_x
        int 21h

        ; display msg   
        lea dx, message_newy
        mov ah, 09h
        int 21h

        ; print character y
        mov ah, 02h
        mov dl, character_y
        int 21h

        mov ax, 4c00h
        int 21h

        main endp
    end main