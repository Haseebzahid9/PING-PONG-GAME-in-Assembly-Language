[org 0x0100]
jmp Main 
    ; declarations in memory
Original_Ball_Location: dw 2000 

ball: dw 2000 

pattern_choice: dw 0 

direction_ball: dw 164



left_paddle: dw 640 
right_paddle: dw 798 

Player1_score: dw 0
Player2_score: dw 0

player_1_won: dw 'PLAYER 1 WON!!!!!!!!!!'
player_2_won: dw 'PLAYER 2 WON!!!!!!!!!!'
player_won_length: dw 22
restart_game: dw 'Press r to restart the game or press e to exit the game'
restart_game_length: dw 55

pattern_1: dw 510
pattern_2: dw 550
pattern_3: dw 590


upper_wall: dw 320
lower_wall: dw 3678

Welcome_string: dw 'WELCOME To PING PONG GAME FOR FASTIANS'
Wel_str_len: dw 38

Creators_names: db 'Sami Saeed                   Haseeb Raza            ' 
Cre_names_len: dw 51

; definations of funtions



clrScr: 
	push es
	push di
	push ax
	push cx
	mov ax,0xb800
	mov es,ax
	mov cx,2000 
	cld
	xor di,di ;mov di,0
	mov ax, 0x0720 ;space 
	rep stosw 
	pop cx
	pop ax
	pop di
	pop es

	ret



pause_game:
	push ax
	
	pausing_game_loop:


		mov ah,0h
		int 16h

		cmp ah,0x19 ;'P'
		jne pausing_game_loop

	pause_game_end:
		pop ax
		ret



Welcome:
	push ax
	push cx
	push si
	push es
	push di

	mov ax,0xb800
	mov es,ax
	mov ax,0

	mov ah,0x0B  
	mov cx,[Wel_str_len] 

	mov di,668
	mov si,Welcome_string  

	WEL_LOOP:
		lodsb
		stosw
		loop WEL_LOOP

	pop di
	pop es
	pop si
	pop cx
	pop ax
	ret


  	
	draw_creator:

		push ax
		push cx
		push si
		push es
		push di
	
		mov ax,0xb800
		mov es,ax
		mov ax,0
	
		mov di,1290
		mov si,Creators_names
	
		mov cx,[Cre_names_len]
		mov ah,0x0B
	
		creator_loop:
			lodsb
			stosw
			loop creator_loop
	
	
		pop di
		pop es
		pop si
		pop cx
		pop ax
		ret
	




draw_score:
	push ax
	push es
	push di
	mov ax,0xb800
	mov es,ax
	mov di,170
	mov ax,[Player1_score]
	mov ah,0x07
	add al,0x30
	mov [es:di],ax
	mov di,308
	xor ax,ax
	mov ax,[Player2_score]
	mov ah,0x07
	add al,0x30

	mov [es:di],ax
	pop di
	pop es
	pop ax
	ret



   ; subrotine for delay
	delay:
		push cx
		mov cx,0xffff
		Delay_l1:
			loop Delay_l1
		mov cx,0xffff
		Delay_l2:
			loop Delay_l2
	
		pop cx
		ret




	Printing_boundaries:
		push es
		push di
		push ax
		push cx
	
		mov ax,0xb800
		mov es,ax
	
		std 
		mov di,[lower_wall]
		mov cx,80
		mov ax,0x722D
		rep stosw
	
		cld
		mov di,[upper_wall]
		mov cx,80
		mov ax,0x722D
		rep stosw
	
		pop cx
		pop ax
		pop di
		pop es
		ret


		draw_paddle:
			push ax
			push es
			push di
		
			mov ax,0xb800
			mov es,ax
			xor di,di
		
		
			;printing left paddle
			mov di,[left_paddle]
			sub di,160 ;for printing upper part of paddle
			mov word[es:di],0x047C
			add di,160 ;for printing middle part of paddle
			mov word[es:di],0x047C
			add di,160
			mov word[es:di],0x047C ;for printing lower part of paddle
                        add di, 160
                        mov word[es:di], 0x047c
                      
		
			;printing right paddle
			mov di,[right_paddle]
			sub di,160 ;for printing upper part of paddle
			mov word[es:di],0x097C
			add di,160 ;for printing middle part of paddle
			mov word[es:di],0x097C
			add di,160 ;for printing lower part of paddle
			mov word[es:di],0x097C
                         add di, 160
                        mov word[es:di], 0x097c
                        
		
			pop di
			pop es
			pop ax
			ret	



   

