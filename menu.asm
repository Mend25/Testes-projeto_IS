org 0x7c00
jmp _start

message1 db "Press enter to start", 0
message2 db "Instructions", 0

_start:
    xor ax, ax
    xor si, si
    xor bx, bx
    
    mov ah, 0
    mov al, 12h
    int 10h
    
    mov bl, 0xf
    
    mov ah, 0eh
    mov bh, 0
    mov bl, 2
    
    mov ah, 0x0e
    mov si, message1
    call print_loop
    xor ax, ax
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
    
putchar:
    mov ah, 0x0e
    int 10h
    ret
    
done:
    jmp $

times 510 - ($ - $$) db 0
dw 0xaa55
