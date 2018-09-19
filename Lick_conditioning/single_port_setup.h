//here we describe the different trial modes

char runTrial() {

   // returns 0 if the stimulus was applied
    // returns 1 if a timeout is required e.g. to much pre stimulus licking
    // until next trial

    // local variables and initialisation of the trial
    /* t_init is initialised such that t_since
       returns 0 at the start of the trial, and
       increases from there. */
    unsigned long t;
    char response = 0;
    int pre_count0 = 0;                   //number of licks
    int pre_count1 = 0;                   //number of licks
    int pre_count = 0;                   //number of licks

     
    
    int post_count = 0;                  //number of licks
    int rew_count = 0;
    //int N_to;                              //number of timeouts
    // local time

    t_init = millis();
//=======
    
    t = t_since(t_init);

    /*trial_phase0
    while the trial has not started
       1. update the time
       2. check for licks
       3. trigger the recording by putting recTrig -> HIGH
    */

//====== start pre-Trial
    preTrial();
    t=t_since(t_init);
//===== check for basline licking, if more than minmal licks this is an error trial
    
    //wait
    //pre_count0 += ActiveDelay(t_noLickPer, false); //animal should not lick in time of t_noLickPer
    //t=t_since(t_init);

    digitalWrite(trialPin, HIGH);
    pre_count1 += ActiveDelay(t_stimONSET, true);
    //t=t_since(t_init);

    pre_count1 += ActiveDelay(t_stimONSET - t, true);
    t=t_since(t_init);

    if ((pre_count1>0)){ //if animal licked (so t_noLickPer is true) in the duration of t_noLickPeriode

    response='e'; //means early lick (trial will break)

    digitalWrite(trialPin, LOW);

    Serial.print("\tresponse:");
    Serial.println(response);

    Serial.print("\tpre_count:");//count shortly before stimulus onset, should be zero to start running a trial
    Serial.println(pre_count1);

    //Serial.println("\tpost_count:nan");
    //Serial.println("\tpre_count:nan");
    //Serial.println("\trew_count:nan");

     //digitalWrite(recTrig, LOW); //stop intan recording (with timestamped saved intan file for one trial)
    
        return response;
    }


    pre_count=pre_count0+pre_count1;

    t= t_since(t_init);

//=== start trial with auditory stimulation


    TrialStimulus(); //here tone is played
     


    

//we dont want to delay cheking for licks after stimulus
//ActiveDelay(t_rewardDEL,false); //delay checking for licksafter the stimulus  //here the if statments in states.h ActiveDelay are ignored since the inout to the fucntion is false

//t=t_since(t_init);

t=t_since(t_init);
   post_count += ActiveDelay(t_rewardDUR,lickTrigReward, true); //get licks after tone onset till reward, the reward comes right after the t_rewardDUR, t_rewardDUR is the time from stimulus onset till the delivery of reward

//if ((t_since(t_init)-t) < t_rewardDUR) {
  //deliver_reward(lickTrigReward and (trialType =='G')); //so if t_rewardDUR is over than trigger reward delivery, Licktrigreward is set false in global variables which menas the reward is delivered after the response period
  //response=0;
  //rew_count += ActiveDelay((t_rewardDUR - (t_since(t_init) -t)),0); //how many licks we have during the response period after the stimulus
//}

if (trialType == 'G') {
  if (post_count >= minlickCount){ //this ensures that the water is not delivered if the animals doesnt show any response to the played tone and does not lick
  response='H';
  deliver_reward(1);
  }

else if (post_count < minlickCount)  {
  response='N';
  deliver_reward(0);
}
}
//continue trial till end
    t = t_since(t_init);
    if (t < t_trialDUR){
        rew_count += ActiveDelay((t_trialDUR - t), 0);
    }

    //else  {  
    digitalWrite(trialPin, LOW);
    //}

    
Serial.print("\tresponse:");
    Serial.println(response);

    Serial.print("\tpre_count:");//count shortly before stimulus onset, should be zero to start running a trial
    Serial.println(pre_count);

    Serial.print("\tpost_count:");//count after stimulus onset
    Serial.println(post_count);

    Serial.print("\trew_count:");//count after reward delivery
    Serial.println(rew_count);

 
    
    //digitalWrite(recTrig, LOW); //stop intan recording (with timestamped saved intan file for one trial)

    return response;
}


    //========== Habituation
    /*
     * in first training session: animal licking is monitored, on detection of a lick reponse
     * the auditroy cue is played and water is trigered, this should be repated
     * until the animals learns tone-reward relationship with licking the spout
     */

  int rew_stim_count = 0;
  unsigned long t;

    void Habituation() {

    t_init=millis();

    //check lick sensor
   
    
    if (senseLick()) {

      TrialStimulus();
      deliver_reward(1);

      rew_stim_count +=1;

      Serial.print("reward_stimulus_count:");
      Serial.println(rew_stim_count,DEC);


      
      Serial.println("Delay before next rewarded lick detection");
      
      //t_init = millis();
      //t=t_since(t_init);
      
      ActiveDelayhabituation(habituation_ITI,lickTrigReward, false);
      Serial.println(end_trial_msg);
    }
      else if (rew_stim_count == max_habituation_reward) {
            Serial.print("habituation_exit");
            
           Serial.end(); //stop running of script immediately
      }
    
    
}

    
