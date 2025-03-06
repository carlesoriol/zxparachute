10 border 0: paper 0: ink 0: clear val "65535": cls
20 for c=0 to 28
30 read a: poke 30000+c,a
40 next c
50 randomize usr 30000
60 data 221,33,0,64
70 data 17,0,27
80 data 62,255
90 data 55
100 data 205,86,5
160 data 221,33,0,128
170 data 17,134, 17
180 data 62,255
190 data 55
200 data 205,86,5
300 data 195,0,128
