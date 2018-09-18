bool senseLick() {

// check if lick sensor gets a high digital input


bool CallSpike= false; //CallSpike is only defined here, nowhere else
bool spike= false;

if (lickOn ==false) { // if digital input is again at zero lickon is false and lick is finsihed
  CallSpike=true;
}

if (digitalRead(lickSens) == HIGH) {  //check if digital lick sensor input is high, during lick
  delay (2);
 lickOn =(digitalRead(lickSens) == HIGH); //pushbutton (fake lick for testing) induces a HIGH state
}


else {
  lickOn= false;
}
//if the sensor was off, and now its on, return 1
spike= CallSpike and lickOn;

return (spike);
}
