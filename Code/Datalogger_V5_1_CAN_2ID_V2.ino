#include <NMEAGPS.h>
#include <NeoTeeStream.h>
#include <NeoGPS_cfg.h>
#include <GPSport.h>
#include <Streamers.h>
static NMEAGPS  gps;
static gps_fix  fix;
#include <SPI.h>
#include <SD.h>//Lily:SD.h only supports DOS style 8.3 names.
#include "SparkFunLSM6DS3.h"
#include "Wire.h"

//Create a instance of class LSM6DS3
LSM6DS3 myIMU( I2C_MODE, 0x6B );  //I2C device address 0x6A/6B

#include "mcp_can.h"
const int SPI_CS_PIN = 9;//Lily: D9(PB5_ATMEGA32U4_pin29)
MCP_CAN CAN(SPI_CS_PIN);   // Set CS pin

#define PID_ENGIN_PRM       0x0C
#define PID_VEHICLE_SPEED   0x0D
#define PID_COOLANT_TEMP    0x05
#define PID_ENGINE_LOAD     0x04
#define CAN_ID_PID_std          0x7DF
#define CAN_ID_PID_ext          0x18DB33F1

// SET TIME ZONE HERE
const int timeZone  = 1;             // EAST 8, Beijing Time


int obdVehicleSpeed = 0;
int obdEngineRPM    = 0;
int obdCoolantTemp  = 0;
int obdEngineLoad   = 0;
bool standard_CAN = true; // true = 11 bits (standard), false = 29 bits (extended)

File dataFile;

char fileNameTxt[20];
bool gpsGetOnce = 0;
bool gpsGet = 0;
unsigned long deltaOBD = 0;
unsigned long deltaSAVE = 0;
unsigned long deltaMAIN = 0;
unsigned long deltaGPS = 0;
unsigned long deltaDoSomeWork = 0;

void set_mask_filt_std()
{
    // set mask, set both the mask to 0x3ff
    CAN.init_Mask(0, 0, 0x7FF);//0x7FC
    CAN.init_Mask(1, 0, 0x7FF);//0x7FC

    // set filter, we can receive id from 0x04 ~ 0x09

    CAN.init_Filt(0, 0, 0x7E8);                 
    CAN.init_Filt(1, 0, 0x7E8);
    CAN.init_Filt(2, 0, 0x7E8);
    CAN.init_Filt(3, 0, 0x7E8);
    CAN.init_Filt(4, 0, 0x7E8); 
    CAN.init_Filt(5, 0, 0x7E8);
    //Serial.println("set mask filter standard");
}

void set_mask_filt_ext()
{
    // set mask, set both the mask to 0x3ff
    CAN.init_Mask(0, 1, 0x1fffffff);//0x7FC
    CAN.init_Mask(1, 1, 0x1fffffff);//0x7FC

    // set filter, we can receive id from 0x04 ~ 0x09

    CAN.init_Filt(0, 1, 0x18DAF110);                 
    CAN.init_Filt(1, 1, 0x18DAF110);
    CAN.init_Filt(2, 1, 0x18DAF110);
    CAN.init_Filt(3, 1, 0x18DAF110);
    CAN.init_Filt(4, 1, 0x18DAF110); 
    CAN.init_Filt(5, 1, 0x18DAF110);
    //Serial.println("set mask filter extended");
}

void makeFileName(char *nameTxt)//Lily:https://www.arduino.cc/en/Reference/SDCardNotes 8.3 format
{
    int _month  = fix.dateTime.month;
    int _day    = fix.dateTime.date;
    int _hour   = fix.dateTime.hours + timeZone;
    int _minute = fix.dateTime.minutes;
    
    nameTxt[0] = '0' + (int)(_month/10);
    nameTxt[1] = '0' + (int)(_month%10);
    
    nameTxt[2] = '0' + (int)(_day/10);
    nameTxt[3] = '0' + (int)(_day%10);
     
    nameTxt[4] = '0' + (int)(_hour/10);
    nameTxt[5] = '0' + (int)(_hour%10);
    
    nameTxt[6] = '0' + (int)(_minute/10);
    nameTxt[7] = '0' + (int)(_minute%10);
    
    nameTxt[8] = '.';

    nameTxt[9] = 'c';
    nameTxt[10] = 's';
    nameTxt[11] = 'v';
    nameTxt[12] = '\0';

}



// 0 : no
// 1 : yes
unsigned char flgDriving = 0;
unsigned long timerStop;

