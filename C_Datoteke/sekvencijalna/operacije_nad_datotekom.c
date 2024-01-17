FILE *otvoriDatoteku(char *filename){
        FILE *fajl = fopen(filename,"rb+");
        if(fajl == NULL){
            printf("Doslo je do greske pri otvaranju datoteke \"%s\"! Moguce da datoteka ne postoji.\n", filename);
        }else{
            printf("Datoteka \"%s\" uspesno otvorena!\n", filename);
        }
        return fajl;
}

void kreirajDatoteku(char *filename){
    FILE *fajl = fopen(filename,"wb");
    if(fajl == NULL){
        printf("Doslo je do greske prilikom kreiranja datoteke \"%s\"!\n", filename);
    }
    else{
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

    while(fread(&blok,sizeof(blok),1,fajl)){
        for(int i = 0;i<FBLOKIRANJA;i++){
            if(strcmp(blok.slogovi[i].evidBroj,evidBroj) == 0){
                if(!blok.slogovi[i].deleted){
                    SLOG *slog = (SLOG*)malloc(sizeof(SLOG));
                    memcpy(slog,&blok.slogovi[i],sizeof(SLOG));
                    return slog;
                }
            }else if(strcmp(blok.slogovi[i].evidBroj,OZNAKA_KRAJA_DATOTEKE) == 0)
                    || atoi(blok.slogovi[i].evidBroj) > atoi(evidBroj)){
                return NULL;
            }
        }
    }
    return NULL;
}

SLOG *pronadjiSlogEX(FILE *fajl, char *evidBroj) {
    //radi isto kao pronadjiSlog, samo sto uzima u obzir i logicki
    //izbrisane slogove (koristi se u funkciji obrisiSlogFizicki,
    //jer se ta funkcija poziva iz regorganizacije da fizicki
    //obrise logicki obrisane slogove)

	if (fajl == NULL) {
		return NULL;
	}

	fseek(fajl, 0, SEEK_SET);
	BLOK blok;

	while (fread(&blok, sizeof(BLOK), 1, fajl)) {

		for (int i = 0; i < FBLOKIRANJA; i++) {
			if (strcmp(blok.slogovi[i].evidBroj, OZNAKA_KRAJA_DATOTEKE) == 0 ||
                atoi(blok.slogovi[i].evidBroj) > atoi(evidBroj)) {
				//Nema vise slogova posle sloga sa oznakom kraja datoteke,
                //ili smo stigli do sloga sa vrednoscu kljuca vecom od vrednosti
                //kljuca sloga koji dodajemo u datoteku.

				return NULL;

			} else if (strcmp(blok.slogovi[i].evidBroj, evidBroj) == 0) {
				//Pronadjen trazeni slog
                SLOG *slog = (SLOG *)malloc(sizeof(SLOG));
                memcpy(slog, &blok.slogovi[i], sizeof(SLOG));
                return slog;

			}
		}
	}

	return NULL;
}

void dodajSlog(FILE *fajl,SLOG *slog){
    if (fajl == NULL) {
		printf("Datoteka nije otvorena!\n");
		return;
	}

	SLOG slogKojiUpisujemo;
	memcpy(&slogKojiUpisujemo,slog,sizeof(SLOG));

	BLOK blok;
	fseek(fajl,0,SEEK_SET);
	while(fread(&blok,sizeof(BLOK),1,fajl)){
        for(int i = 0;i<FBLOKIRANJA;i++){
            if(strcmp(blok.slogovi[i].evidBroj,OZNAKA_KRAJA_DATOTEKE) == 0){
                memcpy(&blok.slogovi[i],&slogKojiUpisujemo,sizeof(SLOG));

                if(i!= FBLOKIRANJA-1){
                    strcpy(blok.slogovi[i+1].evidBroj,OZNAKA_KRAJA_DATOTEKE);
                    fseek(fajl,-sizeof(BLOK),SEEK_CUR);
                    fwrite(&blok,sizeof(BLOK),1,fajl);
                    printf("Novi slog evidentiran u datoteci.\n");
					return;
                }else{
                    fseek(fajl,-sizeof(BLOK),SEEK_CUR);
                    fwrite(&blok,sizeof(BLOK),1,fajl);

                    BLOK noviBlok;
                    strcpy(noviBlok.slogovi[0].evidBroj,OZNAKA_KRAJA_DATOTEKE);
                    fwrite(&noviBlok,sizeof(BLOK),1,fajl);
                    printf("Novi slog evidentiran u datoteci.\n");
					printf("(dodat novi blok)\n");
					return;

                }
            }
            else if(strcmp(blok.slogovi[i].evidBroj,slogKojiUpisujemo.evidBroj) == 0){
                if(!blok.slogovi[i].deleted){
                    printf("Slog sa tom vrednoscu kljuca vec postoji!\n");
                    return;
                }else{
                    memcpy(&blok.slogovi[i],&slogKojiUpisujemo,sizeof(SLOG));

                    fseek(fajl,-sizeof(BLOK),SEEK_CUR);
                    fwrite(&blok,sizeof(BLOK),1,fajl);
                    printf("Novi slog evidentiran u datoteci.\n");
					printf("(prepisan preko logicki izbrisanog)\n");
					return;

                }
            }
            else if(atoi(blok.slogovi[i].evidBroj) > atoi(slogKojiUpisujemo.evidBroj)){
                SLOG tmp;
                memcpy(&tmp,&blok.slogovi[i],sizeof(SLOG));
                memcpy(&blok.slogovi[i],&slogKojiUpisujemo,sizeof(SLOG));
                memcpy(&slogKojiUpisujemo,&tmp,sizeof(SLOG));
                if (i == FBLOKIRANJA-1) {
					fseek(fajl, -sizeof(BLOK), SEEK_CUR);
					fwrite(&blok, sizeof(BLOK), 1, fajl);
					fseek(fajl, 0, SEEK_CUR);   //??????????????????????
				}
            }
        }
	}
}

