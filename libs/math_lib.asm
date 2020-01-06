; 8/8 division
; The following routine divides d by e and places the quotient in d and the remainder in a
; modifies A, BC, DE
div_d_e:
		   xor	a
		   ld	b, 8

		div_d_e_loop:
		   sla	d
		   rla
		   cp	e
		   jr	c, $+4
		   sub	e
		   inc	d
		   
		   djnz	div_d_e_loop
		   
		   ret

; The following routine divides hl by c and places the quotient in hl and the remainder in a

div_hl_c:
   xor	a
   ld	b, 16

div_hl_c_loop:
   add	hl, hl
   rla
   jr	c, $+5
   cp	c
   jr	c, $+4

   sub	c
   inc	l
   
   djnz	div_hl_c_loop
   
   ret