void checkStart()
{
    if(flgDriving)return;//flgDriving=1, file already create
    if(!gpsGet)return;//gps not ready, return
    //Serial.println("check start");
    //if((fix.valid.speed && fix.speed_mkn() >= 0)||(obdCoolantTemp > 0))       // when speed > 10 km/h 
    if(obdCoolantTemp > 0)//Lily:à remettre
    
    //if(1)
    {
        //Serial.println("START TO TRACK");
        flgDriving = 1;
        makeFileName(fileNameTxt);
        
        dataFile = SD.open(fileNameTxt, FILE_WRITE);
        
        if(dataFile)
        {
            //Serial.print("Open ");
            //Serial.print(fileNameTxt);
            //Serial.println(" OK!");
            makeHeaderTxt(fileNameTxt);
            dataFile.close();
        }
        else
        {
            //Serial.println("file open fail");
            dataFile.close();
        }

        timerStop = millis();
    }
}

void checkStop()
{
    if(!flgDriving)return;
    
    if(obdVehicleSpeed > 0)
    {
        timerStop = millis();
    }
    
    if(millis()-timerStop > 1000 && obdVehicleSpeed == -1)//Lily:300000=5min,1000= 1s
    {
        //Serial.println("STOP TRACK");
        flgDriving = 0;
    }
}

void setup(void) 
{
  pinMode(A3, OUTPUT);
  digitalWrite(A3, HIGH);
  delay(5000);
  
  Serial.begin(115200);
 
  gpsPort.begin(9600);
  //Serial.println("start setup1");
  Serial1.println("$CCMSG,GSA,1,0,*0D"); //close GSA
  //Serial.println("start setup2");
  Serial1.println("$CCMSG,GSV,1,0,*1A"); //close GSV
  Serial1.println("$CCMSG,TXT,1,0,*00"); //close TXT
  Serial1.println("$CCINV,100,*60");     //set interval à 100ms
  Serial1.println("$CCCAS,1,5*55");      // UART_115200bps
  delay(500);
  gpsPort.begin(115200);
  //Serial.println("start setup");
  pinMode(13, OUTPUT);
    
    if (!SD.begin(4)) 
    {
        //Serial.println("Card failed, or not present");
        return;
    }
    
    //Serial.println("card initialized.");
    
    while (CAN_OK != CAN.begin(CAN_500KBPS))    // init can bus : baudrate = 500k
    {
        //Serial.println("CAN BUS Shield init fail");
        //Serial.println(" Init CAN BUS Shield again");
        delay(100);
    }
    //Serial.println("CAN BUS Shield init ok!");
    
    set_mask_filt();
    
    //Call .begin() to configure the IMUs
    if( myIMU.begin() != 0 )
    {//Serial.println("Device error");
    }  
    else  
    {//Serial.println("Device OK!");
    }
    //Serial.println("setup fini");
}

void set_mask_filt()
{    
    if (standard_CAN==true)
    {
        set_mask_filt_std();
    }
    else
    {
       set_mask_filt_ext(); 
       //set_mask_filt_std();
    }
}

static void doSomeWork() 
{
    unsigned long timer_s = millis();
    gpsProcess(); 
    obdProcess();
    saveTxt();  
    checkStart();
    checkStop();  
    blink();
    deltaMAIN = millis() - timer_s;
}

void loop() 
{
  while (gps.available( gpsPort )) 
  { 
    fix = gps.read();
    doSomeWork();
  }

}

bool gpsProcess() 
{
    gpsGet = 1;
    gpsGetOnce = (!gpsGetOnce && gpsGet) ? 1 : gpsGetOnce;                               
    return gpsGet;    
}


void saveTxt()
{
    if(!flgDriving)return;//stop track, no save  
    unsigned long timer_s = millis();
    dataFile = SD.open(fileNameTxt, FILE_WRITE);
 
    if(dataFile)
    {
        dataFile.print(fix.dateTime.date);
        dataFile.print("/");
        dataFile.print(fix.dateTime.month);
        dataFile.print("/20");
        dataFile.print(fix.dateTime.year);
        dataFile.print("-");
        dataFile.print(fix.dateTime.hours + timeZone);
        dataFile.print(":");
        dataFile.print(fix.dateTime.minutes);
        dataFile.print(":");
        dataFile.print(fix.dateTime.seconds);
        dataFile.print(".");
        dataFile.print(fix.dateTime_ms());   
        dataFile.print(",");
        dataFile.print(fix.latitudeL());
        dataFile.print(",");
        dataFile.print(fix.longitudeL());
        dataFile.print(",");
        dataFile.print(fix.altitude_cm());
        dataFile.print(",");
        dataFile.print(fix.speed_mkn());
        dataFile.print(",");
        dataFile.print(obdVehicleSpeed);
        dataFile.print(",");
        dataFile.print(obdEngineRPM);
        dataFile.print(",");
        dataFile.print(obdEngineLoad);
        dataFile.print(",");
        dataFile.print(obdCoolantTemp);
        dataFile.print(",");
        dataFile.print(myIMU.readFloatAccelX(),4);
        dataFile.print(",");
        dataFile.print(myIMU.readFloatAccelY(),4);
        dataFile.print(",");
        dataFile.print(myIMU.readFloatAccelZ(),4);
        dataFile.print(",");
        dataFile.print(myIMU.readFloatGyroX(),2);
        dataFile.print(",");
        dataFile.print(myIMU.readFloatGyroY(),2);
        dataFile.print(",");
        dataFile.print(myIMU.readFloatGyroZ(),2);
        dataFile.print(",");
        dataFile.print(deltaOBD);
        dataFile.print(",");
        dataFile.print(deltaSAVE);  
        dataFile.print(",");
        dataFile.println(deltaMAIN); 
        dataFile.close(); 
        deltaSAVE = millis()-timer_s; 
    } 
}

