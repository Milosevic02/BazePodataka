//FILE *otvoriDatoteku(char *filename);
//void kreirajDatoteku(char *filename);
//SLOG *pronadjiSlog(FILE *fajl, char *evidBroj);
//void dodajSlog(FILE *fajl, SLOG *slog);
//void ispisiSveSlogove(FILE *fajl);
//void ispisiSlog(SLOG *slog);
//void azurirajSlog(FILE *fajl, char *evidBroj, char *oznakaCelije, int duzinaKazne);
//void obrisiSlogLogicki(FILE *fajl, char *evidBroj);
//void obrisiSlogFizicki(FILE *fajl, char *evidBroj);
#include "operacije_nad_datotekom.h"

FILE *otvoriDatoteku(char *filename){
    FILE *fajl = fopen(filename,"rb+");
    if(fajl == NULL){
        printf("Doslo je do greske! Moguce da datoteka \"%s\" ne postoji.\n", filename);
    }else{
        printf("Datoteka \"%s\" otvorena.\n", filename);

    }
    return fajl;
}

void kreirajDatoteku(char* filename){
    FILE *fajl = fopen(filename,"wb");
    if(fajl == NULL){
		printf("Doslo je do greske prilikom kreiranja datoteke \"%s\"!\n", filename);
    }else{
        BLOK blok;
        strcpy(blok.slogovi[0].evidBroj,OZNAKA_KRAJA_DATOTEKE);
        fwrite(&blok,sizeof(BLOK),1,fajl);
        		printf("Datoteka \"%s\" uspesno kreirana.\n", filename);
		fclose(fajl);
    }
}

SLOG *pronadjiSlog(FILE *fajl,char *evidBroj){
    if(fajl == NULL){
        return NULL;
    }
    fseek(fajl,0,SEEK_SET);
    BLOK blok;

    while(fread(&blok,sizeof(BLOK),1,fajl)){
        for(int i = 0;i<FBLOKIRANJA;i++){
            if(strcmp(blok.slogovi[i].evidBroj,OZNAKA_KRAJA_DATOTEKE) == 0){
                return NULL;
            }
            if(strcmp(blok.slogovi[i].evidBroj,evidBroj) == 0 && !blok.slogovi[i].deleted){
                SLOG *slog = (SLOG*)malloc(sizeof(SLOG));
                memcpy(slog,&blok.slogovi[i],sizeof(SLOG));
                return slog;
            }
        }

    }
    return NULL;
}

void dodajSlog(FILE *file,SLOG *slog){
    if(fajl == NULL){
        printf("Datoteka nije otvorena!\n");
        return;
    }

    SLOG *slogStari == pronadjiSlog(fajl,slog->evidBroj);
    if(slogStari != NULL){
        printf("Vec postoji slog sa tim evid brojem!\n");
        return;
    }

    BLOK blok;
    fseek(fajl,-sizeof(BLOK),SEEK_END);
    fread(&blok,sizeof(BLOK),1,fajl);

    int i;
    for(i = 0;i<FBLOKIRANJA;i++){
        if(strcmp(blok.slogovi[i].evidBroj,OZNAKA_KRAJA_DATOTEKE) == 0){
            memcpy(&blok.slogovi[i],slog,sizeof(SLOG));
            break;
        }
    }

    i++;

    if(i<FBLOKIRANJA){
        strcpy(blok.slogovi[i].evidBroj,OZNAKA_KRAJA_DATOTEKE);

        fseek(fajl,-sizeof(BLOK),SEEK_CUR);
        fwrite(&blok,sizeof(BLOK),1,fajl);
    }else{
        fseek(fajl,-sizeof(BLOK),SEEK_CUR);
        fwrite(&blok,sizeof(BLOK),1,fajl);

        BLOK noviBlok;
        strcpy(noviBlok.slogovi[0].evidBroj,OZNAKA_KRAJA_DATOTEKE);
        fwrite(&noviBlok,sizeof(BLOK),1,fajl);
    }

	if (ferror(fajl)) {
		printf("Greska pri upisu u fajl!\n");
	} else {
		printf("Upis novog sloga zavrsen.\n");
	}
}

void ispisiSveSlogove(FILE *fajl){
    if(fajl == NULL){
        printf("Datoteka nije otvorena\n");
        return;
    }

    fseek(fajl,0,SEEK_SET);
    BLOK blok;
    int rbBloka = 0;
    printf("BL SL Evid.Br   Sif.Zat      Dat.Vrem.Dol  Celija  Kazna\n");
    while(fread(&blok,sizeof(BLOK),1,fajl)){
        for(int i = 0;i<FBLOKIRANJA;i++){
            if(strcmp(blok.slogovi[i].evidBroj,OZNAKA_KRAJA_DATOTEKE) == 0){
                printf("B%d S%d *\n", rbBloka, i);
                break;
            }

            if(!blok.slogovi[i].deleted){
                printf("B%d S%d",rbBloka,i);
                ispisiSlog(&blok.slogovi[i]);
                printf("\n");
            }
        }
        rbBloka++;
    }
}

void ispisiSlog(SLOG *slog){
	printf("%8s  %7s  %02d-%02d-%4d %02d:%02d %7s %6d",
        slog->evidBroj,
		slog->sifraZatvorenika,
		slog->datumVremeDolaska.dan,
		slog->datumVremeDolaska.mesec,
		slog->datumVremeDolaska.godina,
		slog->datumVremeDolaska.sati,
		slog->datumVremeDolaska.minuti,
		slog->oznakaCelije,
		slog->duzinaKazne);
}













