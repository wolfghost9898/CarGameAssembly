

;Carga los valores de puntaje al arreglo, guardando la posicion original 
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

;Cargar los valores de tiempo al arreglo,guardando la posicion original 
cargarTiempo macro
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
        xor ax,ax
        getNumber
        guardarArreglo

        
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
    LOCAL recursividad,fin,salto

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
        playSound
        printNumero temporal2,temporal,22d
        
        add posicionGrafica,5d
        
        cmp flagContar,0d
        je salto
        
        cronometroGrafica
        salto:
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
    mov frequencyGraph,1292d 
    jmp fin

    verde: 
        mov colorGrafica,2d
        mov frequencyGraph,1612d  
        jmp fin

    amarillo: 
        mov colorGrafica,14d
        mov frequencyGraph,2280d  
        jmp fin 


    azul: 
        mov colorGrafica,1d
        mov frequencyGraph,3834d  
        jmp fin

    rojo: 
        mov colorGrafica,4d
        mov frequencyGraph,9121d 
    
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
    LOCAL recursividad,fin,salto,ascendente,salto2
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
        
        cmp ordenamiento,1d 
        je ascendente 

        cmp al,pivote
        jle salto                       ;De mayor a menor
        
        jmp salto2
        
        ascendente:
            cmp al,pivote
            jge salto                       ;De menor a mayor
        
        salto2:

        inc i
        mov bx,i
        mov ah,[arreglo + bx]
        mov [arreglo + bx],al
        mov bx,cx 
        mov [arreglo + bx],ah   

        salto:
        graficarPaso
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

    ;graficarPaso
    pop dx 
    pop cx 
    pop bx 
    pop ax
endm

;Grafica cada paso del ordenamiento
graficarPaso macro
    LOCAL salto
    push ax 
    push bx 
    push cx 
    push dx 

    xor ax,ax 
    xor bx,bx 
    xor cx,cx
    xor cx,cx
    modoVideo
    
    graficarArreglo velocidadTiempo
    modoConsola
    
    
    


    pop dx 
    pop cx 
    pop bx
    pop ax
endm


;Ordenamiento por bubblesort 
ordenamientoBubbleSort macro  
    LOCAL recursividad,fin,recursividadY,finY,salto,ascendente,salto2
    
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

            cmp ordenamiento,1d 
            je ascendente

            cmp dl,dh
            jge salto
            jmp salto2
            ascendente:
                cmp dl,dh 
                jle salto
            
            salto2:

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


;Ordenamiento por shellsort 
ordenamientoShellSort macro
    LOCAL recursividad,fin,while,finwhile,for,finfor,salto,ascendente,salto2
    xor ax,ax 
    mov al,cantidadRegistros
    mov temporal3,ax            ;Tamanio del arreglo
    mov bx,2d 
    div bl 
    
    recursividad:
        xor ah,ah 
        cmp ax,0d 
        jle fin 

        mov contador,1d 
        while:
            cmp contador,0d 
            je finwhile

            mov contador,0d
            mov cx,ax             ;La mitad del arreglo(i)
            
            for: 
                cmp cx,temporal3
                jge finfor

                mov bx,cx 
                sub bx,ax 
                mov dl,[arregloTemp + bx]           ; arreglo[i - mitad]
                mov bx,cx 
                mov dh,[arregloTemp  + bx]          ; arreglo[i]

                cmp ordenamiento,1d 
                je ascendente

                cmp dl,dh 
                jge salto 
                jmp salto2

                ascendente:
                cmp dl,dh 
                jle salto 

                salto2:
                mov [arregloTemp  + bx],dl          ; arreglo[i] = arreglo[i - mitad]
                mov bx,cx 
                sub bx,ax 
                mov [arregloTemp + bx],dh           ; arreglo[i - mitad] = arreglo[i]
                
                mov contador,1d
                salto:
                graficarPaso
                inc cx 
                jmp for
            finfor:

            jmp while

        finwhile:

        

        ;graficarPaso
        mov bx,2d 
        div bl 
        jmp recursividad
        
    fin:

endm


