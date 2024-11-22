int unusedPwm[99] = {0};

// motor
void maju(int ki, int ka)
{
    pwmka = ka;
    pwmki = ki;

    // dir kiri
    PORTD.2 = 1;
    PORTD.3 = 0;

    // dir kanan
    PORTD.6 = 0;
    PORTD.7 = 1;
}

void mundur(int ki, int ka)
{
    pwmka = ka;
    pwmki = ki;

    // dir kiri
    PORTD.2 = 0;
    PORTD.3 = 1;

    // dir kanan
    PORTD.6 = 1;
    PORTD.7 = 0;
}

void kanan(int ki, int ka)
{
    pwmka = ka;
    pwmki = ki;

    // dir kiri
    PORTD.2 = 0;
    PORTD.3 = 1;

    // dir kanan
    PORTD.6 = 0;
    PORTD.7 = 1;
}

void kiri(int ki, int ka)
{
    pwmka = ka;
    pwmki = ki;

    // dir kiri
    PORTD.2 = 1;
    PORTD.3 = 0;

    // dir kanan
    PORTD.6 = 1;
    PORTD.7 = 0;
}

void setMotor(int ki, int ka)
{
    pwmki = abs(ki);
    if (ki > 0)
    {
        PORTD.2 = 1;
        PORTD.3 = 0;
    }
    else
    {
        PORTD.2 = 0;
        PORTD.3 = 1;
    }

    pwmka = abs(ka);
    if (ka > 0)
    {
        PORTD.7 = 1;
        PORTD.6 = 0;
    }
    else
    {
        PORTD.7 = 0;
        PORTD.6 = 1;
    }
}

void rem(int nilai_rem)
{
    PORTD .4 = 1;
    PORTD .5 = 1;
    PORTD .2 = 0;
    PORTD .3 = 0;
    PORTD .6 = 0;
    PORTD .7 = 0;
    delay_ms(nilai_rem);
}

void maju_delay(int kec, int lama)
{
    maju(kec, kec);
    delay(lama);
}

void pilihSpeed(int kec)
{
    kp = kec * 0.15;
    kd = kec * 0.6;
    SPEED = kec;
    MIN_SPEED = -(kec * 0.75);
    MAX_SPEED = kec;
}

void pilihSpeedReverse(int kec)
{
    // May need to adjust these multipliers for reverse movement
    kp = kec * 0.15;     // Could keep same as forward
    kd = kec * 0.6;      // Could keep same as forward
    SPEED = -kec;        // Negative since moving backwards
    MIN_SPEED = -(kec);  // Full negative speed as max reverse
    MAX_SPEED = kec * 0.75;  // Limit forward correction when reversing

    // go to left side lcd
    lcd_gotoxy(0, 0);
    sprintf(buff, "%d", MIN_SPEED);
    lcd_puts(buff);
    lcd_gotoxy(0, 1);
    sprintf(buff, "%d", MAX_SPEED);
    lcd_puts(buff);

    //  go to center lcd
    lcd_gotoxy(6, 0);
    sprintf(buff, "%d", SPEED);
    lcd_puts(buff);
}

void maju_cari_garis()
{

    maju(180, 182);
    cek_sensor(); // 0b01000000)!=0b00000000)
    while ((sensor & 0b00000001) != 0b00000000)
    {
        cek_sensor();
    }
    rem(100);
}

void parkir()
{
    lampu = 0;
    while (1)
    {
        rem(100);
    }
}


#include "scan-func.c"
    // Belok garis 
void belki(int kec, int lama)
{
    cek_sensor();
    while (sen[0] || sen[1])
    {
        kiri(kec, kec);
        cek_sensor();
    }
    cek_sensor();
    while (!sen[0] && !sen[1])
    {
        kiri(kec, kec);
        cek_sensor();
    }

    if (lama > 0)
    {
        rem(lama);
    }
}
void belkicenter(int kec, int lama)
{
    cek_sensor();
    while (sen[1] || sen[2])
    {
        kiri(kec, kec);
        cek_sensor();
    }
    cek_sensor();
    while (!sen[1] && !sen[2])
    {
        kiri(kec, kec);
        cek_sensor();
    }

    if (lama > 0)
    {
        rem(lama);
    }
}
void belki2()
{
    cek_sensor();
    while ((sensor & 0b00000001) != 0b00000000)
    {
        cek_sensor();
        kiri(150, 150);
        // if ((sensor & 0b00000001)==0b00000001)
        // lcd_kedip(1);
    }
}

void belka(int kec, int lama)
{
    cek_sensor();
    while (sen[5] || sen[6])
    {
        kanan(kec, kec);
        cek_sensor();
    }
    cek_sensor();
    while (!sen[5] && !sen[6])
    {
        kanan(kec, kec);
        cek_sensor();
    }
    if (lama > 0)
    {
        rem(lama);
    }
}
void belkacenter(int kec, int lama)
{
    cek_sensor();
    while (sen[4] || sen[5])
    {
        kanan(kec, kec);
        cek_sensor();
    }
    cek_sensor();
    while (!sen[4] && !sen[5])
    {
        kanan(kec, kec);
        cek_sensor();
    }
    if (lama > 0)
    {
        rem(lama);
    }
}

void scan_delay(int ms)
{
    k = 0;
    maju(172, 170);
    while (k < ms / 10)
    {
        delay_ms(10);
        k++;
        cek_sensor();
        scan(180);
    }
}
// belok garis mirror or no
void belokKanan(int kec, int lama_rem) {
    if(mapMirror == map_merah) {
        belka(kec, lama_rem);
    } else {
        belki(kec, lama_rem);
    }
}
void belokKananCenter(int kec, int lama_rem) {
    if(mapMirror == map_merah) {
        belkacenter(kec, lama_rem);
    } else {
        belkicenter(kec, lama_rem);
    }
}
void belokKiri(int kec, int lama_rem) {
    if(mapMirror == map_merah) {
        belki(kec, lama_rem);
    } else {
        belka(kec, lama_rem);
    }
}
void belokKiriCenter(int kec, int lama_rem) {
    if(mapMirror == map_merah) {
        belkicenter(kec, lama_rem);
    } else {
        belkacenter(kec, lama_rem);
    }
}