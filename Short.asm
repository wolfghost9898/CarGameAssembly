

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
    
    push bx 
    xor bx,bx
    mov bl,cantidadRegistros 
    mov [arregloTemp + bx],al
    pop bx
    
    
    
    inc bx 
    mov [arreglo + bx],al 
    inc cantidadRegistros

    pop bx
endm

;Graficamos el arreglo en su estado actual 
graficarArreglo macro tiempo
    LOCAL recursividad,fin

    push bx 
    push ax
    push cx
    push dx 

    xor bx,bx 
    xor ax,ax 
    xor cx,cx 
    xor dx,dx 

    cmp cantidadRegistros,0d 
    jle fin                     ; Si no hay datos no graficamos

    mov valorMayor,0d
    mov posicionGrafica,30d
    mov ax,5d 
    mul cantidadRegistros
    mov cantidadEspacios,ax     ; Obtenemos el espacio libre
        
    xor bx,bx
    mov ax,260d 
    sub ax,cantidadEspacios     ; Obtenemos el espacio para graficar
    mov bl,cantidadRegistros 
    div bx                      ; Obtenemos el espacio que ocupara cada grafica

    mov espacioGrafica,ax 
    buscarValorMayor            ; El maximo valor a graficar
    xor ax,ax 
    mov al,cantidadRegistros 
    xor bx,bx
    recursividad:
        cmp bx,ax
        jge fin
        push ax
        xor cx,cx 
        mov cl,[arregloTemp + bx]   ;Obtenemos el valor
        mov temporal2,cl
        
        configurarGrafica cx    ; Que color sera la grafica 

        cambiarEscala cx        ; El valor corregido para graficar
        mov cx,ax
        pop ax        
        
        posicionNumero posicionGrafica
        graficarRectangulo cx,colorGrafica
        
        printNumero temporal2,temporal,22d
        
        add posicionGrafica,5d
        delay tiempo
        inc bx 
        jmp recursividad
    fin:

    pop dx
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
    xor bx,bx 
    recursividad:
        cmp bx,ax 
        jge fin 
         
        xor cx,cx 
        mov cl,[arregloTemp + bx]
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

;Mueve el numero abajo de la grafica, y lo pone al inicio de ella
posicionNumero macro numero
    push ax 
    push bx 
    push dx 
    push cx

    mov ax,numero 
    mov bx,3d
    mul bx 
    mov bx,26d 
    div bx 
    add al,2d
    mov temporal,al

    pop cx
    pop dx
    pop bx 
    pop ax
endm

;Ordenamiento por quickSort 
ordenamientoQuickSort macro primero,ultimo
    LOCAL fin
    push ax 
    push bx 
    push cx 
    push dx

    mov ax,primero 
    mov bx,ultimo

    mov first,ax
    mov last,bx

    call ordenamientoQuick
    
    pop dx 
    pop cx 
    pop bx 
    pop ax
   
endm

;Hace el movimiento en quicksort
partition macro arreglo,primero,ultimo
    LOCAL recursividad,fin,salto
    push ax
    push bx 
    push cx 
    push dx 

    mov bx,ultimo 
    mov cl,[arreglo + bx]
    mov pivote,cl

    mov ax,primero 
    dec ax 
    mov i,ax

    

    mov cx,primero
    
    recursividad: 
        cmp cx,ultimo 
        jge fin

        mov bx,cx 
        mov al,[arreglo + bx]
        
        cmp al,pivote
        jge salto                       ;De menor a mayor
        
        inc i
        mov bx,i
        mov ah,[arreglo + bx]
        mov [arreglo + bx],al
        mov bx,cx 
        mov [arreglo + bx],ah   

        salto:
        inc cx 
        jmp recursividad 


    fin:
        mov bx,i 
        inc bx 
        mov al,[arreglo + bx]
        mov bx,ultimo 
        mov ah,[arreglo + bx]
        mov bx,i 
        inc bx 
        mov [arreglo + bx],ah
        mov bx,ultimo 
        mov [arreglo + bx],al
    mov bx,i 
    inc bx 
    mov temp2,bx

    graficarPaso
    pop dx 
    pop cx 
    pop bx 
    pop ax
endm

;Grafica cada paso del ordenamiento
graficarPaso macro
    push ax 
    push bx 
    push cx 
    push dx 

    xor ax,ax 
    xor bx,bx 
    xor cx,cx
    xor cx,cx
    modoVideo 
    graficarArreglo 500d
    modoConsola


    pop dx 
    pop cx 
    pop bx
    pop ax
endm


;Ordenamiento por bubblesort 
ordenamientoBubbleSort macro  
    LOCAL recursividad,fin,recursividadY,finY,salto
    
    xor ax,ax
    mov al,cantidadRegistros 
    dec ax 
    mov temporal3,ax
    xor cx,cx
    
    recursividad:

        cmp cx,temporal3 
        jge fin 

        mov ax,temporal3
        sub ax,cx
        mov contador,ax 
        
        xor ax,ax 
        recursividadY:
            cmp ax,contador 
            jge finY 
            
            mov bx,ax 
            mov dl,[arregloTemp + bx] ;Arreglo[j]
            inc bx 
            mov dh,[arregloTemp + bx] ;Arreglo[j + 1]

            cmp dl,dh 
            jle salto

                dec bx 
                mov [arregloTemp + bx],dh    ; asignamos a arreglo[j] = arreglo[j+1]
                inc bx 
                mov [arregloTemp + bx],dl    ; asignamos arreglo[j + 1] = arreglo[j]
            
            salto:
            graficarPaso
            inc ax 
            jmp recursividadY


        finY:


       


        inc cx
        jmp recursividad

    fin:

  
endm



