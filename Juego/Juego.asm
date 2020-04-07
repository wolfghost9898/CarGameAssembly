;##################### MUESRTA EL FONDO Y LOS DATOS ########################
printCalle macro
    LOCAl ejeX,finX,ejeY,finY
    mov ax,13h
    int 10h
    printCadena 0,1,usuario +2
    

    mov cx,20d 
    mov ah,0ch
    mov al,7
    
    ejeX: 
        cmp cx,300
        jg finX
        
        mov dx,20d
        ejeY: 
            cmp dx,180d
            jg finY 
            
            int 10h
            inc dx 
            jmp ejeY
        finY:
        


        inc cx 
        jmp ejeX
    finX: 


    ingresarCaracter
    mov ax,3h
    int 10h
endm
;##################################### MUESTRA UNA CADENA EN LA PANTALLA ##############
printCadena macro column,row,cadena
    LOCAL recursividad,fin
    xor bx,bx 
    xor ax,ax 
    mov al,column
    
    recursividad: 
        mov cl,[cadena + bx]
        cmp cl,'$'
        je fin
        push bx 
        push ax 
        
        printCaracter al,row,cl

        pop ax
        pop bx
        inc bx
        inc ax 
        jmp recursividad    

    fin: 


endm
;###################################### MUESTRA UN CARACTER EN CIERTA POSICION ##########
printCaracter macro column,row,caracter
    mov  dl, column   ;Column
    mov  dh, row   ;Row
    mov  bh, 0    ;Display page
    mov  ah, 02h  ;SetCursorPosition
    int  10h

    mov  al, caracter
    mov  bl, 15d  ;Color is red
    mov  bh, 0    ;Display page
    mov  ah, 0Eh  ;Teletype
    int  10h
    endm