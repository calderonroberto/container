/*
  Simple serial control for arduino with a default timeout integration.
  
  Protocol: type,pin1,pin2,pin3,pin4,pin5...pin13,duration
  All in HEX.  types: 1:digital, 2:analog, 9:case
  A duration of 0 means no timeout.
  
  So: 
  
  \x02\x01\x01\x01\x01\x01\x01\x01\x01\x00\x8C\x01\x01\x01\x0A
  
  Sets pin 9 to 0, and 10 to 140 in analog mode, with a 10 seconds duration.
  
*/

unsigned long time;
unsigned long previoustime;
unsigned long timer;
unsigned long beat = 2000; //interval in millis to send out sensor data 

boolean timerset = false;
int byteindex = 0;
byte incomingBytes[14];
int sensors[4];

void setup() {
  Serial.begin(9600);
  delay(1000);
  for (int i=1; i<=13; i++){
    pinMode(i, OUTPUT);
  }
  for (int i=0; i<4; i++){
    sensors[i] = analogRead(i);
  }
}
void loop() {

  byte b;
  time = millis();       

  if (timerset) {       
    if (time > timer){ //pinvalues[14] has timeout value
      for (int i=0; i<14; i++) {
        digitalWrite(i,LOW); //pull down all resistors
      }
      timerset = false;
    }
  }

  if (Serial.available()){ 
      b = Serial.read();             
      incomingBytes[byteindex] = b;
      byteindex++;        
  }

  //set states
  if (byteindex==15){          


    while( Serial.read() != -1 ); //flush incoming

    //debug
     //for (int i=0; i<15; i++) {
     //  Serial.println(incomingBytes[i]);
     //}


    //TYPE 1 (digital)
    if (incomingBytes[0] == 0x01) {
      //Serial.println("Case 1");
      for (int i=1; i<14; i++) {      
        if (incomingBytes[i] == 0x01){
          //Serial.println("setting " + String(i) + " on");
          digitalWrite(i,HIGH);
        } else if (incomingBytes[i] == 0x00){
          //Serial.println("setting " + String(i) + " off");
          digitalWrite(i,LOW);         
        }     
      }                          
    }
    
    //TYPE 2 (analog)
    else if (incomingBytes[0]==0x02) { 
      for (int i=1; i<14; i++) {
        analogWrite(i,(int)incomingBytes[i]);         
      }
    }
     
     //TYPE 9 (hidden, do something else
    else if (incomingBytes[0]==0x09) {       
       //Insert your own code
       digitalWrite(12,HIGH);
       for (int i=0; i<15; i++){
           digitalWrite(13,HIGH);         
           delay(15);
           digitalWrite(13,LOW);
           delay(1000);       
       }
       digitalWrite(12,LOW);
    }
    
    //TYPE 8, asking for a sensor value
    else if (incomingBytes[0]==0x08){      
      /*
      int sensor = (int)incomingBytes[1];        
      int sensorValue = analogRead(sensor);
      uint8_t my_serial_bytes[2]={0x00, 0x00};
      my_serial_bytes[0] = uint8_t(sensor);
      my_serial_bytes[1] = uint8_t(sensorValue/4);
      Serial.write(my_serial_bytes,sizeof(my_serial_bytes)); //uncomment                      
      */
      int s0 = analogRead(0);
      int s1 = analogRead(1);
      int s2 = analogRead(2);
      int s3 = analogRead(3);
      int s4 = analogRead(4);
      uint8_t my_serial_bytes[5]={0x00, 0x00, 0x00, 0x00, 0x00};
      my_serial_bytes[0] = uint8_t(s0/4);
      my_serial_bytes[1] = uint8_t(s1/4);
      my_serial_bytes[2] = uint8_t(s2/4);
      my_serial_bytes[3] = uint8_t(s3/4);
      my_serial_bytes[4] = uint8_t(s4/4);
      Serial.write(my_serial_bytes,sizeof(my_serial_bytes));
    }
        
    //Serial.println(incomingBytes[14]);
    
    //set timeout if available
    if (incomingBytes[14]>0x00) { // pinvalues[14] has the timeout value
      timerset = true;    
      unsigned long t = (unsigned long)incomingBytes[14] * (unsigned long)1000; //avoiding errors by casting longs
      timer = millis() + t;       
    } 
    
    byteindex=0;
 
  }

  
  
  
  
  /*
  * If sensors have changed send a tuple to the serial
  * 
  * This code runs everytime the python script sends a post event (seem slike it resets the serial
  * causing the sensors to vary. Thus. we are moving to a "case" 
  */
  /*
  //only if beat interval has happened 
  if (time - previoustime > beat) {
    previoustime = time;
    //for (int i=0; i<4; i++){
    for (int i=0; i<4; i++){
       int sensorValue = analogRead(i);
       //only if sensor value has changed 5% of more
       if (sensorValue < sensors[i]-50 || sensorValue > sensors[i]+50){
         uint8_t my_serial_bytes[2]={0x00, 0x00};
         my_serial_bytes[0] = uint8_t(i);
         my_serial_bytes[1] = uint8_t(sensorValue/4);
         Serial.write(my_serial_bytes,sizeof(my_serial_bytes)); //uncomment
         sensors[i] = sensorValue;
       }
    }

  }
  */
  
}
