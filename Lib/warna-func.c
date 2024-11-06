void bacawarna()
{
    nadc7 = read_adc(7);
    lcd_gotoxy(13, 1);
    sprintf(buff, "%d   ", nadc7);
    lcd_puts(buff);
}

int checkWarna(bool isDisplay) {
    int warna;
    nadc7 = read_adc(7);
    if(nadc7 > minPutih && nadc7 < maxPutih){
        warna = 0;
    } else if(nadc7 > minOrange && nadc7 < maxOrange){
        warna = 1;
    } else {
        warna = 0;
    }
    if(isDisplay) {
        lcd_gotoxy(13, 1);
        sprintf(buff, "%d   ", nadc7);
        lcd_puts(buff);

        lcd_gotoxy(13, 0);
        sprintf(buff, "%d   ", warna);
        lcd_puts(buff);
    }
    return warna;
}