%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .data
    msg db 'abcdefghijklmnopqrstuvwxyz0123456789', 0xa, 0
    salto db 0xa

    A db 'Antes:',0xa,0
    D db 'Despues:',0xa,0

section .text
    global _start         ; referencia para inicio de programa

_start:
    ; cadena original
    mov edx, msg
    call puts

    ; A)DIRECTO/INMEDIATO
    mov edx, A
    call puts
    mov edx, msg
    call puts

    mov byte [msg], 'Z'    

    mov edx, D
    call puts
    mov edx, msg
    call puts

    ;; B) INDIRECTO/REGISTRO
    mov edx, A
    call puts
    mov edx, msg
    call puts

    mov ebx, msg      
    mov byte [ebx + 23], 'X'

    mov edx, D
    call puts
    mov edx, msg
    call puts

    ; C) BASE + DESPLAZAMIENTO
    mov edx, A
    call puts
    mov edx, msg
    call puts

    mov ebx, msg                      
    mov byte [ebx + 26], '@'    

    mov edx, D
    call puts
    mov edx, msg
    call puts

    ; D) BASE + INDICE
    mov edx, A
    call puts
    mov edx, msg
    call puts

    mov ebx, msg                      
    mov esi, 25                       
    mov byte [ebx + esi], 'Z'

    mov edx, D
    call puts
    mov edx, msg
    call puts

    ;; E) BASE + INDICE + DESPLAZAMIENTO
    mov edx, A
    call puts
    mov edx, msg
    call puts

    mov ebx, msg                      
    mov esi, 10                       
    mov byte [ebx + esi + 5], 'P'     

    mov edx, D
    call puts
    mov edx, msg
    call puts

    ;; F) BASE + INDICE ESCALADO
    mov edx, A
    call puts
    mov edx, msg
    call puts

    mov ebx, msg                     
    mov esi, 4                     
    mov byte [ebx + esi*4 + 3], '%'   

    mov edx, D
    call puts
    mov edx, msg
    call puts

    ; FIN
    mov eax, 1
    mov ebx, 0
    int 0x80