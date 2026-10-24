;El registro ESI contiene la dirección inicial de un arreglo de elementos de 32 bits. 
;Escribe las instrucciones necesarias para intercambiar el segundo elemento con el sexto elemento
;utilizando EAX como registro auxiliar.

mov ebx, dword[esi+4]
mov eax, dword[esi+20]

mov dword[esi+4], eax
movdword[esi+20], ebx


;Escribe una subrutina que cuente cuántas veces aparece el carácter 'a' en una cadena terminada en cero.
;- EDX: dirección inicial de la cadena.
;- EAX: cantidad de veces que aparece 'a'.
;- La cadena puede tener cualquier longitud.

cuantasA: 
mov eax, 0

.loop: cmp byte[edx], 'a'
       je .aumentar
       cmp byte[edx], 0
       je .fin
       inc edx
       jmp .loop

.aumentar: inc eax
           inc edx
           jmp .loop

.fin: ret



;Implementa una subrutina que determine si un número entero positivo recibido en EBX es un número perfecto.

;Un número perfecto es aquel cuya suma de divisores positivos menores que él mismo es igual al número. 
;Por ejemplo, 6 es perfecto porque \(1+2+3=6\).
;- Recibe el número en EBX.
;- Devuelve AL = 1 si es perfecto.
;- Devuelve AL = 0 si no es perfecto.

numeroPerfecto:

mov ecx, 1
mov esi, 0

.loop: mov edx, 0
       mov eax, ebx
       div ecx
       cmp edx, 0
       je .multiplo
       inc ecx
       cmp ecx, ebx
       jb .loop
       je .noPerfecto

.multiplo: add esi, ecx
           cmp esi, ebx
           je .perfecto
           jb .loop

.perfecto: mov al, 1
           ret

.noPerfecto: mov al, 0
           ret
           
           