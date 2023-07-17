final_screen:
    mov ah, 0 
    mov al, 13h
    int 10h

    mov bl, 0xf 
    mov ah, 0eh
    mov bh, 0
    mov bl, 2
    ;entra na tela final

    mov si, message3
    call print_loop

    xor ax, ax
    call build_score

    xor ax, ax
    mov si, message4
    call print_loop

    xor ax, ax
    call wait_command


    xor ax, ax

    ;volta pro menu
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


put_score:
    mov ah, 0x0e
    mov cl, bl
    mov bl, 0xa
    int 10h
    mov bl, cl
    ret

build_score:
    mov si, score_name
    call prints

    mov ax, [counter]
    mov dx, 0
    mov cx, 10
    div cx
    add ax, '0'

    call put_score

    sub ax, '0'
    mov ax, dx
    add ax, '0'
    call put_score

    ret

prints:
    lodsb
    cmp al, 0
    je .done_l
    call put_score
    jmp prints

    .done_l:
        ret 


wait_command:
    call getchar_m

    cmp al, 0x0d
    je .done

    jmp wait_command

    .done:
        ret



putchar:
    mov ah, 0x0e
    int 10h
    ret

getchar_m:
    mov ah, 0x00 
    int 16h
    ret
