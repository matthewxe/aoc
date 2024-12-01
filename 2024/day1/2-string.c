#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// 2.c but it uses string.h

int similarity_score(FILE *file);
short *generate_map(FILE *file);
int find_gap(char *line);
void *recalloc(void *PTR, unsigned long ORIGINAL_NMEMB, unsigned long NMEMB,
	       unsigned long SIZE);

int main(int argc, char *argv[])
{
	// Pass in the file as an argument
	if (argc != 2) {
		return 1;
	}
	FILE *file;
	file = fopen(argv[1], "r");
	if (file == NULL) {
		return 2;
	}

	printf("similarity_score: %i\n", similarity_score(file));

	fclose(file);
	return 0;
}

/* Takes in a readable file
 * Returns the similarity score of given file based on AOC2024-Day1 Part 2
 */
int similarity_score(FILE *file)
{
	short *map = generate_map(file);

	char line[69];
	int score = 0;
	while (fgets(line, 69, file)) {
		int num = atoi(line);
		score += (num * map[num]);
		// printf("%i, %i\n", num, map[num]);
	}
	// rewind(file);

	free(map);
	return score;
}

/* Return a map where map[INDEX] corresponds to the how many times INDEX
 * occurs on the right list.
 * Needs to be freed after use
 */
short *generate_map(FILE *file)
{
	char line[69];

	size_t map_size = 128;
	short *map = calloc(map_size, sizeof(short));

	for (int i = 0; fgets(line, 69, file); i++) {
		int num = atoi(strchr(line, ' '));
		while (num > map_size) {
			map = recalloc(map, map_size, map_size * 2,
				       sizeof(short));
			map_size *= 2;
		}
		map[num]++;
	};
	rewind(file);

	return map;
}

/* Reimplementation of realloc that also initializes to 0.
 * Should ONLY be used when resizing an already malloc'd array
 */
void *recalloc(void *PTR, unsigned long ORIGINAL_NMEMB, unsigned long NMEMB,
	       unsigned long SIZE)
{
	void *NEW_PTR = calloc(NMEMB, SIZE);
	memcpy(PTR, NEW_PTR, ORIGINAL_NMEMB);
	free(PTR);
	return NEW_PTR;
};
