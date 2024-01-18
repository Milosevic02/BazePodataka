#include "hash_file.h"

#include <stdio.h>
#include <stdlib.h>

#define OVERFLOW_FILE_NAME "overflow.dat"

int createHashFile(FILE *pFile){
    Bucket *emptyContent = calloc(B,sizeof(Bucket));
    fseek(pFile,0,SEEK_SET);
    int retVal = fwrite(emptyContent,sizeof(Bucket),B,pFile);
    free(emptyContent);
    return retVal;
}

int readBucket(FILE *pFile,Bucket *pBucket,int bucketIndex){
    fseek(pFile,bucketIndex * sizeof(Bucket),SEEK_SET);
    return fread(&pBucket,sizeof(Bucket),1,pFile) == 1;
}

FindRecordResult findRecord(FILE *pFile,int key){
    int bucketIndex = transformKey(key);
    int initialIndex = bucketIndex;
    Bucket bucket;
    FindRecordResult retVal;

    retVal.ind1 = 99;
    retVal.ind2 = 0;

    while(retVal.ind1 == 99){
        int q = 0;
        readBucket(pFile,&bucket,bucketIndex);
        retVal.bucket = bucket;
        retVal.bucketIndex = bucketIndex;

        while(q < BUCKET_SIZE && retVal.ind1 == 99){
            Record record = bucket.records[q];
            retVal.record = record;
            retVal.recordIndex = q;

            if(key == record.key && record.status != EMPTY){
                retVal.ind1 = 0;
            }else if(record.status == EMPTY){
                retVal.ind1 = 1;
            }else{
                q++;
            }
        }

        if(q >= BUCKET_SIZE){
            bucketIndex = nextBucketIndex(bucketIndex);

            if(bucketIndex == initialIndex){
                retVal.ind1 = 1;
                retVal.ind2 = 1;
            }
        }

    }
    return retVal;
}
