int isWarna;

// this is based on Arena Kiri (Merah)
void fromReloadToA();
void fromReloadToB();
void fromReloadToZ();
void fromAToReload();
void fromBToReload();
void Program_Jalan() {
    if(pointPos == 'O') {
        maju_delay(2000, 400);
        scanX(1, 2000); belokKiri(2000, 200);
        pointPos = 'A';
        ringPos = 1;
    }

    if(pointPos == 'A') fromReloadToA();
    else if(pointPos == 'B') fromReloadToB();
    else if(pointPos == 'Z') fromReloadToZ();

    if((pointPos == 'A') || (pointPos == 'B')) {
        if(ringPos == 1) scanX(5, 2000);
        else if(ringPos == 2) scanX(3, 2000);
        else if(ringPos == 3) scanX(1, 2000);

        // check warna / 0 = putih / 1 = orange
        // simulate 1
        // isWarna = checkWarna();
        isWarna = 1;

        // to ring
        if(isWarna == 0) {
            belokKiri(2000, 200);
            scanX(1, 2000); mundur(2000, 2000); delay(50); rem(200);
        } else if(isWarna == 1) {
            belokKanan(2000, 200);
            scanX(1, 2000); mundur(2000, 2000); delay(50); rem(200);
        }



        // servo stuff



        // back position
        mundur(2000, 2000); delay(350);
        if(isWarna == 0) belokKiri(3500, 200);
        else if(isWarna == 1) belokKanan(3500, 200);

        while (ringPos < 3) {
            ringPos++;
            scanX(2, 2000);

            // Check warna / 0 = putih / 1 = orange
            // Simulate 0 for testing
            // isWarna = checkWarna();
            isWarna = 0;

            // To Reload
            if (isWarna == 0) {
                belokKanan(2000, 200);
                scanX(1, 2000); mundur(2000, 2000); delay(50); rem(200);
            } else if (isWarna == 1) {
                belokKiri(2000, 200);
                scanX(1, 2000); mundur(2000, 2000); delay(50); rem(200);
            }

            // Back position
            mundur(2000, 2000); delay(350);
            if (isWarna == 0) {
                belokKiri(3500, 200);
            } else if (isWarna == 1) {
                belokKanan(3500, 200);
            }
        }

        if(ringPos == 1) scanX(5, 2000);
        else if(ringPos == 2) scanX(3, 2000);
        else if(ringPos == 3) scanX(1, 2000);

        belokKiri(2000, 200);
        if((pointPos == 'A')) fromAToReload();
        else if((pointPos == 'B')) fromBToReload();
    }
    else if(pointPos == 'Z') {
        // servo stuff


        mundur(2000, 2000); delay(350);
        belokKanan(2500, 200);
        scanX(2, 2000); rem(500);
    }

}

void fromReloadToA() {
    scanX(5, 2000); belokKanan(2000, 200);
}
void fromReloadToB() {
    scanX(2, 2000); belokKanan(2000, 200);
}
void fromReloadToZ() {
    scanX(2, 2000); belokKanan(2000, 200);
    scanKotak(1, 2000, 200);
}

void fromAToReload() {
    scanX(5, 2000);
    mundur(2000, 2000); delay(50); rem(200);
}
void fromBToReload() {
    scanX(2, 2000);
    mundur(2000, 2000); delay(50); rem(200);
}

void balikKanan() {
    mundur(1000, 1000); delay(380);
    belokKanan(1200, 0); belokKanan(1200, 100);
}

void balikKiri() {
    belki(1000, 50); belki(1000, 200);
}