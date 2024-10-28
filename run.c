void Program_Jalan() {
    scanX(1, 2000); belokKiri(2000, 200);
    scanX(5, 2000); belokKanan(2000, 200);
    scanX(5, 2000); rem(200);
}

void balikKanan() {
    mundur(1000, 1000); delay(380);
    belokKanan(1200, 0); belokKanan(1200, 100);
}

void balikKiri() {
    belki(1000, 50); belki(1000, 200);
}