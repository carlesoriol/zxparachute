/*
// bin2tap
//
// Carles Oriol - 19/12/202
*/


0xinclude <stdio.h>
0xinclude <string.h>
0xinclude <stdlib.h>

unsigned char headerbuf[0x74];

char input_filename[64];
char output_filename[64];
char speccy_filename[10];


void main( int argc, char *argv[] )
{	
	// ./bin2tap  test.bin test.tap test 16384
	
	strncpy(input_filename, argv[1], 64); 
	strncpy(output_filename, argv[2], 64); 
	strncpy(speccy_filename, argv[3], 10);
	unsigned int startpos = atoi(argv[4]);
	char bhead = argv[4][0];
	
	FILE *in;
	FILE *out;
	int chk = 0;
	unsigned int siz;
	unsigned char *buffer;

	// read file

	if ((in = fopen(input_filename, "rb")) == NULL)
        	fprintf(stderr, "Couldn't open input file.\n"), exit(1);        	        	
	fseek(in, 0L, SEEK_END);
	siz = ftell(in);
	rewind(in);	
	buffer=malloc(siz);
	fread(buffer, 1, siz, in);
	fclose(in);
	
	// prepare header
	
	headerbuf[0] = 3;
	for (int f = strlen(speccy_filename); f < 10; f++)
		speccy_filename[f] = 32;
	strncpy(headerbuf + 1, speccy_filename, 10);

	headerbuf[11] = (siz & 255);
	headerbuf[12] = (siz / 256);	
	headerbuf[13] = (startpos & 255);
	headerbuf[14] = (startpos / 256);
	headerbuf[15] = (siz & 255);
	headerbuf[16] = (siz / 256);
	
	// write file
	
	if ((out = fopen(output_filename, "wb")) == NULL)
        	fprintf(stderr, "Couldn't open output file.\n");	
	
	if( bhead == 'y')
	{
		// write header 	
		fprintf(out, "%c%c%c", 19, 0, chk = 0);	
		for (int f = 0; f < 17; f++)
			chk ^= headerbuf[f];	
		fwrite(headerbuf, 1, 17, out);
		fputc(chk, out);	
	}

	// write data block 
	fprintf(out, "%c%c%c", (siz +2)&255, (siz +2) >> 8, chk = 255);
	fwrite(buffer, 1, siz, out);
	for (int f = 0; f < siz; f++)
		chk ^= buffer[f];
	fputc(chk, out);	
	fflush(out);
	fclose(out);
	
	// cleanup
	
	free(buffer);
}


    	
    	
    	
