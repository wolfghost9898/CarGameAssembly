include File.asm
include Usuario/Usuario.asm
include Juego/Juego.asm
include Short.asm
include Sonido.asm

;##############################################################################
;########################## MOSTRAR UNA CADENA     ###################
;##############################################################################
mostrarCadena macro cadena
    mov ah,09h
    xor al,al
    mov dx, offset cadena
    int 21h 
endm

;##############################################################################
;########################## MOSTRAR UNA CARACTER     ###################
;##############################################################################
mostrarCaracter macro caracter
   push ax
   mov ah,2
   mov dl,caracter
   int 21h
   pop ax
endm
;##############################################################################
;########################## PEDIR UN CARACTER      ###################
;##############################################################################
ingresarCaracter macro 
   mov ah,1
   int 21h
   mov bl,al
endm

;##############################################################################
;########################## MOSTRAR UN NUMERO en consola y lo guarda en un archivo    ###################
;##############################################################################
printNumeroConsola macro
    LOCAL unidad,decena,fin,cero
    push ax 
    push bx 
    push cx 
    push dx 

    xor cx,cx 
    xor bx,bx
    
    cmp ax,10d
    jl cero 

    decena:
        cmp al,0d 
        je unidad 

        xor dx,dx 
        mov bx,10d 
        div bx
        push dx 
        inc cx
        
        jmp decena

    cero:
        add ax,48d 
        mostrarCaracter al
        escribirCaracterArchivo al
        jmp fin 


    unidad:
        
        cmp cx,0d 
        je fin 
            pop dx
            add dx,48d 
            mostrarCaracter dl
            escribirCaracterArchivo dl
        dec cx
        jmp unidad

    fin:

    pop dx
    pop cx 
    pop bx 
    pop ax

endm

;##############################################################################
;########################## LIMPIAR PANTALLA     ###################
;##############################################################################
clearScreen macro
    mov ax,03h
    int 10h
endm

;##############################################################################
;########################## INGRESAR UNA CADENA    ###################
;##############################################################################
ingresarCadena macro variable
    xor ax,ax
    mov ah,0AH               
    lea dx,variable
    int 21h

    xor bx,bx 
    mov bl,variable + 1
    mov[variable + bx + 2],36
endm


;##############################################################################
;########################## DETECTAR UNA TECLA  ###################
;##############################################################################
ingresarTecla macro
    mov ah,00h 
    int 16h
endm


