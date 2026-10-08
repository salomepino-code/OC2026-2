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

    mov edx, cadena
    mov cx, 0
    mov ax, lencadena
    mov ah, ln

    ; --- IMPRIMIR CADENA  ---
    mov ebx, msg1        
    call puts   
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
        call puts     
        mov eax, 1            ; Llamada sys_exit
	    xor ebx, ebx          ; return 0
        int 0x80              ; Fin de programa

   
    captura:  push ax
              call getche
              cmp al, bskey
              jne .sig
              call borrar
    
    .sig:   cmp al, ah
            jz mostrar
            mov byte[edx], al
            inc edx
            inc cx
            cmp cx, ax
            jz mostrar
            jmp captura

            pop ax
            ret

    borrar:
        push ax 
        mov al,0x8
        call putchar    
        mov al,' '
        call putchar
        mov al,0x8
        call putchar   
        pop ax
        ret 