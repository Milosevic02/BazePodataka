#include <stdio.h>
#include <stdlib.h>

#include "hash_file.h"
#include "bucket.h"

#define LEN 30
#define DATA_DIR "data"                    // poseban direktorijum za datoteke
#define LS_CMD "dir "DATA_DIR""            // komanda za prikaz svih datoteka
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
            puts("Postojece datoteke:");
            system(LS_CMD);
            if (pFile != NULL) fclose(pFile);
            printf("\nUnesite naziv datoteke: ");
            scanf("%s", filename);
            pFile = safeFopen(filename);
            break;

        case 2:
            record = scanRecord(WITH_KEY);
            handleResult(insertRecord(pFile, record));
            break;

        case 3:
            key = scanKey();
            FindRecordResult findResult = findRecord(pFile, key);

            if (findResult.ind1 != RECORD_FOUND || findResult.record.status != ACTIVE) {
                puts("Neupesno trazenje.");
            } else {
                printRecord(findResult.record, WITH_HEADER);
                record = scanRecord(WITHOUT_KEY);
                record.key = key;
                handleResult(modifyRecord(pFile, record));
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
            break;

        case 7:
            pInputTxtFile = fopen("in.txt", "r");
            pInputSerialFile = fopen(DEFAULT_INFILENAME, "wb+");
            fromTxtToSerialFile(pInputTxtFile, pInputSerialFile);
            rewind(pInputSerialFile);
            initHashFile(pFile, pInputSerialFile);
            fclose(pInputSerialFile);
            remove(DEFAULT_INFILENAME);
            break;

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


