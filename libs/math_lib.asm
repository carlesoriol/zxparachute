; based on https://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Multiplication
; https://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Division


; 8*8 multiplication
; The following routine multiplies h by e and places the result in hl
; uses hl, de, b
mult_h_e:
		ld	l, 0
		ld	d, l

		sla	h		; optimised 1st iteration
		jr	nc, mult_h_e_skip
		ld	l, e
mult_h_e_skip:
		ld b, 7
mult_h_e_loop:
		add	hl, hl
		jr	nc, mult_h_e_break
		add	hl, de

mult_h_e_break:
		djnz	mult_h_e_loop

		ret

; 16*8 multiplication
; The following routine multiplies de by a and places the result in ahl
; (which means a is the most significant byte of the product,
; l the least significant and h the intermediate one...)
mult_a_de
		ld	c, 0
		ld	h, c
		ld	l, h

		add	a, a		; optimised 1st iteration
		jr	nc, mult_a_de_skip
		ld	h,d
		ld	l,e

mult_a_de_skip:
		ld b, 7
mult_a_de_loop:
		add	hl, hl
		rla
		jr	nc, mult_a_de_break
		add	hl, de
		adc	a, c            ; yes this is actually adc a, 0 but since c is free we set it to zero and so we can save 1 byte and up to 3 T-states per iteration

mult_a_de_break:
		djnz	mult_a_de_loop

		ret


;16*16 multiplication
;The following routine multiplies bc by de and places the result in dehl.
mult_de_bc:
		ld	hl, 0

		sla	e		; optimised 1st iteration
		rl	d
		jr	nc, mult_de_bc_skip
		ld	h, b
		ld	l, c
mult_de_bc_skip:
		ld	a, 15
mult_de_bc_loop:
		add	hl, hl
		rl	e
		rl	d
		jr	nc, mult_de_bc_break
		add	hl, bc
		jr	nc, mult_de_bc_break
		inc	de
mult_de_bc_break:
		dec	a
		jr	nz, mult_de_bc_loop

		ret

; from Daniel A. Nagy facebook post
; 16 bit multiplication
; In: BC,DE 16 bit multiplicands
; Out: HLAC 32 bit product
MULBCDE:XOR     A
        LD      H,A
        LD      L,A
        LD      A,B
        LD      B,$11
MULL:   RR      H
        RR      L
        RRA
        RR      C
        JR      NC,MULNC
        ADD     HL,DE
MULNC:  DJNZ    MULL
        RET


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

; 16/8 division
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

; 16/16 division
; The following routine divides ac by de and places the quotient in ac and the remainder in hl
div_ac_de:
		   ld	hl, 0
		   ld	b, 16

div_ac_de_loop:
		   sll	c
		   rla
		   adc	hl, hl
		   sbc	hl, de
		   jr	nc, $+4
		   add	hl, de
		   dec	c

		   djnz	div_ac_de_loop

		   ret

; 24/8 division
; The following routine divides ehl by d and places the quotient in ehl and the remainder in a
div_ehl_d:
		   xor	a
		   ld	b, 24

div_ehl_d_loop:
		   add	hl, hl
		   rl	e
		   rla
		   jr	c, $+5
		   cp	d
		   jr	c, $+4

		   sub	d
		   inc	l

		   djnz	div_ehl_d_loop

		   ret

; 32/8 division
; The following routine divides dehl by c and places the quotient in dehl and the remainder in a
div_dehl_c:
		   xor	a
		   ld	b, 32

div_dehl_c_loop:
		   add	hl, hl
		   rl	e
		   rl	d
		   rla
		   jr	c, $+5
		   cp	c
		   jr	c, $+4

		   sub	c
		   inc	l

		   djnz	div_dehl_c_loop

		   ret

;32/16 division
;The following routine divides acix by de and places the quotient in acix and the remainder in hl

Div32By16:
; IN:	ACIX=dividend, DE=divisor
; OUT:	ACIX=quotient, DE=divisor, HL=remainder, B=0
	ld	hl,0
	ld	b,32
Div32By16_Loop:
	add	ix,ix
	rl	c
	rla
	adc	hl,hl
	jr	c,Div32By16_Overflow
	sbc	hl,de
	jr	nc,Div32By16_SetBit
	add	hl,de
	djnz	Div32By16_Loop
	ret
Div32By16_Overflow:
	or	a
	sbc	hl,de
Div32By16_SetBit:
	;.db	$DD,$2C		; inc ixl, change to inc ix to avoid undocumented
	inc ixl
	djnz	Div32By16_Loop
	ret

; Rounded 16/8 division
; The following routine divides hl by c and places the rounded quotient in hl and twice the prerounded remainder in a.

RoundHL_Div_C:
   xor	a
   ld	b, 16

RoundHL_Div_C_loop:
   add	hl, hl
   rla
   jr	c, $+5
   cp	c
   jr	c, $+4
   sub	c
   inc	l
   djnz	RoundHL_Div_C_loop
;This part is the rounding
   add a,a
   cp	c
   ret	c
   inc hl
   ret


; absolute value of a
absA:
        or a
        ret p
        neg
        ret

