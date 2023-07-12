org 0x7c00
jmp _start

message1 db "1. Pressione enter para começar", 0
message2 db "2. Pressione Y para sair", 0

_start:
    xor ax, ax
    xor si, si
    xor bx, bx
    mov ah, 0x0e
    mov bl, 0xf
    mov si, message1
    call print_loop
    call endl
    
    xor si, si
    mov si, message2
    call print_loop
    

    call done
    

print_loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp print_loop
    
    .done:
        ret    

endl:
    mov ah, 0x0a
    call putchar
    mov ah, 0x0d
    call putchar
    ret

done:
    jmp $

times 510 - ($ - $$) db 0
dw 0xaa55
