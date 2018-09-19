//here are all the function names listed that are defined in other files,
//they are grouped by the file they come from under the repsetive heading

/*----------
 * sensors.h
 * ---------
 */

 bool senseLick();

 /*----------
 * states.h
 * ---------
 */

 int ActiveDelay (unsigned long wait, bool break_on_lick = false, bool print_resp_time = false);

 bool deliver_reward(bool water);

 void preTrial();

 int TrialStimulus();

 /*----------
 * single_port_setup.h
 * ---------
 */

 void Habituation();

 char runTrial();


 /*----------
 * SerialComms.h
 * ---------
 */

 String getSerialInput();

 int getSepIndex(String input, char seperator);

 int UpdateGlobals(String input);

 /*----------
 * timing.h
 * ---------
 */

 long t_since(unsigned long t_init);