;Preguntar que tipo de ordenamiento sera, Ascendente o Descendente 
tipoOrdenamiento macro
    LOCAL ascendente,fin
    clearScreen 
    mostrarCadena msgOrdenamiento 
    ingresarCaracter 
    cmp bl,'1'
    je ascendente 

    mov ordenamiento,0d         ;Descendente 
    jmp fin 

    ascendente:
        mov ordenamiento,1d         ;Ascendente 
    fin:
endm

;Tiempo que tendra el delay para las graficas
controlVelocidad macro
    LOCAL cero,uno,dos,tres,cuatro,cinco,seis,siete,ocho,fin

    cmp bl,'9'
    je cero 

    cmp bl,'8'
    je uno

    cmp bl,'7'
    je dos

    cmp bl,'6'
    je tres

    cmp bl,'5'
    je cuatro

    cmp bl,'4'
    je cinco

    cmp bl,'3'
    je seis

    cmp bl,'2'
    je siete

    cmp bl,'1'
    je ocho
    
    mov [velocidadOrdenamiento + 0],'0'
    mov velocidadTiempo,1100d
    mov auxiliarVelocidad,1d
    jmp fin

    cero:
        mov [velocidadOrdenamiento + 0],'9'
        mov velocidadTiempo,130d
        mov auxiliarVelocidad,12d
        jmp fin 

    uno:
        mov [velocidadOrdenamiento + 0],'8'
        mov velocidadTiempo,260d
        mov auxiliarVelocidad,9d
        jmp fin 
    
    dos:
        mov [velocidadOrdenamiento + 0],'7'
        mov velocidadTiempo,390d
        mov auxiliarVelocidad,6d
        jmp fin
    
    tres:
        mov [velocidadOrdenamiento + 0],'6'
        mov velocidadTiempo,520d
        mov auxiliarVelocidad,3d
        jmp fin
    
    cuatro:
        mov [velocidadOrdenamiento + 0],'5'
        mov velocidadTiempo,650d
        mov auxiliarVelocidad,2d
        jmp fin

    cinco:
        mov [velocidadOrdenamiento + 0],'4'
        mov velocidadTiempo,700d
        mov auxiliarVelocidad,2d
        jmp fin

    seis:
        mov [velocidadOrdenamiento + 0],'3'
        mov velocidadTiempo,710d
        mov auxiliarVelocidad,2d
        jmp fin

    siete:
        mov [velocidadOrdenamiento + 0],'2'
        mov velocidadTiempo,840d
        mov auxiliarVelocidad,1d
        jmp fin

    ocho:
        mov [velocidadOrdenamiento + 0],'1'
        mov velocidadTiempo,970d
        mov auxiliarVelocidad,1d
        jmp fin
    
    
    fin:
endm

;Valida cuanto tiempo ha pasado cuando se grafica la grafica
cronometroGrafica macro
    LOCAL salto,sumar,min 
    push ax 
    push bx 
    push cx 
    push dx 
    
    
    mov bl,contadorVelocidad 
    cmp bl,auxiliarVelocidad
    jl sumar 

    mov contadorVelocidad,0d 
    cmp segundos,60d 
    jge min 

    inc segundos
    jmp salto 

    min: 
        mov segundos,0d 
        inc minutos
    
    jmp salto
    
    sumar: 
        inc contadorVelocidad

    salto:
    printNumero minutos,60,0
    printCaracter 62,0,":"
    printNumero segundos,63,0
    
    pop dx 
    pop cx 
    pop bx
    pop ax
endm

;Muestra una grafica esperando una tecla para continuar
graficaEstatica macro
    mov flagContar,0d
    modoVideo
    
    mostrarNombreOrdenamiento
    printCadena 54,0,msgTiempo
    printNumero minutos,61,0
    printCaracter 63,0,":"
    printNumero segundos,64,0
    printCadena 68,0,msgVelocidadP
    printCadena 78,0,velocidadOrdenamiento

    graficarArreglo 1d
    ingresarCaracter
    modoConsola
endm

;Mostrarmos que tipo de Ordenamiento es
mostrarNombreOrdenamiento macro 
    LOCAL quick,fin,bubble

    cmp tipoOrdenamientoN,0d 
    je quick 

    cmp tipoOrdenamientoN,1d 
    je bubble 

    printCadena 2,0,nombreShellSort
    jmp fin


    quick: 
        printCadena 2,0,nombreQuickSort

    jmp fin
    
    bubble:
        printCadena 2,0,nombreBubbleSort
    
    fin:

