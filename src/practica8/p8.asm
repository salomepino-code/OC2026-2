extern canonical_off
extern canonical_on

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
    global _start

_start:
    mov edx, msg1
    call puts

    mov edx, cadena
    mov ax, lencadena
    mov cx, 0
    call captura
    call mostrar

    mov edx, cadena          
    call mayusculas          
    call mostrar

    call minusculas
    call mostrar

    mov edx, nline
    call puts
    mov eax, 1
    xor ebx, ebx
    int 0x80

; --- MOSTRAR ---
mostrar:
    push edx
    mov edx, msg2
    call puts
    mov edx, cadena
    call puts
    pop edx
    ret

; --- CAPTURA ---
captura:
    push esi
    movzx esi, ax            
.loop:
    call getch
    cmp al, bskey
    je .borrar
    cmp al, ln
    je .salir
    call putchar
    mov byte [edx], al
    inc edx
    inc cx
    cmp cx, si
    je .salir
    jmp .loop
.borrar:
    cmp cx, 0
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
.salir:
    mov byte [edx], 0
    pop esi
    ret

; --- MAYUSCULAS ---
mayusculas:
    push edx
.loop:
    cmp byte [edx], 0
    je .salir
    cmp byte [edx], 'a'
    jb .avanzar
    cmp byte [edx], 'z'
    ja .avanzar
    sub byte [edx], 32
.avanzar:
    inc edx
    jmp .loop
.salir:
    pop edx
    ret

; --- MINUSCULAS ---
minusculas:
    push edx
.loop:
    cmp byte [edx], 0
    je .salir
    cmp byte [edx], 'A'
    jb .avanzar
    cmp byte [edx], 'Z'
    ja .avanzar
    add byte [edx], 32
.avanzar:
    inc edx
    jmp .loop
.salir:
    pop edx
    ret

; ===== PUTCHAR  =====
putchar:
    push eax
    push ebx
    push ecx
    push edx
    lea ecx, [esp+12]        
    mov eax, 4               
    mov ebx, 1               
    mov edx, 1
    int 0x80
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; ===== PUTS =====
puts:
    push eax
    push edx
.loop:
    mov al, [edx]
    cmp al, 0
    je .fin
    call putchar
    inc edx
    jmp .loop
.fin:
    pop edx
    pop eax
    ret

; ===== GETCH =====
getch:
    push ebx
    push ecx
    push edx
    call canonical_off
    push eax
    mov eax, 3               
    mov ebx, 0               
    mov ecx, esp
    mov edx, 1
    int 0x80
    pop eax                  
    push eax
    call canonical_on
    pop eax
    pop edx
    pop ecx
    pop ebx
    ret

; ===== GETCHE =====
getche:
    call getch
    call putchar
    ret