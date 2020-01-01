
				org 0x8000

				
include "../libs/screen_macros.asm"				

				
				ld bc, #0000
				xor a
				
				call main_loop
				
				ld bc, #0008
				xor a
				
				call main_loop
				
				ret
				
			main_loop:
				push af
				push bc				
					call pinta_digit				
				pop bc
				
				ld a, c
				add a, #10
				ld c, a
				
				pop af
				inc a
				cp 10
				jr nz, main_loop
				ret
				
include "parachute_digits.asm"
include "parachute_screen_lib.asm"				



