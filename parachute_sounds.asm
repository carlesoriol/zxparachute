
move_parachute_sound:
				ld hl, #f1	
				ld de, 2				
				call beeper				
				ret

parachute_rescued_sound:

				ld b, #1a
			parachute_rescued_sound_loop:
				push bc
				
				ld hl, #ca
				ld de, 2
				call beeper
							
				ld b, 200				; use nops to produce broken sound
			parachute_rescued_sound_loop2
				nop
				nop
				djnz parachute_rescued_sound_loop2

				pop bc
				djnz parachute_rescued_sound_loop

				ret

parachute_lost_sound:
				ld b, #1a
			parachute_lost_sound_loop:
				push bc
				
				ld hl, #1ca
				ld de, 2
				call beeper
							
				ld b, 200				; use nops to produce broken sound
			parachute_lost_sound_loop2
				nop
				nop
				djnz parachute_lost_sound_loop2

				pop bc
				djnz parachute_lost_sound_loop

				ret