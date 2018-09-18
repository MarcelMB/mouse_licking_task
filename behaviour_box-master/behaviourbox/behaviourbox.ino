#include <Arduino.h>

#include "global_variables.h"
#include "prototypes.h"

#include "timing.h"
#include "sensors.h"
#include "states.h"
#include "SerialComms.h"
#include "single_port_setup.h"

String version = "#BB_V3.0.20170201.8";
void setup (){
    // Open serial communications and wait for port to open:
    // This requires RX and TX channels (pins 0 and 1)
    // wait for serial port to connect. Needed for native USB port only
    Serial.begin(115200);
    while (!Serial) {
        ;
    }
    //Confirm connection and telegraph the code version

    Serial.println("#Arduino online");
    Serial.println  (version);
    
    randomSeed(analogRead(5));

    // declare the digital out pins as OUTPUTs
    pinMode(recTrig, OUTPUT);
    pinMode(bulbTrig, OUTPUT);
    pinMode(waterPort, OUTPUT);
    pinMode(buzzerPin, OUTPUT);
    pinMode(stimulusPin, OUTPUT);
    pinMode(speakerPin, OUTPUT);
    

    Serial.println(end_trial_msg);
}

void loop () {

    t_init = millis();

    if (Serial.available()){

String input = getSerialInput();

if (mode == 'o'){

         
             Serial.print("It works");
            runTrial();

            digitalWrite(bulbTrig, LOW);
            digitalWrite(recTrig, LOW);
            Serial.println(end_trial_msg);
}
            else { 
            UpdateGlobals(input);
        }
    }
}
