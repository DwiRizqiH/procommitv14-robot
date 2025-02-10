int isWarna;
bool isFromRetry = false;

// this is based on Arena Kiri (Merah)
void fromReloadToA();
void fromReloadToB();
void fromReloadToZ();
void fromAToReload();
void fromBToReload();
void balikKanan();
void balikKiri();
void balikKananCenter();
void balikKiriCenter();
void changePosLcd();
void Program_Jalan();

int addKa = 100;
int addKi = 100;
void test_Program_Jalan() {
    lcd_clear();
    delay(500);

    
    while(1) {
        // scanMundur(2500);
        pwmki = addKi;
        PORTD.2 = 1;
        PORTD.3 = 0;

        pwmka = addKa;
        PORTD.7 = 1;
        PORTD.6 = 0;
        if(t1 == 0) {
            addKi += 10;
            delay(200);
        } else if(t2 == 0) {
            addKi -= 10;
            delay(200);
        }
        lcd_gotoxy(0, 0);
        sprintf(buff, "Ki: %d", addKi);
        lcd_puts(buff);
        lcd_gotoxy(0, 1);
        sprintf(buff, "Ka: %d", addKa);
        lcd_puts(buff);
    }
}

int isAftertoTambahan = false;
bool isAwalTambahan = false;
int jumlahLoop = 1;
void InsideWhile();
void Program_Awal_Tamabahan() {
    scanX(1, 190);
    scanX(2, 180);
    mundur(210, 210); delay(70); rem(600);
    taruh_bola();
    
    mundur(180, 180); delay(400);
    belokKiri(180, 0); mundur(180, 180); delay(50); rem(200);

    scanX(1, 180);
    belokKanan(180, 0); mundur(180, 180); delay(50); rem(200);

    scanX(1, 180);
    scanX(3, 200);
    scanX(1, 190);
    belokKiri(180, 0); mundur(180, 180); delay(50); rem(200);

    scanX(1, 180);
    scanX(2, 200);
    scanX(2, 180);
    mundur(190, 190); delay(80); rem(600);
    taruh_bola();

    mundur(180, 180); delay(400);
    belokKiri(180, 0); belokKiri(180, 0); mundur(180, 180); delay(50); rem(200);

    scanX(1, 180);
    scanX(3, 200);
    mundur(190, 190); delay(80); rem(200);

    belokKanan(180, 0); mundur(180, 180); delay(50); rem(200);
    scanX(1, 180);
    scanX(3, 200);
    scanX(1, 190);

    scanX(1, 180);
    InsideWhile();
}

void InsideWhile() {
    mundur(190, 190); delay(50); rem(200);
    taruh_bola();

    mundur(180, 180); delay(300);
    belokKanan(180, 0); mundur(180, 180); delay(50); rem(200);

    scanX(1, 180);
    belokKiri(180, 0); mundur(180, 180); delay(50); rem(200);

    scanX(1, 200);
    scanX(1, 190);
    belokKanan(180, 0); mundur(180, 180); delay(50); rem(200);

    startPos = 'R';
    ringPos = 1;
    isAwalTambahan = true;

    delay(5000);
    Program_Jalan();
}

