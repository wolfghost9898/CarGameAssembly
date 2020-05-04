;Nos pasamos a modo video 
modoVideo macro 
    mov ah,00h
    mov al,13h
    int 10h
    mov ax, 0A000h
    mov es, ax

endm


;Nos pasamos a modo consola 
modoConsola macro 
    mov ax,3h
    int 10h
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
printCaracter macro columna,row,caracter
    mov  dl, columna   ;Columna
    mov  dh, row   ;Fila
    mov  bh, 0    ;Pagina
    mov  ah, 02h  ;Mover cursos
    int  10h

    mov  al, caracter
    mov  bl, 15d  ;Color 
    mov  bh, 0     ;Pagina
    mov  ah, 0Eh  
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

            pintar bx,dx,colorCarro

            inc bx 
            jmp recursividad


        fin:


        inc dx 
        jmp recursividadY

    finY:
    
    ;################################### LLANTAS ############################
    mov bx,carroI 
    sub bx,3d
    mov ax,154d 
    dibujarCuadrado 255d

    mov ax,176d
    dibujarCuadrado 255d
    mov ax,172d
    dibujarCuadrado 255d


    mov bx,carroF
    sub bx,1d 
    mov ax,154d 
    dibujarCuadrado 255d
    mov ax,176d
    dibujarCuadrado 255d
    mov ax,172d
    dibujarCuadrado 255d


endm

;############################ MUEVE EL CARRO HACIA LA IZQUIERDA ####################
moverIzquierda macro
    LOCAL salir 
    mov cx,carroI 
    cmp cx,30d 
    jle salir

    mov dx,carroF 
    mov temp,dx 
    
    sub carroI,15d 
    sub carroF,15d
    add temp,3d
    limpiarGrafico carroF,temp,150d,180d
    printCarro

    salir:
endm

;############################ MUEVE EL CARRO HACIA LA DERECHA ####################
moverDerecha macro
    LOCAL salir 
    mov cx,carroF 
    cmp cx,290d 
    jge salir

    mov dx,carroI 
    mov temp,dx 
    add carroI,15d 
    add carroF,15d
    sub temp,3d
    limpiarGrafico temp,carroI,150d,180d
    printCarro
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


;########################## DIBUJAR HUD ####################
printHUD macro
    LOCAL salto
    printCadena 18,0,cadenaNivel
    cmp puntaje,0d 
    jl salto
    printPuntaje
    
    salto:
    printCadena 2,0,usuario + 2
    printNumero minutos,73,0
    printCaracter 75,0,":"
    printNumero segundos,76,0
endm
;############################### IMPRIME EL PUNTAJE ACTUAL#####################
printPuntaje macro
    xor ax,ax
    xor bx,bx 
    xor cx,cx 
    


    mov ax,puntaje 
    mov bx,100d 
    div bl
    push ax 
    add al,48d
    printCaracter 23,0,al 
    pop ax 
    mov al,ah
    xor ah,ah
    mov bx,10d
    div bl
    push ax 
    add al,48d 
    printCaracter 24,0,al
    pop ax
    mov al,ah 
    add al,48d 
    printCaracter 25,0,al



   
endm 
;##################### PRINT UN NUMERO ########################
printNumero macro numero,columna,fila
    LOCAL decena,fin 

    push ax
    push bx 
    push cx 
    push dx 

    xor cx,cx
    xor dx,dx 
    xor ax,ax 
    xor bx,bx 
    mov cl,numero 
    cmp cx,10d
    jge decena

   
    xor bx,bx 
    mov dl,columna
    printCaracter dl,fila,48d
    add cl,48d 
    mov dl,columna
    inc dl
    printCaracter dl,fila,cl
    jmp fin
    
    decena:
        xor cx,cx
        xor dx,dx 
        xor ax,ax 
        xor bx,bx

        mov al,numero 
        mov cx,10d 
        div cx 
        mov cl,al 
        mov ch,dl
        add cl,48d 
        mov bl,columna
        printCaracter bl,fila,cl
        add ch,48d
        mov dl,columna 
        inc dl
        printCaracter dl,fila,ch 

    fin:
    pop dx 
    pop cx 
    pop bx 
    pop ax
endm


;################# LIMPIAR CIERTA AREA DE LA PANTALLA ###########
limpiarGrafico macro posXI,posXF,posYI,posYF
    LOCAL recursividadX,finX,recursividadY,finY 
    mov bx,posXI
    
    recursividadX:
        cmp bx,posXF 
        jg finX

        mov cx,posYI 
        recursividadY:
            cmp cx,posYF 
            jg finY 
            
            pintar bx,cx,7

            inc cx
            jmp recursividadY
        finY:

        inc bx
        jmp recursividadX


    finX:
endm

