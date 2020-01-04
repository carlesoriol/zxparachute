
align 256
i_screen:

	i_none:					defb 0
	
	i_heli:					defb 0
	i_heli_blade_front:		defb 0
	i_heli_blade_back:		defb 0
		
	i_miss:					defb 0
	i_live_1:				defb 0
	i_live_2:				defb 0
	i_live_3:				defb 0
		
	i_monkey:				defb 0
	i_bell_high:			defb 0
	i_bell_low:				defb 0
		
	i_gamea:				defb 0
	i_gameb:				defb 0
		
	i_am:					defb 0
	i_pm:					defb 0
	i_digit_1:				defb 0
	i_digit_2:				defb 0
	i_digit_separator:		defb 0
	i_digit_3:				defb 0
	i_digit_4:				defb 0
		
	i_boat_left:			defb 0
	i_boat_middle:			defb 0
	i_boat_right:			defb 0
		
	i_parachute_1_1:		defb 0
	i_parachute_1_2:		defb 0
	i_parachute_1_3:		defb 0
	i_parachute_1_4:		defb 0
	i_parachute_1_5:		defb 0
	i_parachute_1_6:		defb 0
	i_parachute_1_7:		defb 0
		
	i_parachute_2_1:		defb 0
	i_parachute_2_2:		defb 0
	i_parachute_2_3:		defb 0
	i_parachute_2_4:		defb 0
	i_parachute_2_5:		defb 0
	i_parachute_2_6:		defb 0
		
	i_parachute_3_1:		defb 0
	i_parachute_3_2:		defb 0
	i_parachute_3_3:		defb 0
	i_parachute_3_4:		defb 0
	i_parachute_3_5:		defb 0
	i_parachute_3_hang1:	defb 0
	i_parachute_3_hang2:	defb 0
		
	i_manwater_1:			defb 0
	i_shark_1:				defb 0
	i_manwater_2:			defb 0
	i_shark_2:				defb 0
	i_manwater_3:			defb 0
	i_shark_3:				defb 0
	i_manwater_4:			defb 0
	i_shark_4:				defb 0
	i_manwater_5:			defb 0
	i_shark_5:				defb 0
	i_manwater_6:			defb 0

	i_button_left:			defb 0
	i_button_right:			defb 0

	i_button_a:				defb 0
	i_button_b:				defb 0

i_screen_end:

number_of_images:		equ 	(i_screen_end - i_screen)

i_screen_last:			defs number_of_images

img_attr_map:
	defw 0x0000					;0
		
	defw img_heli				;1
	defw img_heli_blade_front	;2
	defw img_heli_blade_back	;3
	
	defw img_miss				;4
	defw img_live_1				;5
	defw img_live_2				;6
	defw img_live_3				;7
	
	defw img_monkey				;8
	defw img_bell_high			;9
	defw img_bell_low			;10
	
	defw img_gamea				;11
	defw img_gameb				;12

	defw img_am					;13
	defw img_pm					;14
	defw img_digit_1			;15
	defw img_digit_2			;16
	defw img_digit_separator	;17
	defw img_digit_3			;18
	defw img_digit_4			;19

	defw img_boat_left			;20
	defw img_boat_middle		;21
	defw img_boat_right			;22

	defw img_parachute_1_1		;23
	defw img_parachute_1_2		;24
	defw img_parachute_1_3		;25
	defw img_parachute_1_4		;26
	defw img_parachute_1_5		;27
	defw img_parachute_1_6		;28
	defw img_parachute_1_7		;29

	defw img_parachute_2_1		;30
	defw img_parachute_2_2		;31
	defw img_parachute_2_3		;32
	defw img_parachute_2_4		;33
	defw img_parachute_2_5		;34
	defw img_parachute_2_6		;35

	defw img_parachute_3_1		;36
	defw img_parachute_3_2		;37
	defw img_parachute_3_3		;38
	defw img_parachute_3_4		;39
	defw img_parachute_3_5		;40

	defw img_parachute_3_hang1	;41
	defw img_parachute_3_hang2	;42
	
	defw img_manwater_1			;43
	defw img_shark_1			;44
	defw img_manwater_2			;45
	defw img_shark_2			;46
	defw img_manwater_3			;47
	defw img_shark_3			;48
	defw img_manwater_4			;49
	defw img_shark_4			;50
	defw img_manwater_5			;51
	defw img_shark_5			;52
	defw img_manwater_6			;53
	
	defw img_button_left		;54
	defw img_button_right		;55
	defw img_button_a			;56
	defw img_button_b			;57
	
