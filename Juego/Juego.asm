modoVideo macro 
    mov ah,00h
    mov al,13h
    int 10h
    mov ax, 0A000h
    mov es, ax

endm


;##################### MUESRTA EL FONDO Y LOS DATOS ########################
printCalle macro
    LOCAl ejeX,finX,ejeY,finY
    
    ;printCadena 0,1,usuario +2
    

    mov cx,20d 
    
    
    ejeX: 
        cmp cx,300
        jg finX
        
        mov dx,20d
        ejeY: 
            cmp dx,180d
            jg finY 
            
            pintar cx,dx,7
            
            inc dx 
            jmp ejeY
        finY:
        


        inc cx 
        jmp ejeX
    finX: 


    
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

;#################################### PINTA EL CARRO ###############################
printCarro macro
    LOCAL recursividadY,finY,recursividad,fin 
    
    mov dx,150d
    recursividadY:
        cmp dx,180d 
        jg finY

        mov bx,carroI 
        recursividad:
            cmp bx,carroF
            jg fin 

            pintar bx,dx,5

            inc bx 
            jmp recursividad


        fin:


        inc dx 
        jmp recursividadY

    finY:

endm

;############################ MUEVE EL CARRO HACIA LA IZQUIERDA ####################
moverIzquierda macro
    LOCAL salir 
    mov cx,carroI 
    cmp cx,20d 
    jle salir

    sub carroI,10d 
    sub carroF,10d


    salir:
endm

;############################ MUEVE EL CARRO HACIA LA DERECHA ####################
moverDerecha macro
    LOCAL salir 
    mov cx,carroF 
    cmp cx,300d
    jge salir

    add carroI,10d 
    add carroF,10d


    salir:
endm

;############################ PAUSAR EL CODIGO ##################################
delay macro tiempo 
    LOCAL D1,D2,fin
    push si 
    push di 

    mov si,tiempo 
    D1:
        dec si 
        jz fin 
        mov di,tiempo 
    D2:
        dec di
        jnz D2 
        jmp D1 
    fin: 
        pop di 
        pop si

endm

;########################## OBTENEMOS LA POSICION PARA VIDEO ####################
pintar macro posX,posY,color
    push ax 
    push bx 
    push cx 
    push dx

    mov ax,posY
    mov bx,posX
    mov cx,320
    mul cx
    add ax,bx 
    mov di,ax 
    mov dl,color

    mov es:[di],dl

    pop dx
    pop cx 
    pop bx
    pop ax
endm


;########################## PRINT DE UN OBJETO ####################
printObjeto macro posX,posY,color,color2
    push ax 
    push bx 

    
    mov ax,posY 
    mov bx,posX
    dibujarCuadrado color
    sub ax,5d
    sub bx,5d
    dibujarCuadrado color
    add bx,5d 
    dibujarCuadrado color2
    add bx,5d 
    dibujarCuadrado color 
    
    sub ax,5d
    sub bx,15d 
    dibujarCuadrado color
    add bx,5d
    dibujarCuadrado color2
    add bx,5d
    dibujarCuadrado color2
    add bx,5d
    dibujarCuadrado color2
    add bx,5d
    dibujarCuadrado color

    sub ax,5d
    sub bx,15d 
    dibujarCuadrado color
    add bx,5d
    dibujarCuadrado color2
    add bx,5d
    dibujarCuadrado color

    sub ax,5d
    sub bx,5d
    dibujarCuadrado color

    pop bx
    pop ax
endm


;########################## DIBUJAR CUADRADO ####################
dibujarCuadrado macro color
    LOCAL recursividad,fin,recursividadY,finY 
    push ax 
    push bx 
    push cx 
    push dx 

    
    mov cx,4d
    add cx,bx
    
    recursividad:
        cmp bx,cx 
        jg fin

        
        push ax
        
        mov dx,4d
        add dx,ax

        recursividadY:
            cmp ax,dx 
            jg finY 

            pintar bx,ax,color

            inc ax 
            jmp recursividadY

        finY:
        pop ax
        inc bx 
        jmp recursividad

    fin:

    pop dx
    pop cx
    pop bx 
    pop ax
endm
