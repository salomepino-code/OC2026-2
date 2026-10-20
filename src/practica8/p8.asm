

section .data
    bskey equ 0x7F
    lencadena equ 64
    lensalida equ 12
    ln equ 0x0A
    nline db ln,0
    msg1 db ln,'Captura: ', 0
    msg2 db ln,'Cadena: ', 0
    msg3 db ln,'Numero: ', 0
    
section .bss
    cadena resb lencadena
    salida resb lensalida

section .text
    global _start         
    
_start:  

mov edx, msg1        
call captura

; CAPTURAR
captura:  push bx
              
    .loop:    call getch
              cmp al, bskey
              jne .sig
              jmp .borrar
    
    .sig:   cmp al, ln
            jz .salir
            call putchar
            mov byte[edx], al
            inc edx
            inc cx
            cmp cx, bx
            jz .salir
            jmp .loop

    .borrar:  cmp cx, 0
          je .loop              
          dec edx
          dec cx
          mov al, 0x8
          call putchar
          mov al, ' '
          call putchar
          mov al, 0x8
          call putchar
          jmp .loop

    .salir: mov byte[edx], 0
            pop bx
            ret


; GETCH
getche: push ebx

        mov eax, 3
        mov ebx, 0
        mov ecx, msg1+1
        mov edx, 1
        int 0x80

        pop ebx
        ret

; GETCH  
getch: 

ret

;PUTCHAR 
putchar:

ret

;PUTS 
puts:

ret
    