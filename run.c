void Program_Jalan() {
    maju_delay(2000, 400);
    scanX(1, 2000); belokKiri(2000, 200);
    scanX(5, 2000);
}

void balikKanan() {
    mundur(1000, 1000); delay(380);
    belokKanan(1200, 0); belokKanan(1200, 100);
}

void balikKiri() {
    belki(1000, 50); belki(1000, 200);
}