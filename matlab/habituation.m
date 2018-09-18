function [output]=habituation(ID,hab_ITI, max_reward, waterVol,s);
%give function the ITI (ms), max number of trials and the amount of reward
%(ms solenoid valve opening), s=connected arduino
%%starts automatically with first lick
pause on;


fprintf(s,'mode:h'); %send arduino habituation mode
pause(1)%% each serial sending to arduino takes time to process
fprintf(s,sprintf('habituation_ITI:%d',hab_ITI)); %time where licks are detected but not rewarded
pause(1)
fprintf(s,sprintf('max_habituation_reward:%d',max_reward));
pause(1)
fprintf(s,sprintf('waterVol:%d',waterVol));
pause(1)
%add animal id, day and time 

date=datestr(now,'_yyyy_mm_dd__HH_MM');

hab=fopen(sprintf('habituation_%s%s.txt',ID,date),'wt'); 
fprintf(hab,'%s\n',ID);
fprintf(hab,'%s\n',date);
pause(1)
%%introduce a delay, all parameters have to be sent to the arduino first

%prompt={'Enter "start" to run the habituation'};%ask for habituation start signal
%title='Start signal Habituation phase'
%answer=inputdlg(prompt,title);
%fprintf(s,sprintf('input == %s',answer{1}))
    

while 1

    output = fscanf(s,'%s') %think about printing just summary instead of everything in the workspace
    
    fprintf(hab,'%s\n',output);
        if strcmp (output,'habituation_exit')
        break;
        end   
end
fclose(hab);



end