move_paddle:
			push ax
			push dx
			;left paddle movement
			;checking if any key is pressed or not
		
			mov ah,1h
			int 16h
			jz check_right_paddle_movement 
		

			mov ah,0h
			int 16h
			

		
			cmp al,0x70     ; check for p
			jne check_for_w
		

			call draw_ball
			call draw_score
			
			
			call pause_game
		
			check_for_w:
		
			cmp al,0x77 ; check for w
			je move_left_paddle_up
		
			cmp ah,0x1F ;'S'
			je move_left_paddle_down
			jmp check_right_paddle_movement
		
			move_left_paddle_up:
				mov dx,[upper_wall]
				add dx,320 
				cmp word[left_paddle],dx 
				je end_paddle_movement 
				sub word[left_paddle],160 
				jmp end_paddle_movement
		
		
			move_left_paddle_down:
				mov dx,[lower_wall] ;lower wall is pointing end of boundary
				sub dx,478 
				cmp word[left_paddle],dx 
				je end_paddle_movement 
				add word[left_paddle],160 
				jmp end_paddle_movement
		
		
			check_right_paddle_movement:
		
			;right paddle movement
			
			; remember ah will have the ascii of character which is pressed
		
			cmp ah,0x48 ;'up arrow'
			je move_right_paddle_up
		
			cmp ah,0x50 ;'down arrow'
			je move_right_paddle_down
			jmp end_paddle_movement
		
			move_right_paddle_up:
				mov dx,[upper_wall]
				add dx,158 
				add dx,320 
				cmp word[right_paddle],dx 
				je end_paddle_movement 
				sub word[right_paddle],160
				jmp end_paddle_movement
		
		
			move_right_paddle_down:
				mov dx,[lower_wall]
				sub dx,320
				cmp word[right_paddle],dx 
				je end_paddle_movement 
				add word[right_paddle],160 
		
			end_paddle_movement:
			pop dx
			pop ax
			ret


			draw_ball:
				push ax
				push es
				push di
			
				mov ax,0xb800
				mov es,ax
			
				mov di,0
				mov di,[ball] ;di = position of ball
				mov word[es:di],0x0E4F
					
				pop di
				pop es
				pop ax
				ret



				


draw_player_won:
	push bp
	mov bp,sp
	push ax
	push cx
	push si
	push es
	push di
	mov ax,0xb800
	mov es,ax
	xor ax,ax
	mov di,830 ;(5*160)+30
	mov ah,0x07
	mov si,[bp+6];player won string 
	mov cx,[bp+4];player won length
	player_won_loop:
		lodsb
		stosw
		loop player_won_loop

	player_won_end:
	pop di
	pop es
	pop si
	pop cx
	pop ax
	pop bp
	ret 4

draw_restart_exit_option:
	push ax
	push es
	push di
	push si

	mov ax,0xb800
	mov es,ax
	mov di,830
	add di,160
	mov ah,0x07
	mov si,restart_game
	mov cx,[restart_game_length]
	draw_restart_game_loop:
		lodsb
		stosw
		loop draw_restart_game_loop
	restart_game_loop_end:
		pop si
		pop di
		pop es
		pop ax
		ret	






	reset_ball_position:

		push ax
		mov ax,[Original_Ball_Location]
		mov [ball],ax
		pop ax
		ret


	increase_score_count:
		push ax
		push bx
		push dx
		xor dx,dx
		mov bx,160
		mov ax,[ball]
		div bx
		cmp dx,0
		jne player_1_checking
	
		cmp word[direction_ball],164
		je player_1_increment
		cmp word[direction_ball],-156
		je player_1_increment
		mov ax,[Player2_score]
		inc ax
		mov [Player2_score],ax
		call reset_ball_position



		
		player_1_checking:
		xor dx,dx
		mov bx,160
		mov ax,[ball]
		add ax,2
		div bx
		cmp dx,2
		jne end_checking_left_right
		player_1_increment:
		mov ax,[Player1_score]
		inc ax
		mov [Player1_score],ax
		call reset_ball_position
		jmp end_checking_left_right
		
		end_checking_left_right:
			pop dx
			pop bx
			pop ax
			ret




	




