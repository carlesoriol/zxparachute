#!/bin/bash

sjasmplus parachute.asm

file_size=$(stat -c%s "bin/parachutecode.bin")
SIZELO=$((file_size % 256))
SIZEHI=$((file_size / 256))

cat > parachute.bas <<EOF
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
170 data 17,$SIZELO, $SIZEHI
180 data 62,255
190 data 55
200 data 205,86,5
300 data 195,0,128
EOF

./tools/zmakebas -a 10 -n "ZXParachute" -o bin/loader.tap parachute.bas
./tools/bin2tap  bin/screen.bin bin/screen.tap screen 16384 n
./tools/bin2tap  bin/parachutecode.bin bin/parachutecode.tap data 32768 n

cat bin/loader.tap bin/screen.tap bin/parachutecode.tap > bin/parachute.tap
#tape2wav bin/parachute.tap bin/parachute.wav

#/home/carles/opt/rvm/2.0/RetroVirtualMachine -boot=zx48k -i bin/parachute.tap -play -c='j ""\n'