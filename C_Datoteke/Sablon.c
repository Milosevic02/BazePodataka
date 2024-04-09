//*************ODABIR DATOTEKE ***************************

FILE *safeFopen(char filename[]) {
    FILE *pFile;

    pFile = fopen(fullFilename, "rb+");

    if (pFile == NULL) {                        // da li datoteka sa tim imenom vec postoji
        pFile = fopen(fullFilename, "wb+");     // ako ne, otvara se za pisanje
        createHashFile(pFile);                  // i kreira prazna rasuta organizacija
        puts("Kreirana prazna datoteka.");
    } else {
        puts("Otvorena postojeca datoteka.");   // ako da, koristi se postojeca datoteka
    }

    if (pFile == NULL) {
        printf("Nije moguce otvoriti/kreirati datoteku: %s.\n", filename);
    }

    return pFile;
}

int createHashFile(FILE *pFile) {
    Bucket *emptyContent = calloc(B, sizeof(Bucket));               // calloc inicializuje zauzeti
    fseek(pFile, 0, SEEK_SET);                                      // memorijski prostor nulama
    int retVal = fwrite(emptyContent, sizeof(Bucket), B, pFile);
    free(emptyContent);
    return retVal;
}

//*******************POMOCNE READ WRITE*****************************
int saveBucket(FILE *pFile, Bucket* pBucket, int bucketIndex) {
    fseek(pFile, bucketIndex * sizeof(Bucket), SEEK_SET);
    int retVal = fwrite(pBucket, sizeof(Bucket), 1, pFile) == 1;
    fflush(pFile);
    return retVal;
}

int readBucket(FILE *pFile, Bucket *pBucket, int bucketIndex) {
    fseek(pFile, bucketIndex * sizeof(Bucket), SEEK_SET);
    return fread(pBucket, sizeof(Bucket), 1, pFile) == 1;
}

//*******************PRETRAGA DATOTEKE***************************
FindRecordResult findRecord(FILE *pFile, int key) {
    int bucketIndex = transformKey(key);                            // transformacija kljuca u redni broj baketa
    int initialIndex = bucketIndex;                                 // redni broj maticnog baketa
    Bucket bucket;
    FindRecordResult retVal;

    retVal.ind1 = 99;                                               // indikator uspesnosti trazenja
    retVal.ind2 = 0;                                                // indikator postojanja slobodnih lokacija

    while (retVal.ind1 == 99) {
        int q = 0;                                                  // brojac slogova unutar baketa
        readBucket(pFile, &bucket, bucketIndex);                    // citanje baketa
        retVal.bucket = bucket;
        retVal.bucketIndex = bucketIndex;

        while (q < BUCKET_SIZE && retVal.ind1 == 99) {
            Record record = bucket.records[q];
            retVal.record = record;
            retVal.recordIndex = q;

            if (key == record.key && record.status != EMPTY) {
                retVal.ind1 = 0;                                    // uspesno trazenje
            } else if (record.status == EMPTY) {
                retVal.ind1 = 1;                                    // neuspesno trazenje
            } else {
                q++;                                                // nastavak trazenja
            }
        }

        if (q >= BUCKET_SIZE) {
            bucketIndex = nextBucketIndex(bucketIndex);             // prelazak na sledeci baket

            if (bucketIndex == initialIndex) {
                retVal.ind1 = 1;                                    // povratak na maticni baket
                retVal.ind2 = 1;
            }
        }
    }

    return retVal;
}

//***************************UNOS NOVOG *****************************
int insertRecord(FILE *pFile, Record record) {
    record.status = ACTIVE;
    FindRecordResult findResult = findRecord(pFile, record.key);

    if (alreadyExistsForInsert(findResult)) {                           // ukoliko slog sa datim kljucem vec postoji
        return -1;
    }

    if (findResult.ind2 == 1) {
        puts("Unos nemoguc. Datoteka popunjena.");
        return -1;
    }

    findResult.bucket.records[findResult.recordIndex] = record;         // upis sloga u baket na mesto gde je neuspesno zavrseno trazenje
                                                                        // ili aktivacija pothodno logicki obrisanog sloga sa istim kljucem

    if(saveBucket(pFile, &findResult.bucket, findResult.bucketIndex)) { // upis baketa u datoteku
        return findResult.bucketIndex;                                  // ukoliko je unos uspesan, povratna vrednost je redni broj baketa
    } else {
        return -2;
    }
}


