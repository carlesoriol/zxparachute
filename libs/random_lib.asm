; Fast RND
;
; An 8-bit pseudo-random number generator,
; using a similar method to the Spectrum ROM,
; - without the overhead of the Spectrum ROM.
;
; R = random number seed
; an integer in the range [1, 256]
;
; R -> (33*R) mod 257
;
; S = R - 1
; an 8-bit unsigned integer


;modifies b, a

random:

	 ld a, (random_seed)
	 ld b, a 
	 ld a,r
	 xor b
	 ld b, a 
	 

	 rrca ; multiply by 32
	 rrca
	 rrca
	 xor 0x1f

	 add a, b
	 sbc a, 255 ; carry

	 ld (random_seed), a
	 ret

randomize:
	ld a, r
	ld (random_seed), a
	ret

random_seed:	defb	0



        
