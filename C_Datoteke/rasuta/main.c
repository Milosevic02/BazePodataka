#include <stdio.h>
#include <stdlib.h>

#include "hash_file.h"
#include "bucket.h"

#define LEN 30
#define DEFAULT_FILENAME "test.dat"
#define DEFAULT_INFILENAME "in.dat"

int menu();
FILE *safeFopen(char filename[]);
void handleResult(int returnCode);
void handleFindResult(FindRecordResult findResult);
void fromTxtToSerialFile(FILE *pFtxt, FILE *pFbin);

int main() {
    FILE *pFile = safeFopen(DEFAULT_FILENAME), *pInputSerialFile, *pInputTxtFile;
    char filename[LEN];
    int option = -1, key;
    Record record;

    while (option) {
        option = menu();
        switch (option) {
        case 1:
            if (pFile != NULL) fclose(pFile);
            printf("\nUnesite naziv datoteke: ");
            scanf("%s", filename);
            pFile = safeFopen(filename);
            break;
        case 2:
            record = scanRecord(WITHOUT_KEY);
            handleResult(insertRecord(pFile,record));
            break;
        case 3:
            key = scanKey();
            FindRecordResult findResult = findRecord(pFile,key);

            if(findResult.ind1 != RECORD_FOUND || findResult.record.status != ACTIVE){
                puts("Neuspesno trazenje");

            }else{
                printRecord(findResult.record,WITHOUT_HEADER);
                record = scanRecord(WITHOUT_KEY);
                record.key = key;
                handleResult(modifyRecord(pFile,record));
            }
            break;
        case 4:
            key = scanKey();
            handleResult(removeRecord(pFile, key));
            break;
        case 5:
            printf("key = ");
            scanf("%d", &key);
            handleFindResult(findRecord(pFile, key));
            break;
        case 6:
            printContent(pFile);
        default:
            break;
        }
    }

    if (pFile != NULL) fclose(pFile);

    return 0;
}

int menu() {
    int option;

    puts("\n\nIzaberite opciju:");
    puts("\t1. Otvaranje datoteke");
    puts("\t2. Unos novog sloga");
    puts("\t3. Modifikacija sloga");
    puts("\t4. Brisanje sloga");
    puts("\t5. Trazenje sloga");
    puts("\t6. Prikaz sadrzaja datoteke");
    puts("\t7. Formiranje u dva prolaza");
    puts("\t0. Kraj programa");

    printf(">>");

    scanf("%d", &option);

    return option;
}

FILE *safeFopen(char filename[]) {
    FILE *pFile;

    pFile = fopen(filename, "rb+");

    if (pFile == NULL) {                        // da li datoteka sa tim imenom vec postoji
        pFile = fopen(filename, "wb+");     // ako ne, otvara se za pisanje
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

void handleResult(int returnCode){
    if(returnCode <0){
        puts("Operacija neuspesna");
    }else{
        puts("Operacija uspesna");
    }
}

void handleFindResult(FindRecordResult findResult) {
    if (findResult.ind1 != RECORD_FOUND) {
        puts("Neuspesno trazenje.");
    } else {
        printRecord(findResult.record, WITH_HEADER);
    }
}



