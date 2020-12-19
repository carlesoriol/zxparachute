#!/bin/sh

gcc zmakebas.c -o zmakebas
gcc bin2tap.c -o bin2tap

./zmakebas -a 10 -n "ZXParachute" -o loader.tap parachute.bas

# in rvm
# save d4000_screen.bin #4000 6912
# save d5ccb_data.bin #5ccb 4321
# save d7c7c_int.bin #7c7c 732
# save d4000_data.bin #4000 11692
# lliure 6DAC 28076 fins a 31868


./bin2tap  d4000_screen.bin screen.tap screen 16384 n
./bin2tap  d7c7c_int.bin int.tap int 31868 n
./bin2tap  d4000_data.bin data.tap data 23755 n

cat loader.tap data.tap int.tap > parachute.tap

#rm screen.tap data.tap int.tap loader.tap

cp parachute.tap bin/



#RetroVirtualMachine -boot=zx48k -i simon.tap -play -c='j ""\n'