.model small
.stack 
.data
        arreglo db 60 DUP(0)
        arregloTemp db 60 DUP(0)
	;################################################### MENSAJES ####################################################
		cabecera   db "Universidad de San Carlos de Guatemala",10,"Facultad de Ingenieria",10,"Ciencias y Sistemas",10,
		"Arquitectura de computadores y ensambladores 1",10,"Carlos Eduardo Hernandez Molina",10,"201612118",10,"Seccion A",10,"$"
        msgSesion db 10,"1) Ingresar",10,"2) Registrar",10,"3) Salir",10,"$"
        msgJuego db 10,"1) Iniciar Juego",10,"2) Cargar Juego",10,"3) Salir",10,"$"
        msgUsuario db 10,"Usuario: $"
        msgUsuarioError db 10,"Este usuario ya existe$"
        msgUsuarioErrorN db 10,"Este usuario no existe$"
        msgPasswordError db 10,"La contrasenia tiene que ser numerica$"
        msgPasswordErrorN db 10,"La contrasenia no coincide$"
        msgContrasenia db 10,"Contrasenia: $"
        msgOpenError db 10,"No se pudo Abrir el archivo",10,"$"
        msgCarga db 10,"Ingrese el Nombre del archivo: $"
        msgOrdenamiento db 10,"1) Ascendente",10,"2) Descendente",10,"$"

        msgSesionAdmin db 10,"1) Top 10 Puntos",10,"2) Top 10 Tiempo",10,"3) Salir",10,"$"
        msgTipoOrdenamiento db 10,"1) Ordenamiento BubbleSort",10,"2) Ordenamiento QuickSort",10,"3) Ordenamiento ShellSort$"
        msgVelocidad db 10,"Ingrese una Velocidad(0-9)",10,"$"

        msgTiempo db "Tiempo:$","$"
        msgVelocidadP db "Velocidad:$"
    ;################################################## USUARIOS ######################################################
        usuario db 9 DUP('$')
        contrasenia db 6 DUP('$')
        tamUsuario db 1 DUP(0)

    ;################################################# ARCHIVOS ##################################################
       
        
        direccionUsuario db "C:\p1\Usuario\db.txt",0
        direccionPuntaje db "C:\p1\Juego\puntaje.txt",0
        tamanio dw ?
        cadena db 10 DUP("$")
        fileSize dw 0
        filehandle dw ?
        buffer db 4000 dup (?), '$'

        direccionCarga db 30 DUP("$")
        ;fileCarga db "C:\p1\Juego\db.ply",0
        fileCarga db 30 DUP(0)

    ;######################################### JUEGO ###############################
        carroI dw ? 
        carroF dw ?
        minutos db ? 
        segundos db ?
        objetos db 99 DUP(0)
        cantObjetos db ?

        tiempoAmarillo db ?
        tiempoVerde db ?

        tiempoAmarilloTemp db ?
        tiempoVerdeTemp db ?

        puntaje dw ?

        puntosAmarillo dw ?
        puntosVerde dw ?

        
        posicionActual dw ?
        cadenaNivel db 3 DUP("$")
        tiempoNivel dw ?
        tiempoActual dw ? 
        nivelActual dw ?
        tiempoTotal dw ?

        colorCarro db ?
    ;################################## OTROS ####################################
        temp dw ?
        contador dw ?
        contador2 dw ?
        temporal3 dw ?
        temp2 dw ?
        tamUser dw ?
        temporal db 0
        temporal2 db ?
    ;################################## GRAFICAS ####################################

        cantidadRegistros db ?
        cantidadEspacios dw ?
        espacioGrafica dw ?
        posicionGrafica dw ?
        valorMayor dw ?
        colorGrafica db ?
        frequencyGraph dw ?
        ordenamiento db ?
        tiempoOrdenamiento db ?
        velocidadOrdenamiento db 2 DUP("$")
        auxiliarVelocidad db ?
        contadorVelocidad db ?
        velocidadTiempo dw ?
        flagContar db ?

        nombreQuickSort db "QuickSort$"
        nombreBubbleSort db "BubbleSort$"
        nombreShellSort db "ShellSort$"
        tipoOrdenamientoN db ?

        msgTopPuntaje db "Top Puntaje$"
        msgTopTiempo db "Top Tiempo$"

    ;################################## QUICK SORT ####################################
        i dw ?
        j db ?
        pivote db ?
        first dw ?
        last dw ?
    ;############################### REPORTES ########################################
        direccionReporte db "C:\p1\Juego\Puntaje.rep",0
        cadenaTemp db 2 DUP("$")