move_ball:

    push ax
    push dx

    ; Checking collision with left paddle
left_paddle_check:
    mov ax,[left_paddle]
    add ax,4
    cmp [ball],ax
    jne left_paddle_upper
    add word[direction_ball],8
    jmp boundary_check

left_paddle_upper:
    sub ax,160
    cmp [ball],ax
    jne left_paddle_lower
    add word[direction_ball],8
    jmp boundary_check

left_paddle_lower:
    add ax,320
    cmp [ball],ax
    jne left_lower
    add word[direction_ball],8
    jmp boundary_check

left_lower:
    add ax,160
    cmp [ball],ax
    jne right_paddle_check
    add word[direction_ball],8
    jmp boundary_check

    ; Checking collision with right paddle
right_paddle_check:
    mov ax,[right_paddle]
    sub ax,2
    cmp [ball],ax
    jne right_paddle_upper
    sub word[direction_ball],8
    jmp boundary_check

right_paddle_upper:
    sub ax,160
    cmp [ball],ax
    jne right_paddle_lower
    sub word[direction_ball],8
    jmp boundary_check

right_paddle_lower:
    add ax,320
    cmp [ball],ax
    jne boundary_check
    sub word[direction_ball],8
    jmp boundary_check

right_lower:
    add ax,160
    cmp [ball],ax
    jne boundary_check
    add word[direction_ball],8
    jmp boundary_check

boundary_check:
    mov ax,[direction_ball] ; ax = direction_ball
    mov dx, [ball] ; dx = ball
    add dx,ax ; ball = ball + direction (ball is dx)
    mov ax,[upper_wall]
    add ax,160
    cmp dx,ax
    jge check_bottom

    add word[direction_ball],320
    jmp move_end

check_bottom:
    mov ax,[lower_wall]
    sub ax,160
    cmp dx,ax
    jle move_end

    sub word[direction_ball],320
    jmp move_end

move_end:
    mov ax,[direction_ball]
    add [ball],ax

    pop dx
    pop ax
    ret






Main:

call clrScr
call Welcome
call draw_creator

start:
mov ah, 0
int 16h
cmp ah, 00
je start


main_start:

    mov word[Player1_score],0
	mov word[Player2_score],0

	main_loop:
		call delay
		call delay
		call clrScr




		main_next:
		call Printing_boundaries
		
		;drawing and moving paddle
		call draw_paddle
		call move_paddle
		
		;drawing and moving ball
		call draw_ball
		call move_ball

		
		;drawing score of players
		call draw_score
                
              
		
		call increase_score_count 
		cmp word[Player1_score],5
		jl player2_score_check 
		mov ax,player_1_won ;pushing string 
		push ax
		mov ax,[player_won_length] ;pushing string size
		push ax
		jmp draw_player_won2

		player2_score_check: 
		;again checking score
		cmp word[Player2_score],5 ;i have condition of 5 score
		jl main_loop
		;passing parameters for function to print player 2 won
		mov ax,player_2_won
		push ax
		mov ax,[player_won_length]
		push ax


	draw_player_won2:
		call clrScr
		call draw_player_won 
		call draw_restart_exit_option 
		;checking which key is pressed now
		checker_for_exit_restart_game:
		mov ah,0h
		int 16h
	


		cmp ah,0x13 ;'r' 
		je main_start
		cmp ah,0x12 ;'e' it is to exit game
		jne checker_for_exit_restart_game 

	main_loop_end:


	mov ax,0x4c00
	int 0x21