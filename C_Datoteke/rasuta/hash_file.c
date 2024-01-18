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