.code
main proc
    mov ax,@data
    mov ds,ax
    mov dx,ax 
	Login:
        clearScreen
        mostrarCadena msgSesion

        ingresarCaracter
        cmp bl,'1'
        je Ingresar 
        cmp bl,'2'
        je Registrar 
        cmp bl,'3'
        je Salir
        jmp Login
    
    ;#############################################################################################################################
    ;##################################################### INICIAR SESION #####################################################
    ;############################################################################################################################
    Ingresar:
        clearScreen
        abrirArchivo direccionUsuario
        mostrarCadena msgUsuario
        ingresarCadena usuario
        
        userAdmin usuario + 2
        cmp bx,0d 
        je noAdmin

        mostrarCaracter 10
        mostrarCadena msgContrasenia
        ingresarCadena contrasenia

        passAdmin contrasenia + 2
        cmp bx,1d
        je Administrador 

        mostrarCadena msgPasswordErrorN
        ingresarCaracter
        jmp Ingresar

        noAdmin:
        mostrarCaracter 10
        leerArchivo
        mov cl,usuario + 1
        mov tamUsuario,cl
        buscarUsuario usuario + 2
        
        cmp bl,1d
        je ingresarContrasena 

        mostrarCadena msgUsuarioErrorN
        ingresarCaracter
        jmp Ingresar
    
    ingresarContrasena:
        mostrarCaracter 10
        
        mostrarCadena msgContrasenia
        ingresarCadena contrasenia
        
        confirmarContra contrasenia + 2
        cmp bl,1d 
        je Juego

        mostrarCadena msgPasswordErrorN
        ingresarCaracter
        jmp ingresarContrasena
    
    ;#############################################################################################################################
    ;##################################################### REGISTRAR USUARIO #####################################################
    ;############################################################################################################################
    Registrar:
        clearScreen
        abrirArchivo direccionUsuario
        mostrarCadena msgUsuario
        ingresarCadena usuario
        
        mostrarCaracter 10
        leerArchivo
        buscarUsuario usuario + 2
        
        cmp bl,0d
        je pedirContrasenia 

        mostrarCadena msgUsuarioError
        ingresarCaracter
        jmp Registrar


    pedirContrasenia:
        mostrarCaracter 10
        
        mostrarCadena msgContrasenia
        ingresarCadena contrasenia
        
        validarPassword contrasenia + 2
        cmp bl,0d 
        je guardarUsuario

        mostrarCadena msgPasswordError
        ingresarCaracter
        jmp pedirContrasenia

    guardarUsuario: 
        pop bx
        mostrarCaracter 10
        mov al,usuario + 1
        mov ah,0
        mov tamanio,ax
        writeAppend usuario + 2,tamanio

        mov cadena,59
        writeAppend cadena,1
        
        mov al,contrasenia + 1
        mov ah,0
        mov tamanio,ax
        writeAppend contrasenia + 2,tamanio

        mov cadena,10
        writeAppend cadena,1
        
        cerrarArchivo
        
        jmp Login

    ;#############################################################################################################################
    ;##################################################### JUEGO #####################################################
    ;############################################################################################################################
    Juego:
        clearScreen 

        mostrarCadena cabecera
        mostrarCadena msgJuego
        ingresarCaracter
        
        cmp bl,'1'
        je configuracion

        cmp bl,'2'
        je cargarJuego

        jmp Salir
    

    cargarJuego:
        clearScreen 
        mostrarCadena msgCarga
        ingresarCadena direccionCarga 
        corregirDireccion direccionCarga,fileCarga ; Eliminamos el \n al final y agregamos un 0
        abrirArchivo fileCarga ;Abrimos el archivo en lectura/escritura
        
        cmp bx,0d 
        jne leerCarga ; Si se puedo abrir lo leemos
        
        mostrarCadena msgOpenError
        ingresarCaracter
        jmp Juego
        
    leerCarga:
        leerArchivo 
        mostrarCadena buffer
        cerrarArchivo
        ingresarCaracter

        jmp Juego

        
    
    configuracion:
        mov posicionActual,0d 
        cargarNivel
        
        mov carroI,150d
        mov carroF,165d
        
        mov minutos,0d 
        mov segundos,0d
        
        mov cantObjetos,0d
        mov puntaje,3d

        mov tiempoActual,0d 
        mov nivelActual,1d
        
        mov tiempoTotal,0d
        
        clearScreen 
        modoVideo
        printCalle
        printCarro

    Escenario:
        printHUD
        recorrerObjetos
        

        mov ah, 0bh
        int 21h    
        
        cmp al,0 
        je refresco

        

        mov ah,0
        int 16h
        
        cmp ah,01h
        je pausa

        cmp AH, 4Dh     
        je derecha
        
        cmp AH, 4Bh     
        je izquierda

        printCarro
        jmp refresco

    pausa: 
        mov ah,0bh 
        int 21h 

        cmp al,0 
        je pausa
        
        mov ah,0 
        int 16h     

        cmp ah,01h 
        je refresco

        cmp ah,39h 
        je finJuego

        jmp pausa

    izquierda:
        moverIzquierda       
        jmp refresco
        
    derecha: 
        moverDerecha       
        jmp refresco

    refresco:
        
        delay 1200d
        moverObjetos
        generarObstaculos
        popObjetos
        choque

        inc tiempoAmarilloTemp
        inc tiempoVerdeTemp

        inc tiempoTotal
        cmp puntaje,0d 
        jl finJuego

        controlTiempo
        
        mov bx,tiempoActual
        cmp bx,tiempoNivel 
        jg controlFin

        jmp Escenario
    
    controlFin: 
        mov bx,posicionActual 
        cmp bx,fileSize
        jge finJuego 

        mov tiempoActual,0d 
        cargarNivel
        inc nivelActual
        jmp Escenario
    
    finJuego:
        guardarPuntaje
        jmp Juego
    ;#############################################################################################################################
    ;##################################################### ADMINISTRADOR #####################################################
    ;############################################################################################################################
    
    Administrador:
        clearScreen
        mostrarCadena cabecera
        mostrarCadena msgSesionAdmin
        ingresarCaracter

        cmp bl,'1'
        je topPuntaje

        cmp bl,'2' 
        je topTiempo

        jmp fin 

    topPuntaje:
        
        clearScreen
        abrirArchivo direccionPuntaje
        leerArchivo
        cerrarArchivo
        cargarPuntaje

        crearArchivo direccionReporte
        ordenarTop10
        mostrarTop msgTopPuntaje
        cerrarArchivo
        ingresarCaracter

        jmp escogerOrdenamiento

        
    
    
    topTiempo:
        clearScreen
        abrirArchivo direccionPuntaje
        leerArchivo 
        cerrarArchivo 
        cargarTiempo
        crearArchivo direccionReporte
        ordenarTop10 
        mostrarTop msgTopTiempo
        cerrarArchivo 
        ingresarCaracter 


    escogerOrdenamiento:
        clearScreen
        mostrarCadena msgTipoOrdenamiento
        mostrarCaracter 10d
        ingresarCaracter

        cmp bl,'1' 
        je bubblesort 

        cmp bl,'2'
        je quicksort 

        cmp bl,'3' 
        je shellshort
        
        jmp Administrador

    quicksort:
        mov tipoOrdenamientoN,0d
        mov segundos,0d 
        mov minutos,0d
        

        tipoOrdenamiento
        clearScreen 
        mostrarCadena msgVelocidad
        ingresarCaracter
        controlVelocidad
        graficaEstatica
        xor ax,ax
        mov al,cantidadRegistros
        dec ax
        mov temp,ax
        mov flagContar,1d
        ordenamientoQuickSort 0d,temp
        
        clearScreen
        graficaEstatica

        jmp Administrador

    bubblesort:
        mov tipoOrdenamientoN,1d
        mov segundos,0d 
        mov minutos,0d

        tipoOrdenamiento
        clearScreen
        mostrarCadena msgVelocidad
        ingresarCaracter
        controlVelocidad
        graficaEstatica
        
        mov flagContar,1d
        ordenamientoBubbleSort 
        
        clearScreen
        graficaEstatica
        modoConsola

        jmp Administrador


    shellshort:
        mov tipoOrdenamientoN,2d
        mov segundos,0d 
        mov minutos,0d
        
        tipoOrdenamiento
        clearScreen 
        mostrarCadena msgVelocidad
        ingresarCaracter
        controlVelocidad
        graficaEstatica

        mov flagContar,1d

        ordenamientoShellSort
        
        clearScreen
        graficaEstatica
        modoConsola

        jmp Administrador

    fin:
    mov ax,3h
    int 10h
    
    Salir:
    ingresarCaracter
    
    mov   ax,4c00h       
    int   21h




main endp

ordenamientoQuick proc
    mov ax,first
    cmp ax,last 
    jge fin

    partition arregloTemp,first,last
    mov cx,temp2
     
    
    push bx 
    push cx
    
    
    dec cx
    mov bx,cx
    ordenamientoQuickSort ax,bx 
    
    pop cx
    pop bx 
    inc cx 
    mov ax,cx 
    ordenamientoQuickSort ax,bx
        
    

    fin:
    ret
ordenamientoQuick endp


end

