; bc = coordinates
; a = digit

pinta_digit:
				
			ld hl, segments_digit_0
			add l
			ld l, a
			ld a, (hl)
						
			ld d, 6
			ld ix, digits_def
						
pinta_digit_loop:
			
			push af
			push de
			push bc	
					
				ld l, (ix+0)
				inc ix
				ld h, (ix+0)
				inc ix
				ld e, (ix+0)
				inc ix
				ld d, (ix+0)
				inc ix
				
				and 1
				jr z, pinta_digit_neg
					call BCaddDE_simple													
					call pintaspriteOr		
					jr pinta_digit_cont
					
pinta_digit_neg:				
					call BCaddDE_simple													
					call pintaspriteMask
					
pinta_digit_cont:			
			pop bc
			pop de					
			pop af
			rra
			
			dec d
			jp p, pinta_digit_loop
				
			ret
			
			
digits_def:		
			defw	img_seg_top, 0x0100
			defw	img_seg_top_right, 0x0308
			defw	img_seg_bottom_right, 0x0c08
			defw	img_seg_bottom, 0x1200
			defw	img_seg_bottom_left, 0x0c00
			defw	img_seg_top_left, 0x0300				
			defw	img_seg_middle, 0x0900
				
BCaddDE_simple:
			ld a, c
			add e
			ld c, a
			
			ld a, b
			adc d
			ld b, a
			
			ret


	align 0x8

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



