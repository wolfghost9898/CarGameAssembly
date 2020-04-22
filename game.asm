include File.asm
include Usuario/Usuario.asm
include Juego/Juego.asm
include Short.asm

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
   mov ah,2
   mov dl,caracter
   int 21h
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

        msgSesionAdmin db 10,"1) Top 10 Puntos",10,"2) Top 10 Tiempo",10,"3) Salir",10,"$"
        msgTipoOrdenamiento db 10,"1) Ordenamiento BubbleSort",10,"2) Ordenamiento QuickSort",10,"3) Ordenamiento ShellSort"
    
    ;################################################## USUARIOS ######################################################
        usuario db 9 DUP('$')
        contrasenia db 6 DUP('$')

    ;################################################# ARCHIVOS ##################################################
       
        
        direccionUsuario db "C:\p1\Usuario\db.txt",0
        direccionPuntaje db "C:\p1\Juego\puntaje.txt",0
        tamanio dw ?
        cadena db 10 DUP("$")
        fileSize dw 0
        filehandle dw ?
        buffer db 4000 dup (?), '$'

        direccionCarga db 30 DUP("$")
        fileCarga db "C:\p1\Juego\db.ply",0

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

    ;################################## QUICK SORT ####################################
        i dw ?
        j db ?
        pivote db ?
        first dw ?
        last dw ?

.code
main proc
    mov ax,@data
    mov ds,ax
    mov dx,ax 
	Login:
        clearScreen
        mostrarCadena msgSesion

        ;ingresarCaracter
        mov bl,'1'
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
        jmp Administrador
        clearScreen
        abrirArchivo direccionUsuario
        mostrarCadena msgUsuario
        ingresarCadena usuario
        
        mostrarCaracter 10
        leerArchivo
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
        ;mostrarCadena msgCarga
        ;ingresarCadena direccionCarga 
        ;corregirDireccion direccionCarga,fileCarga ; Eliminamos el \n al final y agregamos un 0
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
        cmp AH, 4Dh     
        je derecha
        
        cmp AH, 4Bh     
        je izquierda

        printCarro
        jmp fin

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

        cmp puntaje,0d 
        jl fin

        controlTiempo
        
        mov bx,tiempoActual
        cmp bx,tiempoNivel 
        jg controlFin

        jmp Escenario
    
    controlFin: 
        mov bx,posicionActual 
        cmp bx,fileSize
        jge fin 

        mov tiempoActual,0d 
        cargarNivel
        inc nivelActual
        jmp Escenario
    
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

        jmp fin 

    topPuntaje:
        
        clearScreen
        abrirArchivo direccionPuntaje
        leerArchivo
        cerrarArchivo
        
        cargarPuntaje
        
        modoVideo
        graficarArreglo 1d
        
        ingresarCaracter         
        modoConsola 
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
        xor ax,ax
        mov al,cantidadRegistros
        dec ax
        mov temp,ax

        ordenamientoQuickSort 0d,temp
        
        clearScreen
        modoVideo
        graficarArreglo 1d
        ingresarCaracter
        modoConsola
        jmp Administrador

    bubblesort:
        

        ordenamientoBubbleSort 

        clearScreen
        modoVideo
        graficarArreglo 1d 
        ingresarCaracter
        modoConsola

        jmp Administrador


    shellshort:
        ordenamientoShellSort
        clearScreen
        modoVideo
        graficarArreglo 1d 
        ingresarCaracter
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

