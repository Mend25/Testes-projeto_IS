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
        cmp cx, bp;alterar
        jne print_ball
        
        mov cx, [prev_ball_pos_x];alterar
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
        cmp ax, 0
        ja .move_up
        ret
    .move_up:
        sub ax, 5
        mov [first_bar_posy], ax
        ret
    
    .move_down:
        add ax, 5
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
        sub ax, 5
        mov [second_bar_posy], ax
        .update_s:
            call clear_screen
            call load_first_bar
            call load_second_bar
            call load_ball
            call build_score
            call prints
            ;call put_score

        jmp update_second_bar
    .down_s:
        mov ax, [second_bar_posy]
        add ax, 5
        mov [second_bar_posy], ax
        
        .update_s_:
            call clear_screen
            call load_first_bar
            call load_second_bar
            call load_ball
            call build_score
            call prints
            ;call put_score
        
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
        cmp bl, 0
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
        call .update_movement
        sub bp, 5
        call .update_movement
        call delay1s
        jmp reset
    
    .goup:
        mov bh, 1
        jmp .ball_movement
    .godown:
        mov bh, 0
        jmp .ball_movement
    .up_ball:
        sub bl, 5
        jmp .update_movement
    .down_ball:
        add bl, 5
        jmp .update_movement
    .left_ball:
        sub bp, 5
        jmp .movement_y
    .right_ball:
        add bp, 5
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
        jmp .axis_y  
    .update_movement:
        call clear_screen
        call load_first_bar
        call load_second_bar
        call load_ball

        call build_score
        call prints

        call delay

        
        ;call put_score
        ret
getchar:
    mov ah, 0
	int 16h
    ret
put_score:
    mov ah, 0x0e
    int 10h
    ret
prints:
    lodsb
    cmp al, 0
    je .done_l
    call put_score
    jmp prints
    
    .done_l:
        ret 

build_score:
    mov si, score_name
    call prints
    call prints


    mov ax, counter
    add ax, '0'
    mov si, ax
    call prints

    ret

clear_screen:
    mov ah, 0
	mov al, 13h
	int 10h
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
