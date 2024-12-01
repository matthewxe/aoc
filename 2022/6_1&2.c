#include <stdio.h>
#include <string.h>

/* I got intersted by the primeagen's video about speed in algorithms and I
 * wan't to try what I first thought of doing on my own
 * https://www.youtube.com/watch?v=U16RnpV48KQ
 * And be it actually readable to people :D
 */

/* I got 460 µs!    (± 125 µs)
 * Aaand primeagen's fast array got avg of 430µs!
 * (Both done in average of 10000 runs)
 * So I got a very similar speed which means my brain actally has some merit :D
 */

// #define MARKERLENGTH 4
#define MARKERLENGTH 14
unsigned long get_index(char *stream);
int check_buffer(char *stream, unsigned long idx);
int main(int argc, char *argv[])
{
	FILE *input;

	if (argc != 2) {
		return 1;
	}

	printf("%li\n", get_index(argv[1]));

	return 0;
}

unsigned long get_index(char *stream)
{
	// Get length
	unsigned long length = strlen(stream);
	// For loop up to the last 14 characters
	for (unsigned long idx = 0; idx < length - MARKERLENGTH + 1; idx++) {
		// Every single one you check if that char[14] is correct
		if (check_buffer(stream, idx) == 0) {
			return idx + MARKERLENGTH;
		}
	}
	return 0;
}

int check_buffer(char *stream, unsigned long idx)
{
	// Define the buffer char[14]
	char buffer[MARKERLENGTH] = {0};
	// Loop for the entire buffer 'chunk' at the index
	for (unsigned long buf_idx = idx; buf_idx < (idx + MARKERLENGTH);
	     buf_idx++) {
		// Define current
		char current = stream[buf_idx];
		// Loop for every previous already read through buffers
		for (unsigned long check_idx = idx; check_idx < buf_idx;
		     check_idx++) {
			// Check if char current is in the buffer
			if (current == buffer[check_idx - idx]) {
				// If yes then return to go to the next idx
				return 1;
			}
		}
		// Since crrent is not inside buffer, add it to buffer
		buffer[buf_idx - idx] = current;
	}
	// If there is not a single one in crrent was inside buffer then it
	// returns okay
	return 0;
}

/* main using file input instead of argv
int main() {}
	FILE *input;

	if (argc != 2) {
		input = fopen("6_1.txt", "r");
	} else {
		input = fopen(argv[1], "r");
	}

	if (input == NULL) {
		return 1;
	}

	char *stream = 0;

	fseek(input, 0, SEEK_END);
	int streamlength = ftell(input);
	fseek(input, 0, SEEK_SET);

	stream = malloc(streamlength);
	if (stream) {
		fread(stream, 1, streamlength, input);
	}
	fclose(input);

	printf("%s", stream);
	printf("%i\n", get_index(stream));

	return 0;
} */
