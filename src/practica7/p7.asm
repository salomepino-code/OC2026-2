%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .data
    bskey equ 0x7F
    lencadena equ 64
    ln equ 0x0A
    nline db ln,0
    msg1 db ln,'Captura: ', 0
    msg2 db ln,'Cadena: ', 0
    
section .bss
    cadena resb lencadena

section .text
    global _start         ; referencia para inicio de programa
    
_start:  

    mov edx, msg1        
    call puts

    mov edx, cadena 
    mov ax, lencadena 
    mov cx, 0

    ;NORMAL
    call captura

;ATOI /caracter - '0' * 10^pos
atoi: 

    .loop: cmp byte[edx], ' '
           jz .avanzar
           cmp byte[edx], '-'
           jz .negativo
           call potencia
           subt edx, '0'
           mul edx, ebx
    
    .neg: neg edx
    
    .avanzar: inc edx
              cmp byte[edx], 0
              jz .salir
              jmp .loop

    .salir: ret

;POTENCIA: 
    .loop:
    mul 10, 

;ITOA
itoa:


; CAPTURAR
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

    