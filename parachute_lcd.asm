			
update_screen:

				ld a, 0
				ld de, i_screen
				ld hl, i_screen_last

		update_screen_loop:
				inc a						; there's no object 0
				cp number_of_images
				ret z
				inc de
				inc hl

				push af
					ld c, a				; keep index
					ld a,(de)
					ld b, a
					ld a, (hl) 
					cp b
					jr z, update_screen_no_change

						push hl
						push de

						ld (hl), b
						or a
						jr z, update_screen_show						
							ld a, c						; hide
							call IhideImage
							jr update_screen_show_cont

						update_screen_show:	
							ld a,c						; show
							call IshowImage

						update_screen_show_cont:

						pop de						
						pop hl
				
					update_screen_no_change:
				pop af

				jr update_screen_loop

		
			
; a = image number
; returns de = attribs pointer
; modifica hl, a, de
getImageAttribsPointer:
				ld hl, img_attr_map
				add a				
				add l
				ld l, a
				jr nc, getImageAttribsPointer_cont
					inc h
			getImageAttribsPointer_cont:
				ld e, (hl)
				inc hl
				ld d, (hl)
				ret

showAll:		ld a, 1
				jr i_screen_a_to_all
				
hideAll:		
				xor a
								
			i_screen_a_to_all:
				ld b, (i_screen_end - i_screen) - 1
			
			hideAll_loop:
				ld hl, i_screen
				ld l, b				; i_screen 256 aligned
				ld (hl), a
				djnz hideAll_loop

				ld (hl),a 
				ret

			
; a = image number
; modifica hl, de, b, a
IhideImage:		call getImageAttribsPointer
				ex de, hl
		IhideImage_item:
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
IshowImage:		call getImageAttribsPointer						
				ex de, hl
		IshowImage_item:		
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


; a = image number						
; modifies --
; dynamically modified
showImage:
			
			ld (showImage_index+1), a	
			ld (showImage_restore_a+1), a	
							
			ld a, 1
			showImage_index:
			ld (i_screen), a	
		
		showImage_restore_a:		
			ld a, 0		

			ret

; a = image number						
; modifies --
; dynamically modified
hideImage:
			
			ld (hideImage_index+1), a	
			ld (hideImage_restore_a+1), a	
					
			xor a
			hideImage_index:		
			ld (i_screen), a	
		
		hideImage_restore_a:		
			ld a, 0		

			ret