//***************************IZMENA SLOGA *****************************
int modifyRecord(FILE *pFile, Record record) {
    record.status = ACTIVE;
    FindRecordResult findResult = findRecord(pFile, record.key);

    if (!alreadyExistsForModify(findResult)) {                          // ukoliko slog nije pronadjen ili je logicki obrisan
        return -1;
    }

    findResult.bucket.records[findResult.recordIndex] = record;         // upis sloga u baket na mesto gde je pronadjen

    if(saveBucket(pFile, &findResult.bucket, findResult.bucketIndex)) { // upis baketa u datoteku
        return findResult.bucketIndex;                                  // ukoliko je modifikacija uspesna, povratna vrednost je redni broj baketa
    } else {
        return -2;
    }
}


//***************************LOGICKO BRISANJE*****************************
int removeRecordLogically(FILE *pFile, int key) {
    FindRecordResult findResult = findRecord(pFile, key);

    if (findResult.ind1) {
        return -1;                                                      // slog nije pronadjen
    }

    findResult.bucket.records[findResult.recordIndex].status = DELETED; // logicko brisanje sloga

    if(saveBucket(pFile, &findResult.bucket, findResult.bucketIndex)) { // upis baketa u datoteku
        return findResult.bucketIndex;                                  // ukoliko je brisanje uspesno, povratna vrednost je redni broj baketa
    } else {
        return -2;
    }
}

//***************************ISPIS*****************************
int nextBucketIndex(int currentIndex) {
    return (currentIndex + STEP) % B;
}

void printHeader() {
    printf("status \t key \t code \t date\n");
}

void printRecord(Record record, int header) {
    if (header) printHeader();
    printf("%d \t %d \t %s \t %s\n", record.status, record.key, record.code, record.date);
}

void printBucket(Bucket bucket) {
    int i;
    printHeader();
    for (i = 0; i < BUCKET_SIZE; i++) {
        printRecord(bucket.records[i], WITHOUT_HEADER);
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

//***************************UNOS U DVA PROLAZA *****************************
        case 7:
            pInputTxtFile = fopen("in.txt", "r");
            pInputSerialFile = fopen(DEFAULT_INFILENAME, "wb+");
            fromTxtToSerialFile(pInputTxtFile, pInputSerialFile);
            rewind(pInputSerialFile);
            initHashFile(pFile, pInputSerialFile);
            fclose(pInputSerialFile);
            remove(DEFAULT_INFILENAME);
            break;

void fromTxtToSerialFile(FILE *pInputTxtFile, FILE *pOutputSerialFile) {
    Record r;
    while(fscanf(pInputTxtFile, "%d%s%s", &r.key, r.code, r.date) != EOF) {
        fwrite(&r, sizeof(Record), 1, pOutputSerialFile);
    }
}

int readRecordFromSerialFile(FILE *pFile, Record *pRecord) {
    return fread(pRecord, sizeof(Record), 1, pFile);
}

int saveRecordToOverflowFile(FILE *pFile, Record *pRecord) {
    return fwrite(pRecord, sizeof(Record), 1, pFile);
}

int isBucketFull(Bucket bucket) {
    return bucket.records[BUCKET_SIZE - 1].status != EMPTY;
}

int initHashFile(FILE *pFile, FILE *pInputSerialFile) {
    if (feof(pFile)) {
        createHashFile(pFile);
    }

    FILE *pOverflowFile = fopen(OVERFLOW_FILE_NAME, "wb+");
    Record r;

    while(readRecordFromSerialFile(pInputSerialFile, &r)) {
        int h = transformKey(r.key);

        Bucket bucket;
        readBucket(pFile, &bucket, h);
        if (isBucketFull(bucket)) {                             // ukoliko nema mesta u maticnom baketu
            saveRecordToOverflowFile(pOverflowFile, &r);        // slog se smesta u privremenu
        } else {                                                // serijsku datoteku prekoracilaca
            insertRecord(pFile, r);
        }
    }

    fclose(pInputSerialFile);
    rewind(pOverflowFile);

    while(readRecordFromSerialFile(pOverflowFile, &r)) {         // upis prekoracilaca
        insertRecord(pFile, r);
    }

    fclose(pOverflowFile);                                       // zatvaranje i brisanje privremene
    remove(OVERFLOW_FILE_NAME);                                  // serijske datoteke prekoracilaca

    return 0;
}
