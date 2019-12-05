#include <LiquidCrystal.h>



const int rs=A4, en=8, d4=A0, d5=A1, d6=A2, d7=A3;
LiquidCrystal lcd(rs,en, d4, d5, d6, d7);

const int trig=12;
const int echo=11;

const int IN1=4; //left motor
const int IN2=5;
const int IN3=6; //right motor
const int IN4=7;
const int enA=10;
const int enB=9;

int interrupt1=2;
int interrupt2=3;
int rev1=0,rev2=0, rpm1=0,rpm2=0;
int oldtime1=0;
int oldtime2=0;
int time1;
int time2;

int c=0;
double l,r;

void isr()
{
  rev1++;
  rev2++;
}
long microsecondsToCentimeters(long microseconds)
{
  return microseconds/29/2;
}

  
void predictrpm(double X, double *l, double *r)
{
  double b_X[2];
  int k;
  int i0;
  double d0;
  double Y[2];
  double dv0[3];
  static const double b[6] = { -3.1679, -0.7729, -0.0962, -3.134, 20.1933,
    -9.6463 };

  static const double b_b[6] = { 0.1479, 0.8206, 0.8565, 0.4123, -0.9261, 1.1253
  };

  b_X[0] = X;
  b_X[1] = 1.0;
  for (k = 0; k < 3; k++) {
    d0 = 0.0;
    for (i0 = 0; i0 < 2; i0++) {
      d0 += b_X[i0] * b[i0 + (k << 1)];
    }

    dv0[k] = 1.0 / (1.0 + exp(-d0));
  }

  for (i0 = 0; i0 < 2; i0++) {
    Y[i0] = 0.0;
    for (k = 0; k < 3; k++) {
      Y[i0] += dv0[k] * b_b[k + 3 * i0];
    }
  }

  *l = Y[0];
  *r = Y[1];
}  

void setup()
{
  lcd.begin(16,2);
  pinMode(IN1,OUTPUT);
  pinMode(IN2,OUTPUT);
  pinMode(IN3,OUTPUT);
  pinMode(IN4,OUTPUT);
  pinMode(trig,OUTPUT);
  pinMode(echo,INPUT);
  pinMode(enA,OUTPUT);
  pinMode(enB,OUTPUT);

  pinMode(interrupt1,INPUT_PULLUP);
  pinMode(interrupt2,INPUT_PULLUP);
  
  Serial.begin(9600);
}
void loop()
{ 
  lcd.clear(); 
  long duration, dist_inches,dist_cm;
  digitalWrite(trig,LOW);
  delayMicroseconds(2);
  digitalWrite(trig,HIGH);
  delayMicroseconds(5);
  digitalWrite(trig,LOW);

  duration=pulseIn(echo,HIGH);
  dist_cm=microsecondsToCentimeters(duration);

  Serial.print(dist_cm);
  Serial.print("cm");
  Serial.print(" ");
  Serial.println(rpm1);
  lcd.print(dist_cm);
  delay(100);
  

  
  
    predictrpm(dist_cm/20,&l,&r);
    digitalWrite(5,HIGH);
    digitalWrite(4,LOW);
    digitalWrite(6,HIGH);
    digitalWrite(7,LOW);
    l=l*256;r=r*256;
    if(l>255){l=255;}
    if(r>255){r=255;}
    if(l<0){l=0;}
    if(r<0){r=0;}
    
    analogWrite(enA,l);
    analogWrite(enB,r);
    
  
    lcd.setCursor(0,1);
    lcd.print("rpm1 ");
    lcd.print(rpm1);
    
    lcd.setCursor(9,1);
    lcd.print(" rpm2 ");
    lcd.print(rpm2);
    
    delay(100);
}
void call1()
{
  time1=millis();
  rpm1=(rev1/time1)*60000;
  oldtime1=millis();
  rev1=0;
}

void call2()
{
  time2=millis();
  rpm2=(rev2/time1)*60000;
  oldtime2=millis();
  rev2=0;
}  
