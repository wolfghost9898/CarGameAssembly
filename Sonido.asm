;Reproducira un sonido dependiendo de la frecuencia
playSound macro
    LOCAL pause1,pause2
    push ax 


    mov al,182
    out 43h,al 
    mov ax,frequencyGraph         ;Frecuencia 

    out 42h,al 
    mov al,ah
    out 42h,al 
    in al,61h
    or al,00000011b   
    out 61h,al


    delay 200d

    in al,61h 
    and al,11111100b      
    out 61h,al

    pop ax 
endm

