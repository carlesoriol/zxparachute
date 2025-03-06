


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


; increments 32bits counter pointed by hl
; must be in 2 low byte align 
; modifies hl				
inc32counter:

				inc (hl)
				ret nz
				inc hl	
				inc (hl)
				ret nz
				inc hl	
				inc (hl)
				ret nz
				inc hl	
				inc (hl)
							
				ret


; updates time structure pointed by hl
; format 4 bytes 
; 50s, seconds, minutes, hours
; modifies hl, a
update_time:	ld a, (hl)
				inc a
				cp 50
				jr nz, update_time_end
					
update_time_nextsecond:
				xor a
				ld (hl), a
				inc hl
				
				ld a, (hl)
				inc a
				cp 60
				jr nz, update_time_end
				
update_time_nextminute:
				xor a
				ld (hl), a
				inc hl
				
				ld a, (hl)
				inc a
				cp 60
				jr nz, update_time_end
							
update_time_nexthour:
				xor a
				ld (hl), a
				inc hl
				
				ld a, (hl)
				inc a
				cp 24
				jr nz, update_time_end
				xor a
				
	
update_time_end:
				ld (hl),a
				ret
				

; swap memory contents
; hl = 1st pointer, de = 2nd pointer, bc = bytes to swap
; modifies af, af', hl, de, bc
swap_memory: 			
				ld a, (hl)
				ex af, af'
				ld a, (de)
				ld (hl), a
				ex af, af'
				ld (de), a
				
				inc hl
				inc de
				
				dec c
				jr nz, swap_memory
				djnz swap_memory
				
				ret

; hl = start
; b = elements
; modifies hl, b, a
; returns a
checksum8:
				xor a
checksum8_loop:
				add (hl)
				inc hl
				djnz checksum8_loop
				ret