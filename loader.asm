	org 30000
	
	; load main (screen+program)
		
	ld ix,#4000
	ld de,11692
	ld a, #ff
	scf
	call #0556
	
	; load interrupt table
		
	ld ix,#7C7C
	ld de,#186
	ld a, #ff
	scf
	call #0556
	
	jp #5ce2
	
	
