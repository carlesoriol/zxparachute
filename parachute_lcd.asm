			
			
; a = image number
; returns de = attribs pointer
; modifica hl, a, de
getImageAttribsPointer:
				ld hl, img_attr_map
				add a				
				ld l, a
				ld e, (hl)
				inc hl
				ld d, (hl)
				ret
			
hideAll:		ld a, 1

		hideAll_loop:
				ld c, a
				call hideImage
				ld a, c
				inc a
				cp number_of_images
				jr nz, hideAll_loop
				
				ret

showAll:		ld a, 1

		showAll_loop:
				ld c, a
				call showImage
				ld a, c
				inc a
				cp number_of_images
				jr nz, showAll_loop
				
				ret
			
; a = image number
; modifica hl, de, b, a
hideImage:		call getImageAttribsPointer
				ex de, hl
		hideImage_item:
		hideImage_loop:		
				ld e, (hl)
				inc hl
				ld d, (hl)
				inc hl
				
				ld a, d
				or e
				ret z
				
				ld a, (de)							
				and %11111000
				ld b, a
				and %00111000
				rrca
				rrca
				rrca
				or b
				ld (de), a
				
				jr hideImage_loop
				

; a = image number
; modifica hl, de, a
showImage:		call getImageAttribsPointer						
				ex de, hl
		showImage_item:		
		showImage_loop:		
				ld e, (hl)
				inc hl
				ld d, (hl)
				inc hl
				
				ld a, d
				or e
				ret z
				
				ld a, (de)							
				and %11111000
				ld (de), a
				
				jr showImage_loop
								
