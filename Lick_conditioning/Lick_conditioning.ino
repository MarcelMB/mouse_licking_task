
#include <Arduino.h>

#include "global_variables.h"
#include "prototypes.h"

#include "timing.h"
#include "sensors.h"
#include "states.h"
#include "SerialComms.h"
#include "single_port_setup.h"


String version = "#BB_V3.0.20170201.8";

void setup() {
  // Open serial communications and wait for port to open:
  // This requires RX and TX channels (pins 0 and 1)
  // wait for serial port to connect. Needed for native USB port only
  Serial.begin(115200);
  while (!Serial) {
    ;
  }
  //Confirm connection and telegraph the code version

  Serial.println("#Arduino online,");
  Serial.println  (version);


  randomSeed(analogRead(5));

  // declare the digital out pins as OUTPUTs
  pinMode(recTrig, OUTPUT);
  pinMode(statusLED, OUTPUT);
  pinMode(waterPort, OUTPUT);
  pinMode(lickEvents, OUTPUT);
  pinMode(rewardTime, OUTPUT);
  pinMode(trialPin, OUTPUT);
     digitalWrite(trialPin, LOW);
          pinMode(speakerPin, OUTPUT);
          digitalWrite(speakerPin, HIGH); //audio is off in HIGH state
  pinMode(lickSens, INPUT);
  pinMode(speakerTRG,OUTPUT);



      Serial.println(end_trial_msg);


}

//-----------------
void loop() {

  t_init = millis();

  if (Serial.available()) {

    String input = getSerialInput();

    if ((mode == 'o') and (input == "GO")) {

      runTrial();


      Serial.println(end_trial_msg);
      digitalWrite(statusLED, LOW);
    }



    else {
      UpdateGlobals(input);
      
    }
  }
  else if (mode == 'h') {


    Habituation();
    digitalWrite(recTrig, HIGH);
  }


}