void ispisiSveSlogove(FILE *fajl) {
	if (fajl == NULL) {
		printf("Datoteka nije otvorena!\n");
		return;
	}

	fseek(fajl, 0, SEEK_SET);
	BLOK blok;
	int rbBloka = 0;
	printf("BL SL Evid.Br   Sif.Zat      Dat.Vrem.Dol  Celija  Kazna\n");
	while (fread(&blok, sizeof(BLOK), 1, fajl)) {

		for (int i = 0; i < FBLOKIRANJA; i++) {
			if (strcmp(blok.slogovi[i].evidBroj, OZNAKA_KRAJA_DATOTEKE) == 0) {
				printf("B%d S%d *\n", rbBloka, i);
                return; //citaj sledeci blok
			} else if (!blok.slogovi[i].deleted) {
                printf("B%d S%d ", rbBloka, i);
                ispisiSlog(&blok.slogovi[i]);
                printf("\n");
            }
		}

		rbBloka++;
	}
}

void ispisiSlog(SLOG *slog) {
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


void azurirajSlog(FILE *fajl,char *evidBroj,char *oznakaCelije,int duzinaKazne){
 	if (fajl == NULL) {
		printf("Datoteka nije otvorena!\n");
		return;
	}

	fseek(fajl,0,SEEK_SET);
	BLOK blok;
	while(fread(&blok,sizeof(BLOK),1,fajl)){
        for(int i = 0;i<FBLOKIRANJA;i++){
            if(strcmp(blok.slogovi[i].evidBroj,OZNAKA_KRAJA_DATOTEKE) == 0
               || atoi(blok.slogovi[i].evidBroj) > atoi(evidBroj)){

                printf("Slog koji zelite modifikovati ne postoji!\n");
                return;
            }
            else if(strcmp(blok.slogovi[i].evidBroj,evidBroj) == 0){
                if(blok.slogovi[i].deleted){
                    printf("Slog koji zelite modifikovati ne postoji!\n");
                    return;
                }
                strcpy(blok.slogovi[i].oznakaCelije,oznakaCelije);
                blok.slogovi[i].duzinaKazne = duzinaKazne;

                fseek(fajl,-sizeof(BLOK),SEEK_CUR);
                fwrite(&blok,sizeof(BLOK),1,fajl);

                printf("Slog izmenjen.\n");
                return;
            }
        }
	}
}

void obrisiSlogLogicki(FILE *fajl, char *evidBroj) {
	if (fajl == NULL) {
		printf("Datoteka nije otvorena!\n");
		return;
	}

	fseek(fajl, 0, SEEK_SET);
	BLOK blok;
	while (fread(&blok, sizeof(BLOK), 1, fajl)) {

		for (int i = 0; i < FBLOKIRANJA; i++) {

            if (strcmp(blok.slogovi[i].evidBroj, OZNAKA_KRAJA_DATOTEKE) == 0 ||
                atoi(blok.slogovi[i].evidBroj) > atoi(evidBroj)) {

                printf("Slog koji zelite obrisati ne postoji!\n");
                return;

            } else if (strcmp(blok.slogovi[i].evidBroj, evidBroj) == 0) {

				if (blok.slogovi[i].deleted == 1) {
					printf("Slog koji zelite obrisati ne postoji!\n");
					return;
				}
				blok.slogovi[i].deleted = 1;
				fseek(fajl, -sizeof(BLOK), SEEK_CUR);
				fwrite(&blok, sizeof(BLOK), 1, fajl);
                printf("Brisanje sloga zavrseno.\n");
				return;

			}
		}
	}
}
