;##################### RECORRE LA LISTA DE OBJETOS Y LAS IMPRIME######################3
recorrerObjetos macro
    LOCAL recursividad,fin,verde,salto
    push ax 
    push bx 
    push cx 
    push dx 

    xor ax,ax
    mov al,cantObjetos
    mov bx,3d 
    mul bx
    mov bx,0d 
    recursividad:
        cmp bx,ax
        jge fin 
        
        xor cx,cx 
        xor dx,dx
        cmp [objetos + bx],0d
        je verde 

        inc bx 
        mov cl,[objetos + bx]
        inc bx
        mov dl,[objetos + bx]
        printObjeto cx,dx,67d,68d

        jmp salto

        verde:
            inc bx
            mov cl,[objetos + bx]
            inc bx
            mov dl,[objetos + bx]
            printObjeto cx,dx,2d,70d
        
        salto:

        inc bx
        jmp recursividad
    
    fin:



    pop ax 
    pop bx 
    pop cx
    pop dx
endm


;##################### MUEVE TODOS LOS OBJETOS Y LIMPIA EL ANTERIOR ######################3
moverObjetos macro
    LOCAL recursividad,fin,verde
    push ax 
    push bx 
    push cx 
    push dx 

    xor ax,ax
    mov al,cantObjetos
    mov bx,3d 
    mul bx
    mov bx,0d 
    recursividad:
        cmp bx,ax
        jge fin 
        
        push ax 
        xor cx,cx 
        xor dx,dx
        
        inc bx 
        mov cl,[objetos + bx]
        inc bx
        push bx 
        mov dl,[objetos + bx]
        

        mov ax,cx 
        add ax,20d
        sub cx,20d 
        mov temp,dx 
        sub temp,20d
        
        limpiarGrafico cx,ax,temp,dx 
        pop bx
        xor ax,ax 
        mov al,[objetos + bx]
        add ax,8d  ; Velocidad de desplazamiento
        mov [objetos + bx],al

        pop ax
        inc bx 
        jmp recursividad
    
    fin:



    pop ax 
    pop bx 
    pop cx
    pop dx
endm

;#################### SI YA LLEGO EL ULTIMO AL BORDE LO SACAMOS ###########################
popObjetos macro
    LOCAL fin,recursividad,eliminar
    
    cmp cantObjetos,0d
    jle fin 

    xor ax,ax
    mov al,[objetos + 2]
    cmp ax,175d 
    jle fin
    
    xor ax,ax
    xor bx,bx 


    mov al,[objetos + 1]

    mov temp,ax 
    add temp,4d 


    limpiarGrafico ax,temp,150d,180d 

    makePop

    
    

    fin:

endm



;#################### SI CHOCA CON UN OBSTACULO EL VEHICULO ###########################
choque macro
    LOCAL fin,recursividad,eliminar,verde,salto
    
    cmp cantObjetos,0d
    jle fin 

    xor ax,ax
    mov al,[objetos + 2]
    
    cmp ax,150d 
    jle fin
    

    xor ax,ax
    mov al,[objetos + 1]
    add ax,12d
    cmp ax,carroI 
    jl fin 

    xor ax,ax 
    mov al,[objetos + 1]
    sub ax,8d 
    cmp ax,carroF
    jg fin

   




    xor ax,ax
    xor bx,bx 

    mov al,[objetos + 0]
    cmp al,0d 
    je verde 

    mov ax,puntosAmarillo 
    add puntaje,ax

    jmp salto
    verde:

        mov ax,puntosVerde 
        sub puntaje,ax

    salto:
    mov al,[objetos + 1]

    mov temp,ax 
    add temp,4d 


    limpiarGrafico ax,temp,120d,160d 

    makePop
        

    
    

    fin:

endm

;################################# SACAMOS AL INICIO UN OBSTACULO ####################
makePop macro
    LOCAL recursividad,fin
    xor ax,ax
    xor bx,bx 
    
    mov al,cantObjetos
    mov bx,3d 
    mul bx 
    xor cx,cx
    mov bx,3d

    recursividad:
        cmp bx,ax 
        jge fin 

        mov dl,[objetos + bx]
        push bx 
        mov bx,cx
        mov [objetos + bx],dl 
        pop bx 

        inc bx 
        inc cx
        mov dl,[objetos + bx]
        push bx 
        mov bx,cx
        mov [objetos + bx],dl 
        pop bx

        inc bx 
        inc cx
        mov dl,[objetos + bx]
        push bx 
        mov bx,cx
        mov [objetos + bx],dl 
        pop bx  

        inc bx
        inc cx 
        jmp recursividad  
    fin:
    dec cantObjetos      
endm

;################################ GENERARA CADA TIEMPO UN OBJETO EN POSICION ALETATORIA ###############
generarObstaculos macro
    LOCAL fin,verde
    push ax
    push bx
    
    xor ax,ax
    xor bx,bx 
    
    
    mov al,tiempoAmarilloTemp 

    cmp al,tiempoAmarillo 
    jl verde

    xor ax,ax 
    mov al,cantObjetos 
    mov bx,3d 
    mul bx 

    mov bx,ax 

    mov [objetos + bx],1d 
    inc bx
    numeroAleatorio 
    mov [objetos + bx],al
    inc bx 
    mov [objetos + bx],40d
    
    mov tiempoAmarilloTemp,0d
    inc cantObjetos


    verde:
        mov al,tiempoVerdeTemp 
        cmp al,tiempoVerde 
        jl fin

        xor ax,ax 
        mov al,cantObjetos 
        mov bx,3d 
        mul bx 

        mov bx,ax 

        mov [objetos + bx],0d 
        inc bx
        numeroAleatorio 
        mov [objetos + bx],al
        inc bx 
        mov [objetos + bx],40d
        
        mov tiempoVerdeTemp,0d
        inc cantObjetos 
    



    fin:

    pop bx
    pop ax
