
				
include "libs/screen_macros.asm"
include "libs/key_macros.asm"

				org 	0x4000

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

				defb	0
				defb	0

parachute0_pos	defb	0
parachute1_pos	defb	0
parachute2_pos	defb	0
parachute3_pos	defb	0
parachute4_pos	defb	0
parachute5_pos	defb	0
parachute6_pos	defb	0
parachute7_pos	defb	0
parachute8_pos	defb	0
parachute9_pos	defb	0

parachute0_step	defb	0
parachute1_step	defb	0
parachute2_step	defb	0
parachute3_step	defb	0
parachute4_step	defb	0
parachute5_step	defb	0
parachute6_step	defb	0
parachute7_step	defb	0
parachute8_step	defb	0
parachute9_step	defb	0


falling_parachutes	defb	0

gamea_highcore	defw 0
gameb_highcore	defw 0

				org 0x4000
fons:
incbin 	"parachute_screen.scr"	

				org 0x5ccb
main:				
				ld sp, 0x8000

				im 1
				
				xor a				; posem el marge negre
				out	(#fe), a ;					
				ld ($5C48), a	

				ld hl, screen_start		; clear vars
				ld de, screen_start+1
				ld bc, 31
				xor a
				ld (hl), a				
				ldir
						
				call swap_logo
								
				call waitnokey
				call waitkey			
				call waitnokey
				
				call swap_logo
				
				
				call showAll
				
				call waitkey			
				call waitnokey
				
				
				call hideAll
				
				call waitkey			
				call waitnokey
				
				
				call showAll
				
				call waitkey			
				call waitnokey
				
				
				
				
				
				
				
				
				
				
				
								
				call showallandhideforfun
												
				ld a, 7
				ld (step_speed), a
				
				call update_clock
				
				ld de, rpsinterrupt
				call setInterruptTo
				
				call start_game
				
		main_loop:
				
				
				ld hl, counter
				call inc32counter				
							
				ld a, (step)
				or a
				jr z, main_no_step
					xor a
					ld (step), a
					; every step
					
					call heli_blades	
					call shark_move
					call clock_keys
									
			main_no_step:	
			

				ld a, (second_update)
				or a
				jr z, main_no_second
					xor a
					ld (second_update), a
					; every second
					
					call start_shark_if_need
					
					call update_clock
				
				main_no_second:		
				
				call update_clock_dots			

				call update_screen							
				
				call parachute_keys

				ld b, KEYSEG_QWERT
				ld d, KEY_Q
				call checkkey
				call nz, add_parachute

				ld b, KEYSEG_ZXCV
				ld d, KEY_Z
				call checkkey
				call nz, man_lost

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
				
				call swap_memory
				
				ret



get_free_parachute:
				
				ld a, 0
				ret

get_random_position:

				ret
				
check_position_used:

				ret

add_parachute:
				
				ret

check_parachute_saved:
	
				ret
				
do_parachute_fall:

				ret

can_parachute_hang_on_palm:

				ret

is_parachute_hang_on_palm:
				ret
				

move_parachute:
				ret

move_parachutes:
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
					ld a, (i_live_3-i_screen+1)
					sub b
					call showImage
				pop bc
				djnz show_lives_loop
							
				
				ret

start_live:
				xor a
				ld (shark_walk_pos), a	
				call show_lives
					
				ret
				
start_game:
				call hideAll
				ld de, start_game_images
				call show_imagelist
								
				ld a, 1
				ld (boatpos), a
				
				ld hl,0
				ld (score), hl
				ld (frame_counter), hl
				ld (frame_counter+2), hl
				ld (counter), hl
				ld (counter+2), hl
				
				ld a, 0
				ld (lives), a
				
				ld a, 1
				ld (max_parachutes), a
				
				ld a,1
				ld (playing), a
				
				call start_live
				ret

start_game_images: 
				defw 	i_monkey
				defw	i_heli, i_heli_blade_front
				defw	i_am, i_digit_1, i_digit_2, i_digit_3, i_digit_4
				defw	i_gamea, i_boat_middle
				defw	0
					
				
; de pointer to image list
show_imagelist:
				ld a, (de)							
				or a	
				ret z
				
				push de
				call showImage
				pop de

				inc de
				
				jr show_imagelist
				
				
		
man_lost:
				call man_overboard
			
				ld a,(lives)
				cp 3
				jr z, man_lost_last
					inc a
					ld (lives), a
			man_lost_last:	
			
				call start_live
				ret
				

hide_sharks:
				ld a, (i_shark_1 - i_screen)
		hide_sharks_loop:
				push af
					call hideImage
				pop af
				add a, 2
				
				cp i_shark_5 - i_screen
				jr nz, hide_sharks_loop
				ret

; delays 50s of seconds
; bc=delay time
; 50 = 1s, 3000 = 1m
delay50s:		ld	hl, (frame_counter)
				add hl, bc
				ld d, h
				ld e, l
				
		delay50s_loop:
				halt		; at least 1 frame = 1/50s
				nop
				ld	hl, (frame_counter)
				and a
				sbc hl, de
				jp m, delay50s_loop

				ret


man_overboard_beep:
				ld a, (man_overboard_entry)
				or a
				jr z, man_overboard_beep_regular
					ld bc, 15 * 3
					call delay50s				
					xor a
					ld (man_overboard_entry), a
					ret
					
			man_overboard_beep_regular:	
				ld bc, 15
				call delay50s
				
				ret
				
man_overboard:
				call hide_sharks
				ld a, i_manwater_1 - i_screen - 1
				ld (man_overboard_position), a
				ld a, 1
				ld (man_overboard_entry), a
		
		man_overboard_loop:	
				; Mostrem  tauró
				ld a, (man_overboard_position)
				cp i_manwater_1 - i_screen - 1
				call nz, showImage
				; Mostrem paracaigudista
				ld a, (man_overboard_position)
				inc a
				call showImage
				
				call man_overboard_beep
				ld a, (man_overboard_position)
				cp i_shark_5 - i_screen - 1
				jr nz, man_overboard_nofinal
					ld bc, 15*3
					call delay50s
				
			man_overboard_nofinal:
								
				; Amaguem tauró
				ld a, (man_overboard_position)
				cp i_manwater_1 - i_screen - 1
				call nz, hideImage
				; Amaguem paracaigudista
				ld a, (man_overboard_position)
				inc a
				call hideImage
				
				ld a, (man_overboard_position)
				inc a
				inc a
				ld (man_overboard_position), a
				cp i_manwater_6 - i_screen + 1
				jr nz, man_overboard_loop
				

				ret

				

; called every second
start_shark_if_need:

				ld a, (shark_walk_counter)
				inc a
				ld (shark_walk_counter), a
				cp 10
				
				ret nz
				
				xor a
				ld (shark_walk_counter), a
				ld a, 44
				ld (shark_walk_pos), a
				call showImage
				xor a
				ld (shark_walk_delay), a

				ret
	
shark_move:
				ld a,(shark_walk_pos)
				or a
				ret z
				
				ld a, (shark_walk_delay)
				inc a
				ld (shark_walk_delay), a
				cp 4
				ret nz
				
				xor a
				ld (shark_walk_delay), a				
				
				ld a,(shark_walk_pos)
				call hideImage
				
				ld a,(shark_walk_pos)
				inc a
				inc a
				cp 54
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
				and %11
				ld (last_heli), a
				
				ld b, a
				
				rra
				and 1
				ld (i_heli_blade_back), a
				
				ld b, a
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
				halt
				nop
				halt
				nop
			
				ld a, 1
		slowshowAll_loop:
				ld c, a
				call showImage
				halt
				nop
				
				ld a, c
				inc a
				cp number_of_images
				jr nz, slowshowAll_loop
				
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

include "parachute_lcd.asm"
include "parachute_keys.asm"
include "parachute_misc.asm"
include "parachute_screen.asm"
include "parachute_logo.asm"
include "parachute_screen_lib.asm"
include "parachute_digits.asm"
include "parachute_math.asm"
include "parachute_clock.asm"


include 'libs/interrupt_lib_16k.asm' ; always include last line or before org	

run main

