

;Carga los valores de puntaje/tiempo al arreglo, guardando la posicion original 
cargarPuntaje macro
    LOCAL nombre,fin,salto
    mov cantidadRegistros,0d
    mov posicionActual,0d
    push bx 
    push cx 

    xor cx,cx
    xor bx,bx 
    nombre: 
        mov bx,posicionActual
        mov cl,[buffer + bx]
        cmp bx,fileSize 
        jge fin
        cmp cl,59
        je salto                      ;Si llegamos a la primera punto y coma nos saltamos el nombre
        inc posicionActual
        inc bx 
        jmp nombre


    salto:
        inc posicionActual
        getNumber
        guardarArreglo 

        getNumber

        mov bx,posicionActual 
        cmp bx,fileSize 
        jl nombre 
    fin:

    pop cx
    pop bx

endm

;Almacena un valor en el arreglo
guardarArreglo macro
    push bx 
    push ax
    xor bx,bx 
    xor ax,ax 
    mov al,cantidadRegistros
    mov bx,2d 
    mul bx

    mov bx,ax 
    pop ax
    mov cl,cantidadRegistros
    mov [arreglo + bx],cl 
    inc bx 
    mov [arreglo + bx],al 
    inc cantidadRegistros

    pop bx
endm

;Graficamos el arreglo en su estado actual 
graficarArreglo macro
    LOCAL recursividad,fin
    push bx 
    push ax
    push cx
    xor bx,bx 
    
    cmp cantidadRegistros,0d 
    jle fin                     ; Si no hay datos no graficamos

    mov valorMayor,0d
    mov posicionGrafica,30d
    mov ax,5d 
    mul cantidadRegistros
    mov cantidadEspacios,ax     ; Obtenemos el espacio libre
    
    mov ax,260d 
    sub ax,cantidadEspacios     ; Obtenemos el espacio para graficar
    mov bl,cantidadRegistros 
    div bx                      ; Obtenemos el espacio que ocupara cada grafica
    
    mov espacioGrafica,ax 
    buscarValorMayor            ; El maximo valor a graficar
    xor ax,ax 
    mov al,cantidadRegistros 
    mov bx,2d 
    mul bx 
    xor bx,bx
    recursividad:
        cmp bx,ax
        jge fin
        inc bx 
        push ax
        xor cx,cx 
        mov cl,[arreglo + bx]
        
        configurarGrafica cx    ; Que color sera la grafica 

        cambiarEscala cx        ; El valor corregido para graficar
        mov cx,ax
        pop ax        
        
        
        graficarRectangulo cx,colorGrafica
        add posicionGrafica,5d

        inc bx 
        jmp recursividad
    fin:
    pop cx
    pop ax
    pop bx
endm



;Graficamos un rectangulo 
graficarRectangulo macro altura,color
    LOCAL recursividad,fin,recursividadY,finY
    push bx 
    push ax
    push cx
    xor bx,bx 

    recursividad:
        cmp bx,espacioGrafica
        jge fin 

        mov ax,170d
        recursividadY:
            cmp ax,altura 
            jl finY 

            pintar posicionGrafica,ax,color

            dec ax 
            jmp recursividadY

        finY: 
        
        inc posicionGrafica

        inc bx
        jmp recursividad 

    fin:
    pop cx
    pop ax
    pop bx
endm

;Buscamos en el arreglo el valor mayor 
buscarValorMayor macro
    LOCAL recursividad,fin,salto
    push bx
    push ax
    push cx 

    xor ax,ax
    mov al,cantidadRegistros 
    mov bx,2d 
    mul bx 
    xor bx,bx 
    recursividad:
        cmp bx,ax 
        jge fin 
         
        inc bx
        xor cx,cx 
        mov cl,[arreglo + bx]
        cmp cx,valorMayor
        jle salto 

        mov valorMayor,cx
        
        salto: 
        inc bx
        jmp recursividad    
    fin: 

    pop cx
    pop ax 
    pop bx
endm


;Cambiamos el valor a nuestra escala 
cambiarEscala macro numero
    push bx
    mov ax,100
    mov bx,numero
    mul bx
    div valorMayor

    mov temp,ax 
    mov ax,7d 
    mul temp 
    mov temp,5d
    div temp 
    mov temp,ax 
    mov ax,170d 
    sub ax,temp 
    pop bx
endm

;Color de la grafica 
configurarGrafica macro numero   
    LOCAL rojo,fin,azul,amarillo,verde
    cmp numero,20d 
    jle rojo 
    
    cmp numero,40d 
    jle azul 

    cmp numero,60d 
    jle amarillo

    cmp numero,80d 
    jle verde 

    mov colorGrafica,15d 
    jmp fin

    verde: 
        mov colorGrafica,2d 
        jmp fin

    amarillo: 
        mov colorGrafica,14d 
        jmp fin 


    azul: 
        mov colorGrafica,1d 
        jmp fin

    rojo: 
        mov colorGrafica,4d
    
    fin:
endm