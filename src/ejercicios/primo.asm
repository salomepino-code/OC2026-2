
primo: 
cmp ebx, 2
je .primo
jb .noPrimo

mov ecx, 2

.loop: mov edx, 0
       mov eax, ebx
       div ecx
       cmp edx, 0
       jz .noPrimo
       inc ecx
       cmp ecx, ebx
       jb .loop
       jmp .primo

.primo: mov al, 1
        ret

.noPrimo: mov al, 0
          ret