
				
include "../libs/screen_macros.asm"
include "../libs/key_macros.asm"

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

parachute1_pos	defb	0
parachute2_pos	defb	0
parachute3_pos	defb	0
parachute4_pos	defb	0
parachute5_pos	defb	0

parachute1_step	defb	0
parachute2_step	defb	0
parachute3_step	defb	0
parachute4_step	defb	0
parachute5_step	defb	0

falling_parachutes	defb	0

				org 0x8000
main:				
				xor a				; posem el marge negre
				out	(#fe), a ;					
				ld ($5C48), a	

				ld de, attributes_start		; blit image
				ld hl, logo
				ld bc, attributes_size
				ldir				
				
				ld de, screen_start		; blit image
				ld hl, fons
				ld bc, screen_size 
				ldir
								
				call waitnokey
				call waitkey			
				call waitnokey
				
				ld de, attributes_start	; blit game attribs
				ld hl, fons + screen_size
				ld bc, attributes_size 
				ldir
				
								
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
				im 1
				
				ld a,7
				out	(#fe), a ;					
				ld ($5C48), a				
				
				ret

update_clock_dots:
				ld a, (time_50s)
				ld hl, img_digit_separator
				cp 25				
				jp c, showImage_item
				jp hideImage_item
				
				
update_clock:
				ld a, (time_second)
				ld d, a
				ld e, 10
				call div_d_e		; reminder in a
				
				ld bc,#1850
				call pinta_digit
				
				ld a, (time_second)
				ld d, a
				ld e, 10
				call div_d_e		; quotient in d 
				ld a, d
				
				ld bc,#1840
				call pinta_digit
				
				ld a, (time_minute)
				ld d, a
				ld e, 10
				call div_d_e		; reminder in a
				
				ld bc,#1828
				call pinta_digit
				
				ld a, (time_minute)
				ld d, a
				ld e, 10
				call div_d_e		; quotient in d 
				ld a, d
				
				ld bc,#1818
				call pinta_digit
				
				
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
				
				ld hl,img_miss
				call showImage_item
				
				ld a,(lives)
				ld b,a
			
			show_lives_loop:	
				push bc
					ld a,8
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

				ld hl, img_monkey
				call showImage_item
				
				ld hl, img_heli
				call showImage_item				
				ld hl, img_heli_blade_front
				call showImage_item
				ld hl, img_heli_blade_back
				call showImage_item
				
				ld hl, img_am
				call showImage_item
				ld hl, img_digit_1				
				call showImage_item
				ld hl, img_digit_2	
				call showImage_item
				ld hl, img_digit_separator
				call showImage_item
				ld hl, img_digit_3				
				call showImage_item
				ld hl, img_digit_4				
				call showImage_item
				ld hl, img_gamea
				call showImage_item
								
				ld hl, img_boat_middle
				call showImage_item
								
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
				ld a, 44
		hide_sharks_loop:
				push af
					call hideImage
				pop af
				inc a
				inc a
				
				cp 54
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
				ld a, 42
				ld (man_overboard_position), a
				ld a, 1
				ld (man_overboard_entry), a
		
		man_overboard_loop:	
				; Mostrem  tauró
				ld a, (man_overboard_position)
				cp 42 
				call nz, showImage
				; Mostrem paracaigudista
				ld a, (man_overboard_position)
				inc a
				call showImage
				
				call man_overboard_beep
				ld a, (man_overboard_position)
				cp 52
				jr nz, man_overboard_nofinal
					ld bc, 15*3
					call delay50s
				
			man_overboard_nofinal:
								
				; Amaguem tauró
				ld a, (man_overboard_position)
				cp 42
				call nz, hideImage
				; Amaguem paracaigudista
				ld a, (man_overboard_position)
				inc a
				call hideImage
				
				ld a, (man_overboard_position)
				inc a
				inc a
				ld (man_overboard_position), a
				cp 54
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
				
			heli_blades_00:
				ld a, (last_heli)
				or a
				jr nz, heli_blades_01
					ld hl, img_heli_blade_front
					call hideImage_item
					ret
					
			heli_blades_01:
				ld a, (last_heli)
				cp 1
				jr nz, heli_blades_02
					ld hl, img_heli_blade_back
					call showImage_item
					ret
			
			heli_blades_02:
				ld a, (last_heli)
				cp 2
				jr nz, heli_blades_03
					ld hl, img_heli_blade_front
					call showImage_item
					ret
			
			heli_blades_03:	
				ld hl, img_heli_blade_back
				call hideImage_item					
				
				ret
				

moveleft:
			ld a, (boatpos)
			or a
			ret z		; we are max left just return
			dec a
			ld (boatpos), a
			
			or a	
			jr	z, boat_left
			
		; we are on center
		boat_middle:	
			ld hl, img_boat_left
			call hideImage_item
			ld hl, img_boat_middle
			call showImage_item
			ld hl, img_boat_right
			call hideImage_item
			
			ret
		
		boat_left:	
		; we are top left
			
			ld hl, img_boat_left
			call showImage_item
			ld hl, img_boat_middle
			call hideImage_item
			ld hl, img_boat_right
			call hideImage_item
			
			ret
			

moveright:
			ld a, (boatpos)
			cp 2
			ret z		; we are max right just return
			inc a
			ld (boatpos), a
			
			cp 2	
			jr	z, boat_right
			
		; we are on center
		
			jr boat_middle
		
		boat_right:	
		; we are top right
			
			ld hl, img_boat_left
			call hideImage_item
			ld hl, img_boat_middle
			call hideImage_item
			ld hl, img_boat_right
			call showImage_item
			
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
include "parachute_images.asm"
include "parachute_logo.asm"
include "parachute_screen_lib.asm"
include "parachute_digits.asm"
include "parachute_math.asm"

fons:
incbin 	"parachute_screen.scr"

include '../libs/interrupt_lib.asm' ; always include last line or before org	