void blink()
{
    static int ledstatus = 0;
    
    if(gpsGetOnce == 0)
    {
        
        static unsigned long timer_s = millis();//static constante, la première fois
        if(millis()-timer_s < 50)return;//50  
        timer_s = millis();//prend le temps actuel et donner au variable timer_s
        
        ledstatus = 1-ledstatus;
        digitalWrite(13, ledstatus);
    }
    else if(flgDriving == 0)
    {
        static unsigned long timer_s = millis();
        if(millis()-timer_s < 100)return;
        timer_s = millis();
        
        ledstatus = 1-ledstatus;
        digitalWrite(13, ledstatus);
    }
    else
    {
        static unsigned long timer_s = millis();
        if(millis()-timer_s < 1000)return;
        timer_s = millis();
        
        ledstatus = 1-ledstatus;
        digitalWrite(13, ledstatus);
    }
}


void makeHeaderTxt(char *name)
{
    dataFile.println("Date-Time,Latitude,Longitude,Altitude(cm),GPSSpeed(mknots),CarSpeed(Km/h),Engine(RPM),CarLoad(%),CoolantTemp(°C),AccelX(g),AccelY(g),AccelZ(g),GyroX(dps),GyroY(dps),GyroZ(dps),T_OBD(ms),T_SAVE(ms),T_MAIN(ms)");
}


// OBD
// return:
// 0 - timeout
// 1 - ok

unsigned char getPidFromCar(unsigned char __pid, unsigned char *dta)
{
    unsigned char tmp[8] = {0x02, 0x01, __pid, 0, 0, 0, 0, 0};
    if (standard_CAN==true)
    {CAN.sendMsgBuf(CAN_ID_PID_std, 0, 8, tmp);
     //Serial.println("standard");
    }
    else
    {CAN.sendMsgBuf(CAN_ID_PID_ext, 1, 8, tmp);
     //Serial.println("extended");
    }  
     
    unsigned long timer_s = millis();
    while(1)
    {
        if(millis()-timer_s > 100)//8ms en simulation, sans OBD connecté; OBDprocess +-40ms dépend de la voiture;OPEL:22ms, Frank:50ms; 100ms FIAT500_Ludovic, on mesure la température
        {
            obdVehicleSpeed = -1;//Lily:timeout
            obdEngineRPM    = -1;
            obdEngineLoad   = -1;
            obdCoolantTemp  = -1;
            standard_CAN = !standard_CAN;
            //Serial.println(standard_CAN);
            CAN.begin(CAN_500KBPS);
            set_mask_filt();
            
            return 0;
        }
        unsigned char len = 0;
        if(CAN_MSGAVAIL == CAN.checkReceive())                   // check if get data
        {   
            //Serial.println("cancheckreceive");
            CAN.readMsgBuf(&len, dta);    // read data,  len: data length, buf: data buf
            if(dta[1] == 0x41 && dta[2] == __pid)
            {return 1;}
        }
    }
    return 0;
}

void obdProcess()
{
    //if(!flgDriving)return; 
    unsigned long timer_s = millis();
    unsigned char dta[8];
    // speed
    if(getPidFromCar(PID_VEHICLE_SPEED, dta))
    { obdVehicleSpeed = dta[3]; }
    // rpm
    if(getPidFromCar(PID_ENGIN_PRM, dta))
    {obdEngineRPM = (256.0*(float)dta[3]+(float)dta[4])/4.0;  }
    //charge
    if(getPidFromCar(PID_ENGINE_LOAD, dta))
    {  obdEngineLoad = dta[3]/2.55; }
    
    //Coolant temp
    if(getPidFromCar(PID_COOLANT_TEMP, dta))
    { obdCoolantTemp = dta[3]-40;}
    //Serial.println("OBDprocess");
    deltaOBD = millis()-timer_s;
}
