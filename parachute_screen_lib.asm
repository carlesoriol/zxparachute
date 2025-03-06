; Get screen address
; B = Y pixel position
; C = X pixel position
; Returns address in DE and pixel position within character in A
; usa bc, hl, a
get_pixel_addressDE:	

				LD A,B			; Calculate Y2,Y1,Y0
				AND %00000111	; Mask out unwanted bits
				OR %01000000	; Set base address of screen
				LD D,A			; Store in H
				LD A,B			; Calculate Y7,Y6
				RRA				; Shift to position
				RRA
				RRA
				AND %00011000	; Mask out unwanted bits
				OR D			; OR with Y2,Y1,Y0
				LD D,A			; Store in H
				LD A,B			; Calculate Y5,Y4,Y3
				RLA				; Shift to position
				RLA
				AND %11100000	; Mask out unwanted bits
				LD E,A			; Store in L
				LD A,C			; Calculate X4,X3,X2,X1,X0
				RRA				; Shift into position
				RRA
				RRA
				AND %00011111	; Mask out unwanted bits
				OR E			; OR with Y5,Y4,Y3
				LD E,A			; Store in L
				
				LD A,C			; keep offset in a
				AND 7
				RET
				
				
Pixel_Address_Down_DE:
					
				INC D			; Go down onto the next pixel line
				LD A,D			; Check if we have gone onto next character boundary
				AND 7
				RET NZ			; No, so skip the next bit
				LD A,E			; Go onto the next character line
				ADD A,32
				LD E,A
				RET C			; Check if we have gone onto next third of screen
				LD A,D			; Yes, so go onto next third
				SUB 8
				LD D,A
				RET

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


; bc = y x
; hl = sprite structure
pintaspriteMask:				
				call get_pixel_addressDE
				
				ld a, (hl)
				srl a
				srl a
				srl a
				ld (pintaspriteMask_keepx+1), a
				
				inc hl
				ld a, (hl)
				inc hl
													
pintaspriteMask_loopy:
				push de
pintaspriteMask_keepx:
				ld b, 0x00			; dynamically modified
				ex af, af'
pintaspriteMask_loopx:
				ld a,(hl)
				cpl
				ld c, a
				ld a,(de)
				and c
				ld (de), a
				inc de
				inc hl
				djnz pintaspriteMask_loopx
				
				pop de
				call Pixel_Address_Down_DE				
				ex af, af'
				dec a
				jr nz, pintaspriteMask_loopy	
				
				ret			
			

