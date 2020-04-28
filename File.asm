;Macro para la creacion de archivos
crearArchivo macro nombre
    mov ah,3ch 
    mov cx,00000000b
    lea dx, [nombre]
    int 21h
    mov filehandle,ax    
endm
;Abre un Archivo en modo lectura/escritura
abrirArchivo macro nombre
    LOCAL openError,salida
    mov ah,3Dh
    mov al,2
    lea dx,nombre 
    int 21h
    jc openError
      
    mov filehandle,ax 
    mov bx,1d 
    jmp salida 

    openError:
        mostrarCadena msgOpenError 
        mov bx,0d

    salida:

endm
;Cierra El archivo actual 
cerrarArchivo macro
   mov ah,3Eh
   mov bx,filehandle
   int 21h
endm

;Obtenemos todo los datos del archivo 
leerArchivo  macro
    LOCAl error
    startFile
    xor ax,ax
    mov ah,3fh
    mov bx,filehandle
    mov cx,4000
    lea dx,buffer
    int 21h
    jc error
    
    mov fileSize,ax
    mov bx,fileSize
    mov [buffer + bx],"$"
    ;mostrarCadena buffer
    xor bx,bx 

    error:
endm

;Nos movemos al final del archivo
endFile macro 
    mov bx,filehandle
    mov cx,0
    mov dx,0
    mov ah,42h
    mov al,2
    int 21h
endm

;Nos movemos al inicio del archivo
startFile macro
    xor ax,ax
    mov bx,filehandle
    mov cx,0
    mov dx,0
    mov ah,42h
    int 21h
endm

;Escribimos al final del archivo 
writeAppend macro cadena,tam
    push ax 
    push bx 
    push cx 
    push dx 


    endFile
    mov bx,filehandle
    mov cx,tam
    lea dx,cadena 
    mov ah,40h 
    int 21h

    pop dx 
    pop cx 
    pop bx 
    pop ax
endm


;Arreglamos la direccion elimnando los $ 
corregirDireccion macro actual,destino
    LOCAL recursivo,salida,error,fin
    xor bx,bx
    mov SI,offset actual + 2
    mostrarCaracter 10d
    recursivo:
        mov cl,[SI + BX]
        cmp cl,'$'
        je salida
        cmp cl,'#'
        je salida 

        mov [destino + bx],cl
        mostrarCaracter cl

        inc bx
        jmp recursivo


    salida:  
endm


;Escribimos una cadena en un archivo 
escribirCadenaArchivo macro cadena,cantidad
    push ax
    push bx 
    push cx 
    push dx 


    mov ah,40h
    mov bx,filehandle
    mov cx,cantidad 
    mov dx, offset cadena 

    int 21h 
    
    pop dx 
    pop cx
    pop bx
    pop ax
endm

;Escribimos un caracter en el archivo 
escribirCaracterArchivo macro caracter
    push ax
    push bx 
    push cx 
    push dx 

    mov [cadenaTemp + 0],caracter

    mov ah,40h
    mov bx,filehandle
    mov cx,1 
    mov dx, offset cadenaTemp 

    int 21h 
    
    pop dx 
    pop cx
    pop bx
    pop ax
endm


printNumeroFile macro
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
        mov cadena,al
        writeAppend cadena,1
        jmp fin 


    unidad:
        
        cmp cx,0d 
        je fin 
            pop dx
            add dx,48d 
            mov cadena,dl
            writeAppend cadena,1
        dec cx
        jmp unidad

    fin:

    pop dx
    pop cx 
    pop bx 
    pop ax

endm


