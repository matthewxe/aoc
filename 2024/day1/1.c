#include <stdio.h>
#include <stdlib.h>

int compare(const void *a, const void *b) { return (*(int *)a > *(int *)b); }
int find_gap(char *line);

int main(int argc, char *argv[])
{
	if (argc != 2) {
		return 1;
	}
	FILE *file;
	file = fopen(argv[1], "r");
	if (file == NULL) {
		return 2;
	}
	char codes[69];
	int list_1[69420] = {0};
	int list_2[69420] = {0};
	int *list_1_ptr = list_1;
	int *list_2_ptr = list_2;
	int length = 0;

	while (fgets(codes, 69, file)) {
		*list_1_ptr = atoi(codes);
		*list_2_ptr = atoi(codes + find_gap(codes));
		list_1_ptr++;
		list_2_ptr++;
		length++;
	}

	qsort(list_1, length, sizeof(int), *compare);
	qsort(list_2, length, sizeof(int), *compare);

	int total_distance = 0;
	for (int i = 0; i < length; i++) {
		total_distance += abs(list_1[i] - list_2[i]);
	}
	printf("total:distance: %i\n", total_distance);
	return 0;
}

int find_gap(char *line)
{
	for (int i = 0; line[i]; i++) {
		if (line[i] == ' ') {
			return i;
		}
	}
	return -1;
}
