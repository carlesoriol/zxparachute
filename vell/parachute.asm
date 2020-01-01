
				org 0x4000
				incbin 	"para1_atr2.scr"
				
include "../libs/screen_macros.asm"

;; NOTA: 10 voltes = 15s, 950 bytes				
				org 0x8000
main:				
				ld a, 0				; posem el marge negre
				out	(#fe), a ;	
				ld a, 0
				ld ($5C48), a	
				
				call waitnokey
				
				ld a, 1
				ld (img_heli), a				
				ld (img_heli_blade_front), a	
				ld (img_heli_blade_back), a				
				ld (img_monkey), a				
				ld (img_boat_middle), a
				ld (img_gamea), a
				ld (img_digit_1), a
				ld (img_digit_2), a
				ld (img_digit_separator), a
				ld (img_digit_3), a
				ld (img_digit_4), a
				ld (img_am), a
				
				ld a, 34
				call showImage
				
				call repaintAttributes
			
				
		main_loop:
				
				ld a, (currentimage)
				or a				
				call nz, hideImage
				
				ld a, (currentimage)
				inc a
						
				cp 54
				jr nz, main_loop_cont
					call mostracounter
					ld a, 1					
				
			main_loop_cont
				ld (currentimage), a
				call showImage
		
				call repaintAttributes
														
				xor a
				in a,(#fe)
				cpl
				and %00111111
				jr	z, main_loop
				
				rst 0

currentimage:	defb 0

mostracounter:
				ld a, (0x4000)
				inc a 
				ld (0x4000), a
				ret nc
				ld a, (0x4001)
				inc a 
				ld (0x4001), a				
				ret nc
				ld a, (0x4002)
				inc a 
				ld (0x4002), a				
				
				ret
			
; a = image number
; modifica hl, a
hideImage:				
				ld hl, img_map				
				ld l, a
				ld (hl), 0
				ret

; a = image number
; modifica hl, a
showImage:				
				ld hl, img_map				
				ld l, a
				ld (hl), 1
				ret
				
; a = image number 
; returns a (0=invisible, 1=visible)
; modifica hl, a
isImageVisible:
				ld hl, img_map				
				ld l, a
				ld a, (hl)
				ret
				
repaintAttributes:
				ld bc, 32*20
				ld de, attributes_start + 32 * 2
				ld hl, img_attr_map			
			repaintAttributes_loop:	
				ld a, (hl)
				or a
				jr z, repaintAttributes_continue
				exx				
				call isImageVisible
				exx
				or a
				jr nz, repaintAttributes_Visible

			repaintAttributes_notVisible:
				ld a, (de)			
				exx
				and %11111000
				ld d, a
				and %00111000
				rrca
				rrca
				rrca
				or d
				exx
				ld (de), a
				jr repaintAttributes_continue
					
			repaintAttributes_Visible:				
				ld a, (de)				
				and %11111000 ; ink = black
				ld (de), a
				
			repaintAttributes_continue:
				inc hl
				inc de
				dec bc
				
				ld a,b
				or c
				jr nz, repaintAttributes_loop
				
				ret
			
	
				
waitforkey:
				xor a
				in a,(#fe)
				cpl
				and %00111111
				jr	z, waitforkey
				; continue to release

waitnokey:
				xor a
				in a,(#fe)
				cpl
				and %00111111
				jr	nz, waitnokey
				ret

include "parachute_images.asm"

run 0x8000