endm


;####################### NOS DEVUELVE UN NUMERO ALEATORIO BASADO EN LOS SEGUNDOS DEL TIEMPO ACTUAL#############
numeroAleatorio macro
    push bx 
    
    mov ah,00h 
    int 1ah 
    
    mov ax,dx
    xor dx,dx
    mov bx,10 
    div bx 
    inc dx
    mov ax,dx
    mov bx,175d 
    mul bx 
    mov bx,9d 
    div bx 
    add ax,55d
    pop bx
endm

;Cargamos la informacion de un nuevo nivel
cargarNivel macro
    LOCAL fin,recursivo,siguiente,salto
    push bx 
    push ax
    push dx 
    push cx 

    xor bx,bx 
    
    mov bx,posicionActual 
    cmp bx,fileSize ;Si ya superamos los niveles nos salimos
    jge fin 

    add posicionActual,6d
    ;Guardamos el nombre del nivel
    mov [cadenaNivel + 0],'N'
    mov bx,posicionActual
    mov cl,[buffer + bx]
    mov [cadenaNivel + 1],cl 
    
    add posicionActual,2d   

    ;Obtenemos el tiempo del nivel
    getNumber
    mov tiempoNivel,ax

    ;Obtenemos el tiempo para los obstaculos
    getNumber
    mov tiempoVerde,al
    
    ;Obtenemos el tiempo para los premios 
    getNumber
    mov tiempoAmarillo,al

    ;Obtenemos el color 
    getColor 
    mov colorCarro,al

    ;Obtenemos el valor del puntaje amarillo 
    getNumber 
    mov puntosAmarillo,ax

    ;Obtenemos el valor del puntaje verde
    getNumber 
    mov puntosVerde,ax
    inc posicionActual
    fin:

    pop cx 
    pop dx
    pop ax
    pop bx
endm


;Convertimos el string numero a un int 
getNumber macro 
    LOCAL fin,recursivo,convertir,recursivo2
    xor dx,dx
    mov temp2,0d
    recursivo:
        mov bx,posicionActual
        xor cx,cx
        mov cl,[buffer + bx]
       
        cmp cl,59d
        je convertir ;Si es un punto y coma entonces procedemos a convertir el numero 
        cmp cl,10d  ;Salto de linea
        je convertir
        cmp cl,13d  ;Retorno de carro
        je convertir

        cmp bx,fileSize 
        jge convertir

        sub cx,48d 
        push cx
        
        inc temp2 
        inc posicionActual
        jmp recursivo
    
    
    convertir:
        
        inc posicionActual
        mov bx,1d
        mov temp,0d
        
        recursivo2:
            cmp temp2,0d
            jle fin ;Si ya no tenemos numeros que sacar 

            pop cx
            mov ax,cx
            mul bx 
            add ax,temp
            mov temp,ax

            mov ax,bx 
            mov bx,10d 
            mul bx 
            mov bx,ax 

            mov ax,temp

            dec temp2 
            jmp recursivo2

    fin:
endm


;Obtenemos el color y lo volvermos un numero 
getColor macro
    LOCAL rojo,fin,verde,blanco
    mov bx,posicionActual 
    mov cl,[buffer + bx]
    
    cmp cl,'r'
    je rojo 

    cmp cl,'v'
    je verde 

    cmp cl,'b'
    je blanco

    add posicionActual,5 
    mov ax,9d 
    jmp fin
    
    rojo: 
        add posicionActual,5
        mov ax,4d 
        jmp fin

    verde:

        add posicionActual,6
        mov ax,2d 
        jmp fin

    blanco: 
        add posicionActual,7 
        mov ax,15 
        jmp fin 
    

    fin:

endm


;controlamos el tiempo cada 60seg aumentamos en 1 el minuto 
controlTiempo macro
    LOCAL fin 

    inc segundos

    cmp segundos,60d 
    jl fin 

    mov segundos,0d 
    inc minutos


    fin:

    inc tiempoActual
endm


;Guardamos el puntaje del usuario actual 
guardarPuntaje macro
    LOCAL salto
    push ax 
    push bx 
    push cx 
    push dx 
    abrirArchivo direccionPuntaje
    mov al,usuario + 1
    mov ah,0
    mov tamanio,ax
    writeAppend usuario + 2,tamanio

    mov cadena,59d 
    writeAppend cadena,1 
    mov ax,puntaje

    cmp ax,0d 
    jge salto 

    mov ax,0d
    salto:
    printNumeroFile
    mov cadena,59d 
    writeAppend cadena,1 
    mov ax,tiempoTotal
    printNumeroFile
    mov cadena,10d 
    writeAppend cadena,1 
    cerrarArchivo
    pop dx 
    pop cx 
    pop bx 
    pop ax
endm