void Program_Jalan() {
    lcd_gotoxy(0, 1);
    lcd_putsf("Position: ");
    changePosLcd();

    if(startPos == 'H') {
        scanX(2, 180);
    }

    if(!isAwalTambahan) {
        Program_Awal_Tamabahan();
    }

    // if(startPos == 'H') {
    //     scanX(2, 180);

    //     if(isFromRetry) delay(5000);
    //     if(pointPos != 'Z') {
    //         belokKiri(190, 0); rem(100);
    //     }
    // }

    if(pointPos == 'A') fromReloadToA();
    else if(pointPos == 'B') fromReloadToB();
    else if(pointPos == 'Z') fromReloadToZ();

    if((pointPos == 'A') || (pointPos == 'B')) {
        if(ringPos == 1) {
            scanX(4, 200);
            scanX(1, 190);
            mundur(180, 180); delay(50); rem(600);
        } else if(ringPos == 2) {
            scanX(2, 200);
            scanX(1, 190);
            mundur(180, 180); delay(50); rem(600);
        } else if(ringPos == 3) {
            scanX(1, 190);
            mundur(180, 180); delay(50); rem(600);
        }

        // check warna / 0 = putih / 1 = orange
        isWarna = checkWarna(true);

        // to ring
        if(isWarna == 0) {
            belokKiri(190, 0); rem(200);
            scanX(1, 180); mundur(180, 180); delay(50); rem(200);
        } else if(isWarna == 1) {
            belokKanan(190, 0); rem(200);
            scanX(1, 180); mundur(180, 180); delay(50); rem(200);
        }



        // servo stuff
        taruh_bola();
        delay(350);

        // back position
        mundur(180, 180); delay(400);
        if(isWarna == 0) { 
            belokKiri(180, 0); mundur(180, 180); delay(50); rem(200);
        } else if(isWarna == 1) {
            belokKanan(180, 0); mundur(180, 180); delay(50); rem(200);
        }

        while (ringPos < 3) {
            ringPos++;
            changePosLcd();

            scanX(2, 190);

            // Check warna / 0 = putih / 1 = orange
            mundur(180, 180); delay(50); rem(600);
            isWarna = checkWarna(true);

            // To Ring
            if (isWarna == 0) {
                belokKanan(190, 0); rem(200);
                scanX(1, 180); mundur(180, 180); delay(50); rem(200);
            } else if (isWarna == 1) {
                belokKiri(190, 0); rem(200);
                scanX(1, 180); mundur(180, 180); delay(50); rem(200);
            }

            // servo stuff
            taruh_bola();
            delay(200);

            // Back position
            mundur(180, 180); delay(400);
            if (isWarna == 0) {
                belokKiri(180, 0); mundur(180, 180); delay(50); rem(200);
            } else if (isWarna == 1) {
                belokKanan(180, 0); mundur(180, 180); delay(50); rem(200);
            }
        }

        if(ringPos == 1) scanX(5, 200);
        else if(ringPos == 2) scanX(3, 200);
        else if(ringPos == 3) scanX(1, 200);

        belokKiri(200, 0); mundur(200, 200); delay(50); rem(200);
        if((pointPos == 'A')) {
            fromAToReload();
            open_tabung;
            delay(5000);
            close_tabung;

            Program_Jalan();
        } else if((pointPos == 'B')) {
            fromBToReload();
            open_tabung;
            delay(5000);
            close_tabung;

            Program_Jalan();
        }
    }
    else if(pointPos == 'Z') {
        // servo stuff
        lepas_bola;
        delay(500);
        kunci_bola
        delay(350);

        mundur(190, 190); delay(200);
        belokKanan(180, 180);
        scanX(1, 190);
        belokKiri(190, 0); mundur(190, 190); delay(50); rem(200);

        scanX(2, 190); maju_delay(200, 150); mundur(200, 200); delay(50); rem(200);
    }
}

void fromReloadToA() {
    if(startPos == 'R' && isAftertoTambahan) {
        mundur(180, 180); delay(400);
        belokKiri(180, 200);
    }
    if(!isAftertoTambahan) isAftertoTambahan = true;
    scanX(1, 190);
    scanX(3, 200);
    scanX(1, 190);
    belokKanan(190, 0); mundur(190, 190); delay(50); rem(200);
}
void fromReloadToB() {
    if(startPos == 'R') {
        mundur(180, 180); delay(400);
        belokKiri(180, 200);
    }
    scanX(2, 190);
    belokKanan(190, 0); mundur(190, 190); delay(50); rem(200);
}
void fromReloadToZ() {
    if(startPos != 'H') {
        belokKiri(180, 0); mundur(180, 180); delay(50); rem(200);
    }

    scanX(1, 180); belokKanan(190, 0);
    scanX(1, 180); mundur(180, 180); delay(50); rem(200);
}

bool isAfterToA = false;
void fromAToReload() {
    scanX(5, 200);
    mundur(190, 190); delay(50); rem(200);

    if(isAfterToA) {
        pointPos = 'B';
    } else {
        pointPos = 'A';
        isAfterToA = true;
    }

    startPos = 'R';
    ringPos = 1;

    changePosLcd();
}

bool isAfterToB = false;
void fromBToReload() {
    scanX(2, 200);
    mundur(190, 190); delay(50); rem(200);

    if(isAfterToB) {
        pointPos = 'Z';
        ringPos = 4;
    } else {
        pointPos = 'B';
        ringPos = 1;
        isAfterToB = true;
    }

    startPos = 'R';

    changePosLcd();
}

void balikKanan() {
    belokKanan(180, 200); belokKanan(180, 200);
}
void balikKananCenter() {
    belokKananCenter(190, 0); belokKananCenter(190, 200);
}

void balikKiri() {
    belokKiri(180, 0); belokKiri(180, 200);
}
void balikKiriCenter() {
    belokKiriCenter(195, 0); belokKiriCenter(195, 195);
}

void changePosLcd() {
    lcd_gotoxy(10, 1);
    sprintf(buff, "%c %c%d", startPos, pointPos, ringPos);
    lcd_puts(buff);
}