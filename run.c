int isWarna;

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
void Program_Jalan() {
    lcd_gotoxy(0, 1);
    lcd_putsf("Position: ");
    changePosLcd();

    if(startPos == 'H') {
        maju_delay(2000, 300);
        scanX(1, 3000); belokKiri(2500, 0); mundur(2500, 2500); delay(50); rem(100);
    }

    if(pointPos == 'A') fromReloadToA();
    else if(pointPos == 'B') fromReloadToB();
    else if(pointPos == 'Z') fromReloadToZ();

    if((pointPos == 'A') || (pointPos == 'B')) {
        if(ringPos == 1) {
            scanX(4, 2000);
            scanX(1, 2500);
            rem(750);
        } else if(ringPos == 2) {
            scanX(2, 2000);
            scanX(1, 2500);
            rem(750);
        } else if(ringPos == 3) {
            scanX(1, 2500);
            rem(750);
        }

        // check warna / 0 = putih / 1 = orange
        isWarna = checkWarna();

        // to ring
        if(isWarna == 0) {
            belokKiri(2000, 0); mundur(2000, 2000); delay(50); rem(200);
            scanX(1, 2500); mundur(2500, 2500); delay(50); rem(200);
        } else if(isWarna == 1) {
            belokKanan(2000, 0); mundur(2000, 2000); delay(50); rem(200);
            scanX(1, 2500); mundur(2500, 2500); delay(50); rem(200);
        }



        // servo stuff
        taruh_bola();
        delay(200);

        // back position
        mundur(3000, 3000); delay(400);
        if(isWarna == 0) { 
            belokKiriCenter(2500, 0); mundur(2500, 2500); delay(50); rem(200);
        } else if(isWarna == 1) {
            belokKananCenter(2500, 0); mundur(2500, 2500); delay(50); rem(200);
        }

        while (ringPos < 3) {
            ringPos++;
            changePosLcd();

            scanX(2, 2500);

            // Check warna / 0 = putih / 1 = orange
            // mundur(2300, 2300); delay(50); rem(300);
            rem(750);
            isWarna = checkWarna();

            // To Ring
            if (isWarna == 0) {
                belokKanan(2000, 0); mundur(2000, 2000); delay(50); rem(200);
                scanX(1, 2500); mundur(2500, 2500); delay(50); rem(200);
            } else if (isWarna == 1) {
                belokKiri(2000, 0); mundur(2000, 2000); delay(50); rem(200);
                scanX(1, 2500); mundur(2500, 2500); delay(50); rem(200);
            }

            // servo stuff
            taruh_bola();
            delay(200);

            // Back position
            mundur(3000, 3000); delay(400);
            if (isWarna == 0) {
                belokKiriCenter(2500, 0); mundur(2500, 2500); delay(50); rem(200);
            } else if (isWarna == 1) {
                belokKananCenter(2500, 0); mundur(2500, 2500); delay(50); rem(200);
            }
        }

        if(ringPos == 1) scanX(5, 2000);
        else if(ringPos == 2) scanX(3, 2000);
        else if(ringPos == 3) scanX(1, 2000);

        belokKiri(2000, 0); mundur(2000, 2000); delay(50); rem(200);
        if((pointPos == 'A')) {
            fromAToReload();
            open_tabung;
            delay(10000);
            close_tabung;

            Program_Jalan();
        } else if((pointPos == 'B')) {
            fromBToReload();
            open_tabung;
            delay(10000);
            close_tabung;

            Program_Jalan();
        }
    }
    else if(pointPos == 'Z') {
        // servo stuff
        taruh_bola();
        delay(200);


        mundur(3000, 3000); delay(200);
        belokKananCenter(3500, 200);
        scanX(1, 2500);
        
        belokKiri(2500, 0); mundur(2500, 2500); delay(50); rem(200);
        scanX(2, 2000); maju_delay(2000, 100); mundur(2000, 2000); delay(50); rem(200);
    }
}

void fromReloadToA() {
    scanX(4, 2000); scanX(1, 2500);
    belokKanan(2500, 0); mundur(2500, 2500); delay(50); rem(200);
}
void fromReloadToB() {
    if(startPos == 'R') {
        balikKiriCenter();
    }
    scanX(2, 2500);
    belokKanan(2500, 0); mundur(2500, 2500); delay(50); rem(200);
}
void fromReloadToZ() {
    belokKiri(3500, 0); mundur(3500, 3500); delay(50); rem(200);

    scanX(1, 3000); belokKanan(2500, 0);
    scanX(1, 3500); mundur(3500, 3500); delay(50); rem(200);
}

void fromAToReload() {
    scanX(5, 2000);
    mundur(1500, 1500); delay(50); rem(200);

    startPos = 'R';

    pointPos = 'B';
    ringPos = 1;

    changePosLcd();
}
void fromBToReload() {
    scanX(2, 2000);
    mundur(1500, 1500); delay(50); rem(200);

    startPos = 'R';

    pointPos = 'Z';
    ringPos = 4;

    changePosLcd();
}

void balikKanan() {
    belokKanan(3500, 200); belokKanan(3500, 200);
}
void balikKananCenter() {
    belokKananCenter(3500, 0); belokKananCenter(3500, 200);
}

void balikKiri() {
    belokKiri(3500, 0); belokKiri(3500, 200);
}
void balikKiriCenter() {
    belokKiriCenter(3500, 0); belokKiriCenter(3500, 200);
}

void changePosLcd() {
    lcd_gotoxy(10, 1);
    sprintf(buff, "%c %c%d", startPos, pointPos, ringPos);
    lcd_puts(buff);
}