;##################### VERIFICA QUE EL USUARIO NO EXISTA YA ###################
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
        push bx
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

;#################### VALIDAR QUE LA CONTRSENA SEA SOLO NUMERICA ############
validarPassword macro password
    LOCAL recursividad,fin,salto,error
    xor bx,bx

    recursividad:
        mov cl,[password + bx]
        cmp cl,36 
        je salto 

        cmp cl,'0'
        jl error

        cmp cl,'9'
        jg error 

        inc bx 
        jmp recursividad

    salto: 
        mov bx,0d 
        jmp fin
    
    error: 
        mov bx,1d 
        
    fin:

endm
;#################### VALIDAR QUE LA CONTRSENA COINCIDA ############
confirmarContra macro password
    LOCAL recursividad,salto,comparar,fin,siguiente,salto2
    xor bx,bx 
    xor ax,ax
    pop bx 
    push bx
    inc bx
    recursividad:
        cmp bx,fileSize 
        jge salto 

        push bx 
        mov bx,ax 
        mov cl,[password  + bx]
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
        cmp [buffer + bx],10
        jne siguiente 
        
        cmp cl,36
        jne siguiente
        
        pop bx
        mov bx,1d 
        jmp fin

    siguiente: 
        cmp bx,fileSize
        jge salto 

        
        cmp [buffer + bx],59d 
        je salto2

        inc bx 
        jmp siguiente




    salto2:
        inc bx 
        mov ax,0
        jmp recursividad


    fin: 
endm