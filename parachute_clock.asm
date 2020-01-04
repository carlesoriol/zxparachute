
update_clock_dots:
				ld a, (time_50s)				
				cp 25				
				jr c, update_clock_dots_show
					xor a
					jr update_clock_dots_cont
			update_clock_dots_show:
				ld a, 1		
			update_clock_dots_cont:	
				ld (i_digit_separator),a 
				
				
update_clock:
				ld a, (time_minute)
				ld d, a
				ld e, 10
				call div_d_e		; reminder in a
				
				ld bc,#1850
				call pinta_digit
				
				ld a, (time_minute)
				ld d, a
				ld e, 10
				call div_d_e		; quotient in d 
				ld a, d
				
				ld bc,#1840
				call pinta_digit
				
				ld a, (time_hour)		; 12 h get a
				ld d, a
				ld e, 12
				call div_d_e
				push af
				
				ld d, a
				ld e, 10
				call div_d_e		; reminder in a
				
				ld bc,#1828
				call pinta_digit
				
				pop af
				ld d, a
				ld e, 10
				call div_d_e		; quotient in d 
				ld a, d
				
				ld bc,#1818
				call pinta_digit
				
				ld a, (time_hour)		; 12 h get a
				ld d, a
				ld e, 12
				call div_d_e
				ld a, d
				or a
				jr z, update_clock_am
					xor a
					ld (i_am), a
					inc a
					ld (i_pm), a					
					ret

			update_clock_am:
					xor a
					ld (i_pm), a
					inc a
					ld (i_am), a
					
					ret


clock_keys:	
                ld h, 0         ; h=0 no update, h=1 time changed

				ld b, KEYSEG_LKJH
				ld d, KEY_H
				call checkkey
                jr z, clock_keys_minute
                    ld h, 1
                    ld a, (time_hour)
                    inc a
                    cp 24
                    jr nz, clock_keys_hour_cont
                        xor a
            clock_keys_hour_cont:
                    ld (time_hour), a


            clock_keys_minute:  
                ld b, KEYSEG_MNB
				ld d, KEY_M
				call checkkey
                jr z, clock_keys_cont
				    ld h, 1
                    ld a, (time_minute)
                    inc a
                    cp 60
                    jr nz, clock_keys_minute_cont
                        xor a
            clock_keys_minute_cont:
                    ld (time_minute), a

            clock_keys_cont:
                    ld a, h
                    or a
                    ret z

                    jp update_clock



