son_time times 10 db 0 
nota times 10 db 0


_atualiza_son:

	push ax

	mov si, son_time
	lodsw
	cmp ax, 0          ; existe som para ser carregado?
	jbe .fim           ; se não acabe a função
	
	mov di, son_time
	dec ax	
	stosw

	mov si, nota
	lodsw
	call _play_note

	pop ax

	ret

	.fim:
		call _stop_note
		pop ax
		ret
	


_play_note:	; toca nota armazenada em ax
	
	push ax
	push dx

	mov dx, ax           
	mov al, 0b6h
	out 43h, al
	mov ax, dx
	out 42h, al
	mov al, ah
	out 42h, al

	; start the sound
	in al, 61h
	or al, 3h
	out 61h, al
	
	pop dx 
	pop ax

	ret

_stop_note:           ; para de tocar a nota

	push ax

	in al, 61h
	and al, 0fch
	out 61h, al	

	pop ax
	ret

_delay_print:            ; pequena rotina de tempo
	inc dx
	mov cx, 0
		.time:
			inc cx
			cmp cx, 7000
			jne .time
	cmp dx, 1000	
	jne _delay_print
	ret
