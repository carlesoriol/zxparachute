
move_parachute_sound:
				ld hl, 0xf1	
				ld de, 2				
				call beeper				
				ret

parachute_rescued_sound:

				ld b, 0x1a
parachute_rescued_sound_loop:
				push bc
				
				ld hl, 0xca
				ld de, 2
				call beeper
							
				ld b, 200				; use nops to produce broken sound
parachute_rescued_sound_loop2:
				nop
				nop
				djnz parachute_rescued_sound_loop2

				pop bc
				djnz parachute_rescued_sound_loop

				ret

parachute_lost_sound:
				ld b, 0x1a
parachute_lost_sound_loop:
				push bc
				
				ld hl, 0x1ca
				ld de, 2
				call beeper
							
				ld b, 200				; use nops to produce broken sound
parachute_lost_sound_loop2:
				nop
				nop
				djnz parachute_lost_sound_loop2

				pop bc
				djnz parachute_lost_sound_loop

				ret