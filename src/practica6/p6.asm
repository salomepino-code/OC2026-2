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
    mov ax, lencadena 
    mov cx, 0

    ;NORMAL
    call captura
    call mostrar
    

    mov edx, cadena
    mov cx, 0

    ;MAYUSCULAS
    call mayusculas 
    call mostrar

    ;MINUSCULAS
    call minusculas 
    call mostrar

    ; --- FIN DE PROGRAMA ---
    .fin_programa: 
        mov edx, nline    
        call puts         
        mov eax, 1            ; Llamada sys_exit
	    xor ebx, ebx          ; return 0
        int 0x80              ; Fin de programa 
    
    ; --- MOSTRAR ---
    mostrar:   
    mov edx, msg2
    call puts
    mov edx, cadena
    call puts
    ret

    ; --- CAPTURA ---

    captura:  push ax
              
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
            cmp cx, ax
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

    .salir: mov byte[edx], ln
            pop ax
            ret

    ; --- MAYUSCULAS ---

    mayusculas: 
    
    .loop: cmp byte[edx], 'a'
           jb .avanzar
           cmp byte[edx], 'z'
           ja .avanzar
           sub byte[edx], 32
    
    .avanzar: inc edx
              cmp byte[edx], 0
              jz .salir
              jmp .loop

    .salir: ret
             

    ; --- MINUSCULAS ---

    minusculas:
    .loop: cmp byte[edx], 'A'
           jb .avanzar
           cmp byte[edx], 'Z'
           ja .avanzar
           add byte[edx], 32
    
    .avanzar: inc edx
              cmp byte[edx], 0
              jz .salir
              jmp .loop

    .salir: ret