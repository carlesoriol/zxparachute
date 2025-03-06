	if _SJASMPLUS

	        DEVICE ZXSPECTRUM48
            SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
	else
			print pink,"Compiling RPS DUEL\n"
	endif

stack_top:      equ 0xf9ff
				
	include "libs/screen_macros.asm"
	include "libs/key_macros.asm"

				org 0x4000
fons:
	incbin 	"boot.scr"	
fi_fons:
				org 0x8000
inici:				
main:				
				ld sp, 0xFFFF		
				ld de, rpsinterrupt
				call setInterruptTo		
				
				xor a				; posem el marge negre
				out	(0xfe), a ;					
				ld ($5C48), a	

				;call waitkey
				;call waitnokey
				call swap_logo

				ld hl, screen_start		; clear vars
				ld de, screen_start+1
				ld bc, 31
				xor a
				ld (hl), a				
				ldir
																
				call showallandhideforfun
				call hideAll
				call update_screen
				call randomize
												
				ld a, 8
				ld (step_speed), a
				xor a
				ld (playing), a
								
				call update_clock
				call start_machine			
				
main_loop:
				
				
				ld hl, counter
				call inc32counter				
							
				ld a, (step)
				or a
				jr z, main_no_step
					xor a
					ld (step), a
					; every step
					
					ld a,(playing)
					or a
					jr z, step_noplay
						call check_parachute_saved
						call heli_blades	
						call shark_move
						call move_parachutes
						call add_parachute_if_possible
					
step_noplay:	
					call clock_keys
									
main_no_step:	
			
				ld a, (second_update)
				or a
				jr z, main_no_second
					xor a
					ld (second_update), a
					; every second
					ld a,(playing)
					or a
					jr z, second_noplay
						call start_shark_if_need					
second_noplay:	
					call update_clock
				
main_no_second:		
				
				ld a,(playing)
				or a
				jr z, main_noplay
					
					call parachute_keys	
					jr main_cont

main_noplay:
				call update_clock_dots		
				
				ld a, (counter+1)
				and 1				
				jr nz, anim_buttons_2
					
					ld c, PAPER_BLACK | YELLOW | BRIGHT
					ld a, low i_button_a
					call IImageAttributes
					ld c, PAPER_BLACK | BLACK | BRIGHT
					ld a, low i_button_b
					call IImageAttributes
					jr fi_anim_buttons
					
anim_buttons_2:
					ld c, PAPER_BLACK | BLACK | BRIGHT
					ld a, low i_button_a
					call IImageAttributes
					ld c, PAPER_BLACK | YELLOW | BRIGHT
					ld a, low i_button_b
					call IImageAttributes
				
fi_anim_buttons:

				ld b, KEYSEG_ASDFG
				ld d, KEY_A
				call checkkey
				jr z, game_keys_cont
					xor a
					ld (game), a					
					call start_game
					ld a, 1
					ld (i_gamea), a					
					call move_parachute_sound
			
game_keys_cont:
			
				ld b, KEYSEG_MNB
				ld d, KEY_B
				call checkkey
				jr z, game_keys_cont2
					ld a, 1
					ld (game), a	
					call start_game
					ld a, 1
					ld (i_gameb), a
					call move_parachute_sound
			
game_keys_cont2:

	
					
main_cont:
				call update_screen														
				
				ld b, KEYSEG_ZXCV
				ld d, KEY_C
				call checkkey
				jp	nz, main
				
				ld b, KEYSEG_ZXCV
				ld d, KEY_X
				call checkkey
				jp	z, main_loop
				
end_main_return:
				rst 0			; reset on exit



				
swap_logo: 
				ld hl, attributes_start
				ld de, logo
				ld bc, attributes_size
				
				ex hl, de
				ldir
				//call swap_memory
				
				ret

; hl starting pos, b len
; move bytes
; modifies de, hl, a, b
scroll_bytes:
				ld d,h
				ld e,l
scroll_bytes_loop:
				dec de
				ld a,(de)
				ld (hl), a	
				dec hl			
				djnz scroll_bytes_loop
				ld (hl), 0
				ret



; column in a
add_parachute:
				ld hl, i_parachute_1_1
				cp 1
				jr nz, $+5
					ld hl, i_parachute_2_1
				cp 2
				jr nz, $+5
					ld hl, i_parachute_3_1
				
				ld (hl), 1

				call move_parachute_sound

				ld hl, num_parachutes
				inc (hl)

				ret

; a= current row
add_parachute_if_possible:
				ld a, (max_parachutes)
				ld b, a
				ld a, (num_parachutes)
				cp b
				ret nc				
				

				call random
				cp 0xc0
				ret c

				ld a, (parachute_step_index)
				and %11
				cp %11
				ret z

				call add_parachute

				ret

