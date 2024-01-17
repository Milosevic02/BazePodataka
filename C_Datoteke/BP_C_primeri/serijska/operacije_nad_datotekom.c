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

}
