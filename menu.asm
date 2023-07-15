menu:
    mov ah, 0 
    mov al, 13h
    int 10h

    mov bl, 0xf 
    mov ah, 0eh
    mov bh, 0
    mov bl, 2

    mov si, message1
    call print_loop
    xor ax, ax
    call waitStart


    xor ax, ax

    mov ah, 0 
    mov al, 12h
    int 10h


print_loop:
    lodsb
    cmp al, 0
    je .done
    call putchar
    jmp print_loop

    .done:
        ret


waitStart:
    call getchar_m

    cmp al, 0x0d
    je .done

    cmp al, " "
    je instructions

    jmp waitStart

    .done:
        ret

instructions:
    xor ax, ax
    mov ah, 0 
    mov al, 12h
    int 10h

    xor ax, ax
    xor si, si
    mov si, message2
    jmp .print

    .print:
        lodsb
        cmp al, 0
        je .waitButton
        call putchar
        jmp .print

    .waitButton:
        xor ax, ax

        call getchar_m

        cmp al, " "
        je menu

        jmp .waitButton



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

getchar_m:
    mov ah, 0x00 
    int 16h
    ret
