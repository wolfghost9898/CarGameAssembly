include File.asm
include Usuario/Usuario.asm
include Juego/Juego.asm

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

    ;################################################## USUARIOS ######################################################
        usuario db 9 DUP('$')
        contrasenia db 6 DUP('$')

    ;################################################# ARCHIVOS ##################################################
       
        
        direccionUsuario db "C:\p1\Usuario\db.txt",0
        tamanio dw ?
        cadena db 10 DUP("$")
        fileSize dw 0
        filehandle dw ?
        buffer db 4000 dup (?), '$'

    ;######################################### JUEGO ###############################
        carroI dw ? 
        carroF dw ?
.code
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
        jmp Juego
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
        mov carroI,145d
        mov carroF,175d
        mostrarCadena cabecera
        mostrarCadena msgJuego
        ingresarCaracter
        clearScreen 
        modoVideo
    Escenario:
        printCalle
        printCarro
        printObjeto 100d,100d,38d,62d
        ingresarTecla
        cmp ah,4Bh
        je izquierda
        cmp ah,4Dh
        je derecha

        jmp fin

    izquierda:
        moverIzquierda       
        jmp Escenario
        
    derecha: 
        moverDerecha       
        jmp Escenario
    fin:
    mov ax,3h
    int 10h
        
    Salir:
    ingresarCaracter
    
    mov   ax,4c00h       
    int   21h




end