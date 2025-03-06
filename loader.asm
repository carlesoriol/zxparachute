	org 30000
	
	; load main (screen+program)
		
	ld ix,0x4000
	ld de,11692
	ld a, 0xff
	scf
	call 0x0556
	
	; load interrupt table
		
	ld ix,0x8000
	ld de,0x186
	ld a, 0xff
	scf
	call 0x0556
	
	jp 0x5ce2
	
	
