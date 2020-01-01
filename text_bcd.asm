	
	
				org 0x8000

				
				
				
			main_loop:
				ld hl,score
				call incbcdcounter_16b
				
				ld hl, (score)
				ld bc, #9999
				call cp_hl_bc_16b
				jr nz, main_loop
				
				ret
				
				
; compare hl and de
; modifies a
; z flag
cp_hl_bc_16b:			
				ld a,l
				cp c
				ret nz
				ld a,h
				cp b
				ret

; increment content hl 2 bcd bytes (4 bcd digits)
; modifies hl, a
incbcdcounter_16b:
				or a		; just to reset carry
				ld a,(hl)
				inc a
				daa
				ld (hl), a
				ret nz
				
				inc hl
				jr incbcdcounter_16b
				
score:			defw	0
