;Macro para la creacion de archivos
crearArchivo macro nombre
    mov ah,3ch 
    mov cx,00000000b
    lea dx, [nombre]
    int 21h
    mov filehandle,ax    
endm
;Abre un Archivo
abrirArchivo macro nombre
    LOCAL openError,salida
    mov ah,3Dh
    mov al,1
    lea dx,[nombre] 
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
    
    mov ah,3fh
    mov bx,filehandle
    mov cx,4000
    lea dx,buffer
    int 21h
    mov fileSize,ax
    mov bx,fileSize
    mov [buffer + bx],"$"
    mostrarCadena buffer
    xor bx,bx 

    
endm

;Nos movemos al final del archivo
appendFile macro 
    mov bx,filehandle
    mov cx,0
    mov dx,0
    mov ah,42h
    mov al,2
    int 21h
endm

;Escribimos al final del archivo 
writeAppend macro cadena,tam
    appendFile
    mov bx,filehandle
    mov cx,tam
    lea dx,cadena 
    mov ah,40h 
    int 21h
endm