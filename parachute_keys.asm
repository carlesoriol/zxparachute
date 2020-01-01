
parachute_keys:

				ld b, KEYSEG_12345
				ld d, %00011111
				call  checkkey
				jr 	  z, nomoveleft
				
					ld a, (left_debounce)					
					or a
					jr nz, moveleft_cont	; debouncer forces to release the key
																
						call moveleft
						ld a, 1
					
						jr moveleft_cont
				
				nomoveleft:
					xor a					
				
				moveleft_cont:
					ld (left_debounce),a
					
					
				ld b, KEYSEG_09876
				ld d, %00011111
				call  checkkey
				jr 	  z, nomoveright
				
					ld a, (right_debounce)					
					or a
					jr nz, moveright_cont	; debouncer forces to release the key
																
						call moveright
						ld a, 1
					
						jr moveright_cont
				
				nomoveright:
					xor a					
				
				moveright_cont:
					ld (right_debounce),a
					
			
				ret

waitnokey:
				xor a
				in a,(#fe)
				cpl
				and %00111111
				jr	nz, waitnokey
				ret

waitkey:
				xor a
				in a,(#fe)
				cpl
				and %00111111
				jr	z, waitkey
				ret

; b= segment
; d= mask
checkkey:
				xor a
				ld c, #fe
				in a,(c)
				cpl
				and d
				ret
