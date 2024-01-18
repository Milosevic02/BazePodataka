#include "bucket.h"

#include <stdio.h>

Record scanRecord(int withKey){
    Record record;

    printf("\nUnesite slog:\n");

    if(withKey){
        printf("key = ");
        scanf("%d",&record.key);
    }

    printf("code = ");
    scanf("%s",&record.code);
    printf("data = ");
    scanf("%s",&record.date);

    return record;
}

int transformKey(int id) {
    return id % B;
}

int nextBucketIndex(int currentIndex){
    return (currentIndex + STEP) % B;
}

