//parametgers used globally
//these parameters can be updated via the serial communication

//IO port settings
//====================
const byte waterPort=7;
const byte speakerPin=3;
const byte recTrig=4;
const byte statusLED=13;
//we dont need stimulus pin for any additonal stimulation
//const byte stimulusPin = 5;       // digital pin 3 control whisker stimulation
const byte lickSens=5;
const byte lickEvents=6; //sends lick events to intan
const byte rewardTime=8; //send solenoid opening time to intan
const byte trialPin=10; //send trial start and end time to intan

const byte speakerTRG=12;



const String end_trial_msg ="-Status: Ready";

//reference for lick in sensor
//====
bool lickOn=false;

//timing parameters.h
//=========================

unsigned long t_init; //ms to this variable the other times are measured relative to
//unsigned int t_noLickPer=2000; //ms after this time the program will break out of a trial if a lick is detected before the stimulus
unsigned int trial_delay=0; //ms delay the start of the trial
unsigned int t_stimDUR=100; //this has to match avisoft sound file duration (used as digital event code for avisoft trigger), we use t_rewardDUR as a time of reward onset(directly after t_rewardDUR) and to check for licks after stimulus onset (during t_rewardDUR)
unsigned int t_stimONSET= 3000; //The time in milliseconds relative to tiral start time that the stimulus turns on, also the time the animal shouldt lick oterwise the trial is abolsihed
unsigned int t_rewardDEL=5;  // delay from the end of stimulus until activating the lick sensor
unsigned int t_rewardDUR= 2000; //ms amount of time to check for licks, after this time the reward should be delivered //should be hopefully CS till US time
unsigned int t_trialDUR=5000; //ms, total time that the trial should last

unsigned int timeout=0; //ms

unsigned int max_habituation_reward=35; // maximal number of habituation trials
unsigned int habituation_ITI=15000; //ms amount of time before a next lick in habituation is detected, prevent continoiusly licking

byte debounce=5; // simple debounce method

char mode='o'; //one of 'h'abituation (system will deliver a stimulus and  a reward in response to animals lick), 'o'perant (system delivers a stimulus and listens for a response)
 byte minlickCount=5; //the number of licks required to count as  a response and to i.e. open solenoid
bool lickTrigReward=0; //set to true if we want to enable reward delivery immediately afzer minLick detection but we want it to be delivered at the end of the response duaration
//bool reward_nogo=0; //set to zero, if true a correct rejection will be rewarded at the end of the reward period



//Reward
//==========

//Global value to keep track of the total water consumed

byte waterVol=70;   // amount of time in millisceonds to hold the water valve open
char trialType= 'G';  //'G' or 'N'

//int lickThres=450;

bool verbose=true; //if true full debug printing
bool audio=false; //enables auditory cues for the response period