img_attr_map_end:
	defw 0x0000					; 58

	


img_heli:
				defw 22649, 22650, 22651, 22652, 22653, 22654, 22681, 22682, 22683, 22684, 22685, 22686, 22687, 22713, 22714, 22715, 22716, 22717, 22718, 22719, 22747, 22748, 22749, 22750, 0
img_heli_blade_front:
				defw 22621, 22622, 22623, 0
img_heli_blade_back:
				defw 22616, 22617, 22618, 22619, 22620, 0

img_miss:
				defw 23064, 23065, 23066, 23067, 23068, 0
img_live_1:
				defw 23095, 23096, 23127, 23128, 23129, 0
img_live_2:
				defw 23098, 23099, 23130, 23131, 23132, 0
img_live_3:
				defw 23101, 23102, 23133, 23134, 23135, 0

img_monkey:
				defw 22755, 22756, 22786, 22787, 22788, 22789, 22818, 22819, 22820, 22821, 22849, 22850, 22851, 22881, 22882, 22883, 22884, 22914, 22915, 0
img_bell_high:
				defw 22790, 22791, 22792, 22822, 22823, 0
img_bell_low:
				defw 22852, 22853, 22885, 22886, 22917, 22918, 0

img_gamea:
				defw 23200, 23201, 23202, 23203, 23204, 0
img_gameb:
				defw 23227, 23228, 23229, 23230, 23231, 0

img_am:
				defw 22625, 22626, 0
img_pm:
				defw 22657, 22658, 0
img_digit_1:
				defw 22634, 22635, 22666, 22667, 22698, 22699, 0
img_digit_2:
				defw 22632, 22633, 22664, 22665, 22696, 22697, 0
img_digit_separator:
				defw 22631, 22663, 0
img_digit_3:
				defw 22629, 22630, 22661, 22662, 22693, 22694, 0
img_digit_4:
				defw 22627, 22628, 22659, 22660, 22691, 22692, 0

img_boat_left:
				defw 23011, 23012, 23043, 23044, 23045, 23075, 23076, 23077, 23078, 23079, 23080, 0
img_boat_middle:
				defw 23017, 23018, 23019, 23049, 23050, 23051, 23081, 23082, 23083, 23084, 23085, 23086, 23114, 23115, 0
img_boat_right:
				defw 23024, 23025, 23026, 23056, 23057, 23058, 23088, 23089, 23090, 23091, 23092, 23093, 23094, 0

img_parachute_1_1:
				defw 22614, 22615, 22646, 22647, 0
img_parachute_1_2:
				defw 22611, 22612, 22613, 22643, 22644, 0
img_parachute_1_3:
				defw 22609, 22610, 22640, 22641, 22642, 22672, 22673, 22704, 22705, 0
img_parachute_1_4:
				defw 22605, 22606, 22637, 22638, 22669, 22670, 22701, 22702, 0
img_parachute_1_5:
				defw 22730, 22731, 22732, 22762, 22763, 22764, 22794, 22795, 22796, 22827, 0
img_parachute_1_6:
				defw 22824, 22825, 22826, 22855, 22856, 22857, 22858, 22888, 22889, 22890, 22921, 22922, 0
