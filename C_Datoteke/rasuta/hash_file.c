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

int alreadyExistsForInsert(FindRecordResult findResult){
    if(findResult.ind1 == 0){
        return 1;
    }
    return 0;
}

int saveBucket(FILE *pFile,Bucket* pBucket,int bucketIndex){
    fseek(pFile,bucketIndex * sizeof(Bucket),SEEK_SET);
    int retVal = fwrite(pBucket,sizeof(Bucket),1,pFile) == 1;
    fflush(pFile);
    return retVal;
}


int insertRecord(FILE *pFile,Record record){
    record.status = ACTIVE;
    FindRecordResult findResult = findRecord(pFile,record.key);

    if(alreadyExistsForInsert(findResult)){
        return -1;
    }
    if(findResult.ind2 == 1){
        puts("Unos nemoguc. Datoteka popnjena");
        return -1;
    }

    findResult.bucket.records[findResult.recordIndex] = record;

    if(saveBucket(pFile,&findResult.bucket,findResult.bucketIndex)){
        return findResult.bucketIndex;
    }else{
        return -2;
    }

}

void printContent(FILE *pFile) {
    int i;
    Bucket bucket;

    for (i = 0; i < B; i++) {
        readBucket(pFile, &bucket, i);
        printf("\n####### BUCKET - %d #######\n", i+1);
        printBucket(bucket);
    }
}

int alreadyExistsForModify(FindRecordResult findResult) {
    if (findResult.ind1) {                              // da li je bilo neuspesno trazenje
        return 0;                                       // slog nije pronadjen
    }

    #ifdef LOGICAL                                      /* za verziju sa logickim brisanjem */
    if (findResult.record.status == DELETED) {          // da li pronadjeni slog logicki obrisan
        return 0;                                       // slog nije pronadjen
    }
    #endif

    return 1;
}

int modifyRecord(FILE *pFile,Record record){
    record.status = ACTIVE;
    FindRecordResult findResult = findRecord(pFile,record.key);
    if (!alreadyExistsForModify(findResult)) {                          // ukoliko slog nije pronadjen ili je logicki obrisan
        return -1;
    }
    findResult.bucket.records[findResult.recordIndex] = record;

    if(saveBucket(pFile,&findResult.bucket,findResult.bucketIndex)){
        return findResult.bucketIndex;
    }else{
        return -2;
    }
}


















