buscarUsuario macro usuario
    LOCAL recursividad,salto,comparar,fin,siguiente,salto2
    xor bx,bx 
    xor ax,ax

    recursividad:
        cmp bx,fileSize 
        jge salto 

        push bx 
        mov bx,ax 
        mov cl,[usuario  + bx]
        pop bx 
        
        cmp [buffer + bx],cl 
        jne comparar 

        inc ax

        inc bx
        jmp recursividad
        
    salto:
        mov bx,0d 
        jmp fin 
    
    comparar:
        cmp [buffer + bx],59d
        jne siguiente 
        
        cmp cl,36
        jne siguiente

        mov bx,1d 
        jmp fin

    siguiente: 
        cmp bx,fileSize
        jge salto 

        
        cmp [buffer + bx],10 
        je salto2

        inc bx 
        jmp siguiente




    salto2:
        inc bx 
        mov ax,0
        jmp recursividad


    fin:

endm