parachute_saved:				
				ld hl,(score)
				inc hl
				ld (score),hl

				; limit score = 1000
				ld bc, 0x3e8
				sbc hl, bc
				jr nz, parachute_saved_not1000				
					ld (score),hl
parachute_saved_not1000:

				; The following routine divides hl by c and places the quotient in hl and the remainder in a


				ld hl,(score)				
				ld a, l
				;sub a, 4
				;add a,18
				add a, 14
				ld l, a				

				ld c, 18
				call div_hl_c

				inc hl
				ld a, l
				cp 6
				jr c, parachute_saved_max6_cont
					ld a, 6
parachute_saved_max6_cont:	
				ld (max_parachutes), a

				call update_clock
				call update_screen

				ld hl, num_parachutes
				dec (hl)

				ret

check_parachute_saved:
				
				ld a,( i_boat_left )
				or a
				jr z, check_parachute_saved_middle
					ld a,( i_parachute_1_7 )
					or a
					ret z
					call parachute_rescued_sound
					xor a
					ld (i_parachute_1_7), a
					jr parachute_saved

check_parachute_saved_middle:
				ld a,( i_boat_middle)
				or a
				jr z, check_parachute_saved_right
					ld a, (i_parachute_2_6)
					or a
					ret z
					call parachute_rescued_sound
					xor a
					ld (i_parachute_2_6), a
					jr parachute_saved
				
check_parachute_saved_right:
					ld a,( i_parachute_3_5 )
					or a
					ret z
					call parachute_rescued_sound
					xor a
					ld (i_parachute_3_5), a
					jr parachute_saved
				

move_parachutes:
				ld a, (parachute_step_index)			
				inc a
				cp %11
				jr nz, moveparachutes_cont
					xor a
moveparachutes_cont:
				ld (parachute_step_index), a				
				or a
				jr nz, move_parachutes_row2		
					ld hl, i_parachute_1_1
					ld b, 7
					call checksum8
					call nz, move_parachute_sound		

					ld a, (i_parachute_1_7)
					or a
					jr z, move_parachutes_row1_cont
						xor a
						ld (i_parachute_1_7), a
						ld c, low i_manwater_3 - 1 
						call man_lost
move_parachutes_row1_cont:
					ld hl, i_parachute_1_7
					ld b, 6			
					call scroll_bytes					
					
					jr move_parachutes_end



move_parachutes_row2:
				cp 1
				jr nz, move_parachutes_row3
					ld hl, i_parachute_2_1
					ld b, 6
					call checksum8
					call nz, move_parachute_sound		

					ld a, (i_parachute_2_6)
					or a
					jr z, move_parachutes_row2_cont
						xor a
						ld (i_parachute_2_6), a
						ld c, low i_manwater_2 - 1 
						call man_lost
move_parachutes_row2_cont:
					ld hl, i_parachute_2_6
					ld b, 5				
					call scroll_bytes
					jr move_parachutes_end



move_parachutes_row3:
				cp 2
				jr nz, move_parachutes_end
					ld hl, i_parachute_3_1
					ld b, 5
					call checksum8
					call nz, move_parachute_sound	

					ld a, (i_parachute_3_5)
					or a
					jr z, move_parachutes_row3_cont
						xor a
						ld (i_parachute_3_5), a
						ld c, low i_manwater_1 - 1 
						call man_lost

move_parachutes_row3_cont:
					ld hl, i_parachute_3_5
					ld b, 4				
					call scroll_bytes	
					
move_parachutes_end:

				ret

show_lives:
				ld a, (lives)
				or a
				ret z
				
				ld a, 1
				ld (i_miss), a
				
				ld a,(lives)
				ld b,a
			
show_lives_loop:	
				push bc
					ld a, low i_live_3+1	; i_screen is align 256 so low byte of the pointer is also the index
					sub b
					call showImage
				pop bc
				djnz show_lives_loop
							
				
				ret

start_live:
				xor a
				ld (shark_walk_pos), a	
				call show_lives
					
				xor a 
				ld (step_counter), a
				ld (step), a
			
				ret

start_machine:
				call hideAll

				ld a, 1												
				ld (i_monkey), a
				ld (i_heli), a
				ld (i_heli_blade_front), a				
				ld (i_heli_blade_back), a				
				ld (i_digit_1), a
				ld (i_digit_2), a
				ld (i_digit_separator), a				
				ld (i_digit_3), a				
				ld (i_digit_4), a				
				ld (i_boat_middle), a
				ld (boatpos), a
				
				xor a
				ld (i_am), a

				call show_buttons


				ret


