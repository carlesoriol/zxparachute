

screen_width_pixels		equ 256		; 0x100
screen_height_pixels	equ 192		; 0xc0
screen_width_chars		equ 32		; 0x20
screen_height_chars		equ 24		; 0x18

screen_start			equ 0x4000

screen_size				equ (screen_width_chars * screen_height_pixels)
screen3_size			equ (screen_width_chars * screen_height_pixels / 3) ; 0x800

screen_start_2_3		equ (screen_start + screen3_size)
screen_start_3_3		equ (screen_start + screen3_size * 2)

linedif_in3				equ 256	; distance from one pointer in screen to inferior next in 1/3 block


attributes_start		equ 0x5800		; 22528
attr_start				equ attributes_start
attributes_length		equ (screen_width_chars * screen_height_chars)
attributes_size			equ attributes_length

full_screen_size		equ (screen_size + attributes_length)

BLACK					equ %000000
BLUE					equ %000001
RED						equ %000010
MAGENTA					equ %000011
GREEN					equ %000100
CYAN					equ %000101
YELLOW					equ %000110
WHITE					equ %000111

PAPER_BLACK				equ (BLACK << 3)
PAPER_BLUE				equ (BLUE << 3)
PAPER_RED				equ (RED << 3)
PAPER_MAGENTA			equ (MAGENTA << 3)
PAPER_GREEN				equ (GREEN << 3)
PAPER_CYAN				equ (CYAN << 3)
PAPER_YELLOW 			equ (YELLOW << 3)
PAPER_WHITE				equ (WHITE << 3)
   
BRIGHT					equ %01000000
NO_BRIGHT				equ %00000000

FLASH					equ	%10000000
NO_FLASH				equ %00000000

;Atributs	Bit	7		6		543		210
;            	FLASH	BRIGHT	PAPER	INK




; ULA Bit   7   6   5   4   3   2   1   0
; out  +-------------------------------+
; #FE  |   |   |   | E | M |   Border  |
;      +-------------------------------+



; ref http://www.overtakenbyevents.com/lets-talk-about-the-zx-specrum-screen-layout/
			
			
			
		
			
			
			
			
