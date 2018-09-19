clear;

%%parameters
prompt={'animal ID','session'};
animal_stats=inputdlg(prompt);



%%
%%arudino initiation
%serial monitor on arudino has to be close
delete(instrfindall);
s=serial('COM8','BaudRate',115200);
fopen(s);

%%
%%habituation
%habituation_ITI=15000;
%max_reward=35;%maximal number of trials tone/water outputs
%waterVol=70; %ms of solenoid opening

%habituation_Output=habituation(animal_stats{1},habituation_ITI, max_reward, waterVol, s);

%%
%%operant conditioning
default_values={'5','100','3000','3000','7000','3','50','5000','2000'};

prompt={'number of trials','stimulus Duration, enter value from avisoft' ...
        'time (ms) relative to trial onset that the stimulus starts,in this period every lick breaks the trial and start a new one',...
        'time (ms) from CS till reward delivery (CS start till US (reward) start), +check for licks in that time','total trial duration (ms)',...
        'number of minimal licks to count as a hit response','amount of reward: time (ms) solenoid should be open','ITI (ms)','ITI jitter (ms)'};
title=('operational mode, define parameters');

answer=inputdlg(prompt,title,[1 40],default_values);

%a=arduino();
%writeDigitalPin(a,'D4',1); %start intan recording



[output]=operant((animal_stats{1}),(animal_stats{2}),str2double(answer{1}),str2double(answer{2}),str2double(answer{3}),str2double(answer{4}),... 
                        str2double(answer{5}),str2double(answer{6}),str2double(answer{7}), str2double(answer{8}), str2double(answer{9}),s)

%fclose(s)



%include a comment line during a running session or add comments after the
%session to the excel file!