hide_buttons:	ld c, PAPER_BLACK | BLACK | BRIGHT				
				jr show_buttons_i
show_buttons:	ld c, PAPER_BLACK | YELLOW | BRIGHT
show_buttons_i:	ld a, low i_button_a
				call IImageAttributes				
				ld a, low i_button_b
				call IImageAttributes
				ret

start_game:
				call hideAll
				call hide_buttons
				
				ld a, 1												
				ld (i_monkey), a
				ld (i_heli), a
				ld (i_heli_blade_front), a				
				ld (i_heli_blade_back), a				
				ld (i_digit_1), a
				ld (i_digit_2), a
				ld (i_digit_3), a				
				ld (i_boat_middle), a
				ld (max_parachutes), a

				ld (playing), a				
				ld (boatpos), a
				
				ld hl,0
				ld (score), hl
				ld (frame_counter), hl
				ld (frame_counter+2), hl
				ld (counter), hl
				ld (counter+2), hl
				
				xor a
				ld (lives), a
				ld (i_am), a
				ld (i_pm), a
				ld (i_digit_separator), a
				ld (num_parachutes), a				
				
				call start_live
				ret		
				
		
man_lost:				
				call man_overboard
			
				ld a,(lives)
				inc a
				ld (lives), a
			
				cp 3				
				jr nz, man_lost_not_last
				xor a
				ld (playing), a
				call show_lives
				ret

man_lost_not_last:
				ld hl, num_parachutes
				dec (hl)

				call start_live
				ret
				
;modifies a
hide_sharks:
			xor a
			ld (i_shark_1), a
			ld (i_shark_2), a
			ld (i_shark_3), a
			ld (i_shark_4), a
			ld (i_shark_5), a
			ret
				

; delays 50s of seconds
; bc=delay time
; 50 = 1s, 3000 = 1m
delay50s:		ld	hl, (frame_counter)
				add hl, bc
				ld d, h
				ld e, l
				
delay50s_loop:
				;halt		; at least 1 frame = 1/50s
				push hl				
				push de
				call parachute_keys				
				call update_screen
				pop de
				pop hl
				
				ld	hl, (frame_counter)
				;and a
				sbc hl, de
				jp m, delay50s_loop

				ret


man_overboard_beep:
				ld bc, 5
				call delay50s	

				ld a, (man_overboard_entry)
				or a
				jr z, man_overboard_beep_regular
					call parachute_lost_sound
					call parachute_lost_sound
					call parachute_lost_sound
					call parachute_lost_sound

					xor a
					ld (man_overboard_entry), a
					ret
					
man_overboard_beep_regular:					
				call parachute_lost_sound
				
				ret

; c = start position	
man_overboard:
				call hide_sharks
				ld a, c
				ld (man_overboard_position), a
				ld a, 1
				ld (man_overboard_entry), a
		
man_overboard_loop:	
				; Mostrem  tauró
				ld a, (man_overboard_position)
				cp low i_manwater_1 - 1
				call nz, showImage
				; Mostrem paracaigudista				
				inc a
				call showImage
				
				call update_screen
				call man_overboard_beep

				ld a, (man_overboard_position)			; extra delay last pos
				cp low i_shark_5 - 1
				jr nz, man_overboard_nofinal
					ld bc, 15*3
					call delay50s
				
				
man_overboard_nofinal:
								
				; Amaguem tauró
				ld a, (man_overboard_position)
				cp low i_manwater_1 - 1
				call nz, hideImage
				; Amaguem paracaigudista				
				inc a
				call hideImage								
				inc a
				ld (man_overboard_position), a
				cp low i_manwater_6 + 1
				jr nz, man_overboard_loop
				
					call parachute_lost_sound
					call parachute_lost_sound
					call parachute_lost_sound
					call parachute_lost_sound


				ret

				

; called every second
start_shark_if_need:

				ld a, (shark_walk_counter)
				inc a
				ld (shark_walk_counter), a
				cp 7
				
				ret nz
				
				xor a
				ld (shark_walk_counter), a
				ld a, low i_shark_1				; low byte pointer is index images aligned to 256 
				ld (shark_walk_pos), a
				call showImage
				xor a
				ld (shark_walk_delay), a

				ret
	
shark_move:
				ld a,(shark_walk_pos)			; is shark moving
				or a			
				ret z							; return if not
				
				ld a, (shark_walk_delay)		; move once every 4 steps
				inc a
				ld (shark_walk_delay), a
				cp 4
				ret nz							; return if not				
				xor a
				ld (shark_walk_delay), a		; reset move delay counter
				
				ld a,(shark_walk_pos)
				call hideImage
				inc a
				inc a
				cp low i_shark_5+2				; low byte pointer is index images aligned to 256 
				jr nz, shark_move_next
					xor a
					ld (shark_walk_pos), a
					ret
					
