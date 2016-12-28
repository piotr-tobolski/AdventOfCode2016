#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>
#include <CommonCrypto/CommonCrypto.h>

const char *doorID = "abc";//"abbhdwsy";
char result[9];
char result2[9] = "        ";
int resultIndex = 0;
int result2Count = 0;
const int numberOfThreads = 8;
struct timespec start;

void *checkMD5(void *args)
{
    int i = (int)args;

    for (int index = i; result2Count <8; index += numberOfThreads)
    {
    char doorIDWithIndex[20];
    sprintf(doorIDWithIndex, "%s%i", doorID, index);
    uint8_t md5[16];
    CC_MD5(doorIDWithIndex, (CC_LONG)strlen(doorIDWithIndex), md5);

    if (md5[0] == 0 && md5[1] == 0 && (md5[2] & 0xF0) == 0)
    {
        // printf("%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X\n", md5[0], md5[1], md5[2], md5[3], md5[4], md5[5], md5[6], md5[7], md5[8], md5[9], md5[10], md5[11], md5[12], md5[13], md5[14], md5[15]);

        char sixthCharacter[2] = {0, 0};
        sprintf(sixthCharacter, "%x", md5[2]);
        printf("%i: %s\n", i, sixthCharacter);

        if (resultIndex < 8)
        {
            result[resultIndex] = sixthCharacter[0];
            resultIndex++;
            if (resultIndex == 8)
            {
                printf("%s\n", result);
            }
        }

        int result2Index = atoi(sixthCharacter);
        if (result2Index < 8 && result2[result2Index] == ' ')
        {
            char seventhCharacter[2] = {0, 0};
            sprintf(seventhCharacter, "%x", (md5[3] >> 4) & 0x0F);
            // printf("%s\n", sixthCharacter);

            result2[result2Index] = seventhCharacter[0];
            result2Count++;
            if (result2Count == 8)
            {
                printf("%s\n", result2);
            }
        }
    }
    }

    return NULL;
}

int main(int argc, const char * argv[]) {
    clock_gettime(CLOCK_MONOTONIC, &start);
    result[8] = 0;
    pthread_t threadIDs[numberOfThreads];

    for (long long i = 0; i < numberOfThreads; i++)
    {
        pthread_create(threadIDs + i, NULL, checkMD5, (void *)i);
    }

    for (int i = 0; i < numberOfThreads; i++)
    {
        pthread_join(threadIDs[i], NULL);
    }

    struct timespec finish;
    clock_gettime(CLOCK_MONOTONIC, &finish);

    float elapsed = (finish.tv_sec - start.tv_sec);
    elapsed += (finish.tv_nsec - start.tv_nsec) / 1000000000.0;
    printf("%.3f\n", elapsed);

    return 0;
}
