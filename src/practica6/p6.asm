%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .data
    bskey equ 0x7F
    lencadena equ 255
    ln equ 0x0A
    nline db ln,0
    msg1 db ln,'Captura: ', 0
    msg2 db ln,'Cadena: ', 0
    
section .bss
    cadena resb lencadena

section .text
    global _start         ; referencia para inicio de programa
    
_start:  

    ; --- IMPRIMIR CADENA  ---
    mov edx, msg1        
    call puts

    mov edx, cadena 
    mov bx, lencadena 
    mov cx, 0

    call captura 


    mostrar:   
    mov edx, msg2
    call puts
    mov edx, cadena
    call puts
    jmp .fin_programa  
    
    
    ; --- FIN DE PROGRAMA ---
    .fin_programa: 
        mov edx, nline    
        call puts         
        mov eax, 1            ; Llamada sys_exit
	    xor ebx, ebx          ; return 0
        int 0x80              ; Fin de programa

   
    captura:  push ax
              push bx
              
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
            pop ax
            ret

   