shark_move_next:
					ld (shark_walk_pos), a
					call showImage
									
			ret

heli_blades:
				ld a, (last_heli)
				inc a				
				ld (last_heli), a
				
				ld b, a
				
				rra
				and 1
				ld (i_heli_blade_back), a
				
				ld a, b
				dec  a
				rra
				and 1
				ld (i_heli_blade_front), a								
				
				ret


moveright:
			ld a, (boatpos)
			cp 2
			ret z		; we are max right just return
			inc a
			
			jr boat_repos
				
moveleft:
			
			ld a, (boatpos)
			or a
			ret z		; we are max left just return
			dec a		
		
boat_repos:	
		
			ld (boatpos), a
			ld b, a
				xor a
				ld (i_boat_left),a
				ld (i_boat_right),a
				ld (i_boat_middle),a
			ld a,b 
			
			ld hl, i_boat_left
			add l
			ld l, a 
			ld a, 1
			ld (hl), a			
			
			ret
					

showallandhideforfun:
	
				call hideAll
				call update_screen
				halt
				nop
				
			
				ld a, 1
slowshowAll_loop:
				push af
				call showImage
				call update_screen
				halt
				nop				
				
				pop af
				inc a
				cp number_of_images
				jr nz, slowshowAll_loop
				
				ret


update_time_int:	

				ld hl, time_50s
				ld a, (time_second)
				ld b, a
				call update_time
				
				ld a, (time_second)
				cp b
				ret z
				ld a, 1
				ld (second_update), a

				ret				


rpsinterrupt:
			
				ld hl, frame_counter
				call inc32counter
				call update_time_int		
			
step_counter_interrupt:
				ld a, (step_speed)
				ld b, a
				ld a, (step_counter)				
				
				cp b
				jr nz, step_counter_nostep
					ld a, 1
					ld (step), a				
					xor a
					ld (step_counter), a
					jr step_counter_segueix
step_counter_nostep:
				inc a
				ld (step_counter), a
				
step_counter_segueix:
			
				ret


				

counter:		defw	0		; global loop counter (useless?)
				defw	0

frame_counter:	defw	0		; global frame counter every 50s
				defw	0

playing			defb	0		; game running 0 = menu, 1 = playing

time_50s:		defb 	0		; time structure
time_second:	defb 	0
time_minute:	defb 	0
time_hour:		defb 	0

score:			defw	0
lives:			defb	0
boatpos:		defb	0
game:			defb 	0

left_debounce:	defb	0
right_debounce:	defb	0

last_heli:		defb	0

shark_walk_pos:		defb	0
shark_walk_delay:	defb	0
shark_walk_counter:	defb	0


step:			defb	0
step_counter:	defb	0
step_speed:		defb	0	

second_update:	defb 0
man_overboard_position:	defb 0	; -1
man_overboard_entry:	defb 0

max_parachutes:	defb	0

num_parachutes:	defb	0
				defb	0


parachute_step_index:	defb	0

gamea_highcore:	defw 0
gameb_highcore:	defw 0

useloader:		equ 1


	include "parachute_lcd.asm"
	include "parachute_keys.asm"
	include "parachute_misc.asm"
	include "parachute_screen.asm"
	include "parachute_logo.asm"
	include "parachute_screen_lib.asm"
	include "parachute_digits.asm"
	include "parachute_clock.asm"
	include "parachute_sounds.asm"

	include 'libs/random_lib.asm' 
	include 'libs/math_lib.asm' 
	include 'libs/sound_lib.asm' 


	include 'libs/interrupt_lib.asm' ; always include last line or before org	

fi:

	if _SJASMPLUS
	
		SAVEBIN "bin/parachutecode.bin", inici, fi-inici
		SAVEBIN "bin/screen.bin", fons, fi_fons- fons
    	
		SAVESNA "bin/parachute.sna", inici

		;SAVETAP "bin/parachutecode.tap",HEADLESS,inici, fi-inici
		S;AVETAP "bin/screen.tap",HEADLESS,fons, fi_fons- fons

		;DISPLAY "Code:  ", code_fi - code_inici
		;DISPLAY "Libs:  ", libs_fi - libs_inici
		;DISPLAY "Data:  ", data_fi - data_inici
		DISPLAY "Pantalla: ", fi_fons - fons
		DISPLAY "Codi: ", fi - inici
		DISPLAY "Total: ", (fi - inici) + (fi_fons - fons)

		;include	 libs/tap_lib.asm
		;MakeTape ZXSPECTRUM48, "rpsduel.tap", "walk", inici, fi-inici, inici

	else
		run 0x8000
	endif