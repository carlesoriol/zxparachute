



pinta_digit_coords	defw	0

; bc = coordinates
; a = digit

pinta_digit:
	
			
			ld hl, segments_digit_0
			add l
			ld l, a
			ld a, (hl)
			
	; a is digit segments
	pinta_digit_segments:
			ld (pinta_digit_coords), bc

	pinta_digit_segment_0:

			bit 0, a
			jr z, pinta_digit_segment_1
				ld de, #0100
				ld hl, img_seg_top
				call pinta_segment_x
				
	pinta_digit_segment_1:

			bit 1, a
			jr z, pinta_digit_segment_2
				ld de, #0308
				ld hl, img_seg_top_right
				call pinta_segment_x

	pinta_digit_segment_2:

			bit 2, a
			jr z, pinta_digit_segment_3
				ld de, #0c08				
				ld hl, img_seg_bottom_right
				call pinta_segment_x					

	pinta_digit_segment_3:

			bit 3, a
			jr z, pinta_digit_segment_4
				ld de, #1200
				ld hl, img_seg_bottom
				call pinta_segment_x

	pinta_digit_segment_4:

			bit 4, a
			jr z, pinta_digit_segment_5			
				ld de, #0c00
				ld hl, img_seg_bottom_left
				call pinta_segment_x

	pinta_digit_segment_5:

			bit 5, a
			jr z, pinta_digit_segment_6				
				ld de, #0300
				ld hl, img_seg_top_left
				call pinta_segment_x

	pinta_digit_segment_6:

			bit 6, a
			jr z, pinta_digit_segment_end
				ld de, #0900
				ld hl, img_seg_middle
				call pinta_segment_x

	pinta_digit_segment_end
	
			ret
			
			

BCaddDE_simple:
			ld a, c
			add e
			ld c, a
			
			ld a, b
			adc d
			ld b, a
			
			ret
			
pinta_segment_x:
			push af
			push bc							
				call BCaddDE_simple								
				call pintaspriteOr			
			pop bc
			pop af
			ret

align 16

segments_digit_0:	defb	%00111111
segments_digit_1:	defb	%00000110
segments_digit_2:	defb	%01011011
segments_digit_3:	defb	%01001111
segments_digit_4:	defb	%01100110
segments_digit_5:	defb	%01101101
segments_digit_6:	defb	%01111101
segments_digit_7:	defb	%00000111
segments_digit_8:	defb	%01111111
segments_digit_9:	defb	%01101111

; bc = y x
; hl = sprite structure
pintaspriteOr:

				call get_pixel_addressDE
				
				ld a, (hl)
				srl a
				srl a
				srl a
				ld (pintaspriteOr_keepx+1), a	
				
				inc hl
				ld a, (hl)				
				inc hl
													
			pintaspriteOr_loopy:
				push de
			pintaspriteOr_keepx:
				ld b, 0x00			; dynamically modified
				ex af, af'
			pintaspriteOr_loopx:
				ld a,(de)
				ld c,(hl)
				or c
				ld (de), a
				inc de
				inc hl
				djnz pintaspriteOr_loopx
				
				pop de
				call Pixel_Address_Down_DE				
				ex af, af'
				dec a
				jr nz, pintaspriteOr_loopy				
			
				ret


img_seg_top:
	
	defb	16, 2
	defb	%00000111, %11110000
	defb	%00000011, %11100000

img_seg_top_right:

	defb	8, 5
	defb	%00001000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	
img_seg_bottom_right:

	defb	8, 6
	defb	%00010000
	defb	%00110000
	defb	%00110000
	defb	%00110000
	defb	%00110000
	defb	%00010000

img_seg_bottom:

	defb	16, 2
	defb	%00000111, %11000000
	defb	%00001111, %11100000
	
img_seg_bottom_left:

	defb	8, 6
	defb	%00010000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00010000

img_seg_top_left:

	defb	8, 5
	defb	%00001000
	defb	%00001100
	defb	%00001100
	defb	%00001100
	defb	%00001000

img_seg_middle:

	defb	16, 2
	defb	%00000111, %11110000
	defb	%00001111, %11100000