img_parachute_1_7:
				defw 22949, 22950, 22951, 22952, 22981, 22982, 22983, 22984, 23013, 23014, 23015, 23016, 23046, 23047, 23048, 0

img_parachute_2_1:
				defw 22679, 22680, 22711, 22712, 0
img_parachute_2_2:
				defw 22676, 22677, 22678, 22708, 22709, 22710, 22740, 22741, 0
img_parachute_2_3:
				defw 22706, 22707, 22737, 22738, 22739, 22769, 22770, 22801, 22802, 0
img_parachute_2_4:
				defw 22734, 22735, 22736, 22766, 22767, 22768, 22798, 22799, 22800, 22832, 22833, 0
img_parachute_2_5:
				defw 22828, 22829, 22830, 22831, 22860, 22861, 22862, 22863, 22892, 22893, 22894, 22895, 22925, 22926, 22927, 0
img_parachute_2_6:
				defw 22956, 22957, 22958, 22959, 22988, 22989, 22990, 22991, 23020, 23021, 23022, 23023, 23052, 23053, 23054, 0

img_parachute_3_1:
				defw 22745, 22746, 22777, 22778, 22809, 0
img_parachute_3_2:
				defw 22744, 22775, 22776, 22807, 22808, 0
img_parachute_3_3:
				defw 22772, 22773, 22774, 22804, 22805, 22806, 22837, 22838, 22870, 0
img_parachute_3_4:
				defw 22834, 22835, 22836, 22866, 22867, 22868, 22869, 22898, 22899, 22900, 22901, 22931, 22932, 0
img_parachute_3_5:
				defw 22963, 22964, 22965, 22966, 22995, 22996, 22997, 22998, 23027, 23028, 23029, 23030, 23059, 23060, 23061, 23062, 0
img_parachute_3_hang1:
				defw 22871, 22872, 22902, 22903, 22904, 22934, 22935, 22936, 22967, 0
img_parachute_3_hang2:
				defw 22873, 22874, 22905, 22906, 22907, 22938, 22939, 22970, 22971, 0

img_manwater_1:
				defw 23122, 23123, 23124, 23125, 23154, 23155, 23156, 0
img_shark_1:
				defw 23152, 23153, 0
img_manwater_2:
				defw 23116, 23117, 23118, 23147, 23148, 23149, 23150, 23151, 0
img_shark_2:
				defw 23145, 23146, 0
img_manwater_3:
				defw 23110, 23111, 23112, 23141, 23142, 23143, 23144, 0
img_shark_3:
				defw 23174, 23175, 23206, 23207, 0
img_manwater_4:
				defw 23177, 23178, 23179, 23209, 23210, 23211, 0
img_shark_4:
				defw 23180, 23181, 23212, 23213, 0
img_manwater_5:
				defw 23183, 23184, 23185, 23215, 23216, 0
img_shark_5:
				defw 23157, 23158, 23186, 23187, 23188, 23189, 23190, 23218, 23219, 23220, 23221, 23222, 0
img_manwater_6:
				defw 23159, 23160, 23161, 23191, 23192, 23193, 23223, 23224, 23225, 0

img_button_left:	defw attributes_start + 32 * 22 + 1, attributes_start + 32 * 22 + 2, attributes_start + 32 * 23 + 1, attributes_start + 32 * 23 + 2, 0
img_button_right:	defw attributes_start + 32 * 22 + 29, attributes_start + 32 * 22 + 30, attributes_start + 32 * 23 + 29, attributes_start + 32 * 23 + 30, 0
img_button_a:		defw attributes_start + 32 * 22 + 1, attributes_start + 32 * 22 + 2, attributes_start + 32 * 23 + 1, attributes_start + 32 * 23 + 2, 0
img_button_b:		defw attributes_start + 32 * 22 + 1, attributes_start + 32 * 22 + 2, attributes_start + 32 * 23 + 1, attributes_start + 32 * 23 + 2, 0
