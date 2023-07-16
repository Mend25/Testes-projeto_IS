game_loop:
    mov ah, 01h
    int 16h
    jz machine
    call update_first_bar
    xor al, al
    jmp game_loop

machine:
    call update_second_bar
    call update_ball
    jmp game_loop

reset:
    mov ax, [first_bar_posy]
    mov ax, 100
    mov [first_bar_posy], ax
    mov ax, [second_bar_posy]
    mov ax, 100
    mov [second_bar_posy], ax
    mov ax, [prev_ball_pos_x]
    mov ax, 100
    mov [prev_ball_pos_x], ax
    xor ax, ax
    xor cx, cx
   	xor dx, dx
    mov di, 1 ;flag de sentido x
    mov bp, 200;posição x da bola
    mov bh, 0  ;flag de sentido y
    mov bl, 10  ;posição y da bola
    ;mov [counter], 0
    call game_loop

load_first_bar:
    mov si, flag
    mov dx, [first_bar_posy]
    add dx, 16
    mov [first_bar_posy], dx
    sub dx, 16
    xor cx, cx
	call print_first_bar
    mov dx, [first_bar_posy]
    sub dx, 16
    mov [first_bar_posy], dx
    ret

load_second_bar:
    mov si, flag
    mov dx, [second_bar_posy]
    add dx, 16
    mov [second_bar_posy], dx
    sub dx, 16
    mov cx, 300
	call print_second_bar
    mov dx, [second_bar_posy]
    sub dx, 16
    mov [second_bar_posy], dx
    ret

load_ball:
    mov si, cometa
    mov dh, 0
    mov dl, bl
    add bl, 16
    mov cx, bp
    mov [prev_ball_pos_x] , bp
    add bp, 16
	call print_ball
    sub bl, 16
    sub bp, 16
    ret

print_first_bar:
	lodsb
	mov ah, 0ch
	int 10h
	
	jmp .travel_by_image

    .travel_by_image:
        inc cx
        cmp cx, 16
        jne print_first_bar
        
        xor cx, cx
        inc dx
        cmp dx, [first_bar_posy]
        jne print_first_bar
        
        ret

print_second_bar:
	lodsb
    mov ah, 0ch
	int 10h
	
	jmp .travel_by_image
    .travel_by_image:
        inc cx
        cmp cx, 316
        jne print_second_bar
        
        mov cx, 300
        inc dx
        cmp dx, [second_bar_posy]
        jne print_second_bar
        
        ret

print_ball:
	lodsb
	mov ah, 0ch
	int 10h
	
	jmp .travel_by_image
    .travel_by_image:
        inc cx
        cmp cx, bp
        jne print_ball
        
        mov cx, [prev_ball_pos_x]
        inc dl
        cmp dl, bl
        jne print_ball
        
        ret

update_first_bar:    
    call getchar
    cmp al, 's'
    je .down
    
    cmp al, 'w'
    je .up 

    .down:
        mov ax, [first_bar_posy]
        cmp ax, 180
        jb .move_down
        ret

    .up:
        mov ax, [first_bar_posy]
        cmp ax, 20
        ja .move_up
        ret

    .move_up:
        sub ax, 3
        mov [first_bar_posy], ax
        ret
    
    .move_down:
        add ax, 3
        mov [first_bar_posy], ax
        ret

update_second_bar:
    mov al, bl
    mov ah, 0
    cmp [second_bar_posy], ax
    jb .down_s
    
    cmp [second_bar_posy], ax
    ja .up_s

    .done_s:
        ret

    .up_s:
        mov ax, [second_bar_posy]
        sub ax, 10
        mov [second_bar_posy], ax

        .update_s:
            call clear_screen
            call load_first_bar
            call load_second_bar
            call load_ball

        jmp update_second_bar

    .down_s:
        mov ax, [second_bar_posy]
        add ax, 10
        mov [second_bar_posy], ax
        
        .update_s_:
            call clear_screen
            call load_first_bar
            call load_second_bar
            call load_ball
        
        jmp update_second_bar

update_ball:
    .axis_x:
        cmp bp, 280
        ja .goleft
        cmp bp, 15
        jbe .goright

    .axis_y:
        cmp bl, 180
        ja .goup
        cmp bl, 20
        jbe .godown

    .ball_movement:
        .movement_x:
            cmp di, 1
            je .right_ball
            cmp di, 0
            je .left_ball
            ret

        .movement_y:
            cmp bh, 1
            je .up_ball
            cmp bh, 0
            je .down_ball
            ret

    .goleft:
        mov di, 0
        jmp .axis_y

    .goright:
        ;garante o maior
        xor ax, ax
        mov dl, bl
        mov cl, [first_bar_posy]
        cmp cl, dl
        jbe .case_1
        jmp .case_2

        .collision:
            cmp al, 20
            jbe .change_sense ;ver se bateu na barra esquerda

        ;marca o ponto
        sub bp, 5
        cmp bh, 0
        je .mov_y
        sub bl, 5

        call .update_movement
        
        .continue:
            sub bp, 5
            cmp bh, 0
            je .mov_y
            sub bl, 5

            call .update_movement
            
        call delay1s

        ;jmp reset
        jmp $

        .mov_y:
            add bl, 5
            jmp .continue

    .goup:
        mov bh, 1
        jmp .ball_movement
        
    .godown:
        mov bh, 0
        jmp .ball_movement

    .up_ball:
        sub bl, 10
        jmp .update_movement

    .down_ball:
        add bl, 10
        jmp .update_movement

    .left_ball:
        sub bp, 10
        jmp .movement_y

    .right_ball:
        add bp, 10
        jmp .movement_y
    
    .case_1:
        mov al, bl
        sub al, [first_bar_posy]
        jmp .collision

    .case_2:
        mov al, [first_bar_posy]
        sub al, bl
        jmp .collision

    .change_sense:
        mov di, 1
        call update_score
        jmp .axis_y  

    .update_movement:
        call clear_screen
        call load_first_bar
        call load_second_bar
        call load_ball

        call delay

        ret

getchar:
    mov ah, 0
	int 16h
    ret

put_score:
    mov ah, 0x0e
    mov cl, bl
    mov bl, 0xf
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

update_score:
    mov ax, [counter]
    inc ax
    mov [counter], ax

prints:
    lodsb
    cmp al, 0
    je .done_l
    call put_score
    jmp prints
    
    .done_l:
        ret 

clear_screen:
    mov ah, 0
	mov al, 13h
	int 10h
    call build_score
    ret

delay:
	mov cx, 01h
    mov dx, 0A28h
    mov ah, 86h
    int 15h
    ret

delay1s:
  mov cx, 0fh
  mov dx, 4240h
  mov ah, 86h
  int 15h
  ret

done:
    jmp $
