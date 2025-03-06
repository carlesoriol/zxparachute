

; Sets im2 to interrupt pointer to DE.
; Creates a interrupt table from FA00 to FB02 with $FC (129 par entries).
; Elones IM2Routine to $FCFC to avoid code segmenting
; Enables interrupts on exit
;
; de = interrupt pointer
; uses hl, de, bc,


setInterruptTo:

		ld hl, interruptcallfunction
		inc hl
		ld (hl), e
		inc hl
		ld (hl), d

; move interrupt routine to $FCFC
		ld hl, IM2Routine
		ld de, $FCFC
		ld bc, IM2RoutineEnd - IM2Routine + 1
		ldir

; Setup the 128 entry vector table
		di

		ld            hl, $FA00		; VectorTable FA00 to FB02 acopied by VectorTable
		ld            de, $FCFC; IM2Routine
		ld            b, 129

		; Setup the I register (the high byte of the table)
		ld            a, h
		ld            i, a

		; Loop to set all 128 entries in the table
1:
		ld            (hl), e
		inc           hl
		ld            (hl), d
		inc           hl
		djnz          1B

		; Setup IM2 mode
		im            2
		ei
		ret

; This default callback does not store alternative registers
; So if you are going to use them in your interrupt routine
; save and restore them before returning
;
IM2Routine:
		push af             ; preserve registers.
		push bc
		push hl
		push de
		push ix
		push iy
interruptcallfunction:
		call #0000          ;	:replaced as SetInterruptTo
		;rst 56              ; ROM routine, read keys and update clock.

		pop iy				; restore registers.
		pop ix              ;
		pop de
		pop hl
		pop bc
		pop af

		ei                  ; always re-enable interrupts before returning.
		reti                ; done.

IM2RoutineEnd: