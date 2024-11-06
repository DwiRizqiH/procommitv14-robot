// declare variable
void runBot(void);
void calibration(void);
void change_startPos(void);
void Program_Jalan(void);
void test_motor(void);
void test_tombol(void);
void map_select(int map_num);
void sens_warna(void);
void test_servo(void);
void changeMenu(int menuSelect, bool isSelect) {
    lampu = 0;
    count_btn = menuSelect;
    if(!isSelect && !isChildSelect) {
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Menu");
    }

    switch (menuSelect) {
        case 0: // Calibration
            if(isSelect) { calibration(); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Kalibrasi");
            break;
        case 1: // Run bot
            if(isSelect || isChildSelect) { runBot(); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Run Bot");
            break;
        case 2: //Change Home or Reload
            if(isSelect) { change_startPos(); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("StartPos");
            break;
        case 3: // Sensor Warna
            if(isSelect) { sens_warna(); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Warna");
            break;
        case 4: // Map Select
            if(isSelect || isChildSelect) { map_select(map_biru); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Map Blue");
            break;
        case 5: // Map Select
            if(isSelect || isChildSelect) { map_select(map_merah); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Map Red");
            break;
        case 6: // Test Motor
            if(isSelect) { test_motor(); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Motor");
            break;
        case 7: // Test tombol
            if(isSelect) { test_tombol(); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Button");
            break;
        case 8: // Test Servo
            if(isSelect) { test_servo(); break; }
            lcd_gotoxy(0, 1);
            lcd_putsf("Servo");
            break;
    
        default:
            break;
    }
}

void runBot() {
    if(!isChildSelect) {
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Run Bot");
        lcd_gotoxy(0, 1);
        lcd_putsf("Click 2 to start");
        close_tabung;
        isChildSelect = true;
    } else if(isChildSelect) {
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_putsf("Running...");

        Program_Jalan();
        isChildSelect = false;
        changeMenu(0, false);
    }
}

void calibration() {
    scan_garis(); 
    delay(1000);
    scan_back();
    delay(1000);
    hit_tengah();

    isChildSelect = false;
    changeMenu(0, false);
}

void change_startPos() {
    if(startPos == 'H') {
        startPos = 'R';
    } else {
        startPos = 'H';
    }
}

void map_select(int map_num) {
    // map_num = 1 - map/lintasan bagian biru, 0 - map/lintasan bagian merah
    if(map_num != 0 && map_num != 1) map_num = 0;
    mapMirror = map_num;

    isChildSelect = false;
    changeMenu(0, false);
}

void test_motor()
{
    lcd_clear();
    lcd_gotoxy(0, 0);
    lcd_putsf("Test Motor");

    lcd_gotoxy(0, 1);
    lcd_putsf("+1000 +1000");
    setMotor(1000, 1000);
    delay_ms(2000);

    lcd_gotoxy(0, 1);
    lcd_putsf("-1000 -1000");
    setMotor(-1000, -1000);
    delay_ms(2000);

    lcd_gotoxy(0, 1);
    lcd_putsf("+1000 -1000");
    setMotor(1000, -1000);
    delay_ms(2000);

    lcd_gotoxy(0, 1);
    lcd_putsf("-1000 +1000");
    setMotor(-1000, 1000);
    delay_ms(2000);

    rem(1000);

    lcd_clear();
    lcd_gotoxy(0, 0);
    
    isChildSelect = false;
    changeMenu(0, false);
}



// test stuff
void test_tombol()
{
    lcd_gotoxy(0, 1);
    lcd_putsf("Click 1 to exit");

    isTestTombol = true;
    while (1)
    {
        if (!isTestTombol) break;
        if ((t1 == 0))
        {
            lcd_gotoxy(0, 0);
            lcd_putsf("tombol = 1     ");

            isTestTombol = false;
            delay(500);
            changeMenu(0, false);
        }

        if (t2 == 0)
        {
            lcd_gotoxy(0, 0);
            lcd_putsf("tombol = 2     ");
        }

        if (t3 == 0)
        {
            lcd_gotoxy(0, 0);
            lcd_putsf("tombol = 3     ");
        }

        if (t4 == 0)
        {
            lcd_gotoxy(0, 0);
            lcd_putsf("tombol = 4     ");
        }
    }
    
}

void sens_warna()
{
    lcd_clear();
    lcd_gotoxy(0, 0);
    lcd_putsf("Warna");

    lcd_gotoxy(0, 1);
    lcd_putsf("Warna:");

    isTestTombol = true;
    delay(200);
    while (1)
    {
        bacawarna();
        if (!isTestTombol) { lcd_clear(); changeMenu(0, false); break; }
        if ((t1 == 0))
        {
            lcd_gotoxy(0, 0);
            lcd_putsf("Exiting...");

            isTestTombol = false;
            delay(500);
        }
    }
    
}

void test_servo() {
    lcd_clear();
    lcd_gotoxy(0, 1);
    lcd_putsf("Hold 1 to exit");

    while (1)
    {
        if(t1 == 0) {
            kunci_bola;
            break;
        }
        lcd_gotoxy(0, 0);
        lcd_putsf("Servo 1 Kunci");
        kunci_bola;
        close_tabung;
        delay(250);

        if(t1 == 0) {
            kunci_bola;
            break;
        }
        lcd_gotoxy(0, 0);
        lcd_putsf("Servo 1 Lepas");
        lepas_bola;
        open_tabung;
        delay(250);

        if(t1 == 0) {
            kunci_bola;
            break;
        }
    }
}

void display_map() {
    cek_sensor();
    lcd_gotoxy(7, 0);
    sprintf(buff, "%d", mapMirror);
    lcd_puts(buff);
}

void display_checkpoint() {
    if(pointPos != 'A' && pointPos != 'B' && pointPos != 'Z') pointPos = 'A';
    if(ringPos != 1 && ringPos != 2 && ringPos != 3 && ringPos != 4) ringPos = 1;
    if(startPos != 'H' && startPos != 'R') startPos = 'H';

    lcd_gotoxy(10, 1);
    sprintf(buff, "%c%d", pointPos, ringPos);
    lcd_puts(buff);

    lcd_gotoxy(5, 0);
    if(startPos == 'H') lcd_putsf("H");
    else lcd_putsf("R");
}

// void tes_sensor()
// {
//     for (i = 0; i < 7; i++)
//     {
//         lcd_gotoxy(0, 0);
//         sprintf(buff, "sensor:%d = %d  ", i, read_adc(i));
//         lcd_puts(buff);
//         delay_ms(100);
//     }
// }

// void tampil_count()
// {
//     lcd_gotoxy(0, 0);
//     sprintf(buff, " %d  ", second);
//     lcd_puts(buff);
// }