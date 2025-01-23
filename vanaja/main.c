#include <stdio.h>
#include <time.h>

int main() {
    time_t currentTime = time(NULL);
    currentTime += 3 * 24 * 60 * 60;
    char dateString[20];
    strftime(dateString, 20, "%Y-%m-%d", localtime(&currentTime));
    printf("Current date: %s\n", dateString);

    return 0;
}