endm


;Generar un top 10 
ordenarTop10 macro
    LOCAL recursividad,fin,recursividad2,fin2,salto
    push ax 
    push bx
    push cx
    push dx 

    xor bx,bx 
    xor ax,ax
    xor cx,cx 

    mov al,cantidadRegistros
    mov bx,2d 
    mul bx 
    mov temp,ax
    xor ax,ax
    xor bx,bx
    xor dx,dx
    inc ax
    recursividad:
        cmp ax,temp 
        jge fin

        mov cx,1d
        
        
        recursividad2: 
            cmp cx,temp
            jge fin2 
            mov bx,ax 
            mov dl,[arreglo + bx]
            mov bx,cx 
            mov dh,[arreglo + bx]

            cmp dl,dh
            jle salto

            hacerCambio ax,cx
            
            salto:
            
            add cx,2d
            jmp recursividad2

        fin2:

        add ax,2d 
        jmp recursividad


    fin:


    pop dx
    pop cx
    pop bx 
    pop ax
endm

;Hace el cambio de la posicion actual con la posicion siguiente
hacerCambio macro posicion,posicion2
    push bx 
    push ax 
    push dx 


    mov bx,posicion
    dec bx 
    mov dl,[arreglo + bx]
    mov bx,posicion2
    dec bx 
    mov dh,[arreglo + bx]
    mov bx,posicion 
    dec bx 
    mov [arreglo + bx],dh 
    mov bx,posicion2 
    dec bx 
    mov [arreglo + bx],dl



    pop dx


    mov bx,posicion 
    mov [arreglo + bx],dh 
    mov bx,posicion2
    mov [arreglo + bx],dl

    pop ax 
    pop bx
endm

;Muestra el Top 10 de Puntajes/Tiempo
mostrarTop macro cadena
    LOCAL recursividad,fin
    push ax 
    push bx 
    push cx 

    mostrarEspacios 32d
    mostrarCadena cadena
    mov cx,SIZEOF cadena
    dec cx
    escribirCadenaArchivo cadena,cx
    mostrarCaracter 10d
    escribirCaracterArchivo 10d 

    xor ax,ax 
    recursividad:
        cmp al,cantidadRegistros
        jge fin 
        cmp ax,20d 
        jg fin
        
        inc ax 
        printNumeroConsola 
        mostrarCaracter "."
        escribirCaracterArchivo '.'
        mostrarEspacios 5d
        dec ax 
        push ax 
        mov bx,2d 
        mul bx 
        mov bx,ax
        mov al,[arreglo + bx]
        mov temporal,al
        mostrarNombre temporal
        mostrarEspacios 5d
        inc bx 
        xor ax,ax 
        mov al,[arreglo + bx]
        printNumeroConsola
        


        pop ax
        
        
        mostrarCaracter 10d
        escribirCaracterArchivo 10d
        inc ax 
        jmp recursividad
    fin:
    pop cx 
    pop bx 
    pop cx
endm

;Macro para mostrar una cantidad de espacios seguidas
mostrarEspacios macro cantidad
    LOCAL espacios,salto 
    push ax 

    xor ax,ax 
    espacios: 
        cmp ax,33d 
        jge salto 
        
        mostrarCaracter 32d
        escribirCaracterArchivo 32d
        inc ax 
        jmp espacios
    salto:


    pop ax
endm

;Mostrar el nombre al que le corresponde el punteo
mostrarNombre macro fila
    LOCAL recursividad,fin,salto,recursividad2,salto2,nombre
    push ax 
    push bx 
    push cx 
    push dx 
    xor ax,ax
    xor bx,bx 

    recursividad:
        cmp al,fila 
        jge nombre  

        recursividad2:
            cmp bx,fileSize
            jge fin
            mov cl,[buffer + bx]
            cmp cl,10d 
            je salto2 

            inc bx 
            jmp recursividad2

            salto2:
                inc bx

        inc ax 
        jmp recursividad


    nombre:
        mov cl,[buffer + bx]
        cmp cl,59d 
        je fin 

        mostrarCaracter cl
        escribirCaracterArchivo cl
        inc bx 
        jmp nombre

    
    fin:

    pop dx 
    pop cx 
    pop bx 
    pop ax
endm
