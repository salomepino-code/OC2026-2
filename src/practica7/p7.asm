%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

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
    call puts

    mov edx, cadena 
    mov bx, lencadena - 1
    mov ecx, 0

    call captura
 
    mov edx, msg2
    call puts
    mov edx, cadena
    call puts

    mov edx, cadena
    call atoi

    mov edx, salida
    mov ecx, 16

    add eax, 123
    call itoa
    mov esi, edx

    mov edx, msg3
    call puts 
    mov edx, esi
    call puts

    mov eax, 1
    mov ebx, 0
    int 0x80


;ATOI 
atoi: 

    push ebx
    push ecx
    push edx
    mov eax, 0
    mov ebx, 1

.espacios:
        mov cl, [edx]
        cmp cl, ' '
        je .saltar
        cmp cl, 9                ; tabulador
        jne .signo
    .saltar:
        inc edx
        jmp .espacios

    .signo:
        cmp cl, '-'
        jne .mas
        mov ebx, -1
        inc edx
        jmp .digitos
    .mas:
        cmp cl, '+'
        jne .digitos
        inc edx

    .digitos:                    ; resultado = resultado * 10 + dígito
        movzx ecx, byte [edx]
        cmp cl, '0'
        jb .fin                  
        cmp cl, '9'
        ja .fin
        sub ecx, '0'
        imul eax, eax, 10
        add eax, ecx
        inc edx
        jmp .digitos

    .fin:
        imul eax, ebx            ; aplicar signo una sola vez
        pop edx
        pop ecx
        pop ebx
        ret

; ITOA: 

itoa:
    push ebx
    push esi
    push ecx

    lea esi, [edx + ecx - 1]     ; última posición del buffer
    mov byte [esi], 0            

    mov ebx, 0                
    test eax, eax
    jns .conv
    neg eax
    mov ebx, 1

    .conv:
        mov ecx, 10            
    .div:                       
        xor edx, edx
        div ecx                  
        add dl, '0'
        dec esi
        mov [esi], dl
        test eax, eax
        jnz .div

        test ebx, ebx
        jz .fin
        dec esi
        mov byte [esi], '-'

    .fin:
        mov edx, esi             ; retorno: inicio de la cadena
        pop ecx
        pop esi
        pop ebx
        ret

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

    