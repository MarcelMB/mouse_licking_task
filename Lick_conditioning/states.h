/*
 * pre_trial period
 * _nolick period
 * stimulus
 * delay
 * response_period //we dont need that right now
 * _reward
 */

 int ActiveDelay(unsigned long wait, bool break_on_lick, 
                                    bool print_resp_time) {

    unsigned long _t0=millis(); //number of milliseconds since the arduino board began running the current program
    unsigned long t=t_since(_t0);
    unsigned long t_INIT=t_since(t_init);
    
    int count=0;
   

    if (verbose) {
      Serial.print("#Enter  `ActiveDelay`:\t");
      Serial.println(wait);
    }

    //Serial.print("#Enter `delay`:\t");//i added this for test
        //Serial.println(t_since(t_init));//i added this for test
            //Serial.println(t);
 
 

 while (t < wait) { //this statement will run as long as t < wait (the first input number into the function)
    t=t_since(_t0);
    //count += senseLick(); //add number of licks //senselick: function from sensors (for now check if input to lickSens is high) //x += y is equivalent to x= x +y
   
  if (senseLick()) { 
 
      count += 1; //add a lick to the counter

            Serial.print("response_time:\t"); //print the lick response time
            Serial.println(t_since(t_init));
    
      digitalWrite(lickEvents, HIGH); //send digital code to intan for each lick
      delay(2);
      digitalWrite(lickEvents, LOW);
  }


if (t_since(t_init) > t_stimONSET+(t_stimDUR-10)){ //in TrialStimulus() speakerPIN is set low, here it is set back to high shorly before the end duration of the tone (before new tonee is triggered)

   digitalWrite(speakerPin, HIGH); //set to high before next tone is triggered
 //digitalWrite(LED_BUILTIN,LOW);
 }



   //if (print_resp_time) { //if both statements are true it prints the repsonse time
     //Serial.print("response_time:\t");
        //Serial.println(t_since(t_init));
    //}
    if (break_on_lick and (count>minlickCount)){ //if both statements are true it exit, this is if tstement is only important if we want the reward delivery right after the lick detection
        if (verbose) {
            Serial.print("#Exit `ActiveDelay`:\t");
            Serial.println(t); 
        }
        return count;
    }
 }
if (verbose) {
    Serial.print("#Exit `ActiveDelay`:\t"); //after this the reward will be delivered
    Serial.println(t);
    }

//Serial.print("#Exit `delay`:\t");//i added this fot test
        //Serial.println(t_since(t_init));//i added this for test
    
    return count;
  }

//======================= active delay for habituation


 int ActiveDelayhabituation(unsigned long wait,bool break_on_lick,
                                    bool print_resp_time) {

    unsigned long _t0=millis(); //number of milliseconds since the arduino board began running the current program
    unsigned long t=t_since(_t0);
   
    
    int count=0;
   

    if (verbose) {
      Serial.print("#Enter  `ActiveDelay`:\t");
      Serial.println(wait);
    }

   
 
 

 while (t < wait) { //this statement will run as long as t < wait (the first input number into the function)
    t=t_since(_t0);
    //count += senseLick(); //add number of licks //senselick: function from sensors (for now check if input to lickSens is high) //x += y is equivalent to x= x +y
   
  if (senseLick()) { 
 
      count += 1; //add a lick to the counter

            Serial.print("response_time:\t"); //print the lick response time
            Serial.println(t_since(t_init));
    
      digitalWrite(lickEvents, HIGH); //send digital code to intan for each lick
      delay(2);
      digitalWrite(lickEvents, LOW);
  }


if (t_since(t_init) > (t_stimDUR/2)){ //in TrialStimulus() speakerPIN is set low, here it is set back to high after half the duration of the tone

   digitalWrite(speakerPin, HIGH); //set to high before next tone is triggered
 //digitalWrite(LED_BUILTIN,LOW);
 }


 }
    
    
 
if (verbose) {
    Serial.print("#Exit `ActiveDelay`:\t"); //after this the reward will be delivered
    Serial.println(t);
    }


    
    return count;
  

   }
  
// =====================

bool deliver_reward(bool water) {
  /* Open the water valve for a duration
   *  defined by waterVol */
   if (water) {
    digitalWrite(waterPort, HIGH);
    digitalWrite(rewardTime, HIGH);
    delay(waterVol);
    digitalWrite(waterPort,LOW);
     digitalWrite(rewardTime, LOW);
   }
 
  //if (verbose) {
      Serial.print("Water:");
      Serial.println(water);
  //}
  return 1;
}

// ============

void preTrial() {
  /* while the trial has not started
   *  1. update the time
   *
   *  2. trigger the recording by putting recTrig to HIGH
   */
long t=t_since(t_init);

if(verbose) {
   Serial.print("Enter_preTrial");
   Serial.println();
}

while (t==0) {
      //1. update time
     
      t=t_since(t_init);

      if (t%1000 <5){
          digitalWrite(LED_BUILTIN, HIGH);
          digitalWrite(trialPin, HIGH); 
      }
      else {
          //digitalWrite(LED_BUILTIN, LOW);
          //digitalWrite(trialPin, LOW);
      }

      // 3.trigger the recording //could also add camera recording here
      //if (t > -10){
        //digitalWrite(recTrig, HIGH);
      //}
}

//digitalWrite(recTrig, LOW); Intan trigger needs to stay on high

  if (verbose) {
     Serial.print("Exit_preTrial:\t");
     Serial.println(t);
    }
} 

//=======

int TrialStimulus () {

  int t_local=millis();
  int t=t_since(t_local);
  int count =0;

//Serial.println(t_since(t_local));

  if (verbose) { //verbose for full debug printing
    Serial.print("#Enter `TrialStimulus, Audio play start`:\t");
        Serial.println(t_since(t_init));
    }

//if (t_local >= 0){

    digitalWrite(speakerPin, LOW);
    //digitalWrite(LED_BUILTIN,HIGH);
   
   // delay(80);
//}  
   

 
    if (verbose) { //verbose for full debug printing
      Serial.print("#Exit `TrialStimulus`:\t");
      Serial.println(t_since(t_init));
    }
    return count;
}



