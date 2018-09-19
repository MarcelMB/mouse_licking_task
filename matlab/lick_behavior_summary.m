%clear all;

%find trial start samples
     h=find(board_dig_in_data(1,:)==1);
        i=diff(h);
            j=find(i>1);
                k=[1,j+1];
                    trial_start=h(k);
                    
                    
  %find trial end samples
     ha=find(board_dig_in_data(1,:)==1);
        ia=diff(ha);
            ja=find(ia>1);
                ka=[ja,ja(end)];
                    trial_end=ha(ka);

                    
 %get 'pre' licks: before stimulus start, which resulted in an 'error'
     %'e' trial, if licked in pre_stimulus time nor CS and reward was
     %delivered
     pre_licks={};
     
     for k=1:size(trial_start,2)
         
         L=find(board_dig_in_data(3,(trial_start(k):(trial_start(k)+CombData{2,9})))==1);
         
     V=find(diff(L)==1);%get only start time of lick
     O=L(V);
     pre_licks{k}=O;
     end
 
     
     
%find stimuli start sample point
a=find(board_dig_in_data(8,:)==0);
    b=diff(a);
        c=find(b>1);
            d=[1,c+1];
     stimulus_start=a(d);
         
%%add error trials to stimulus_start vector, final stimulus_start vector has length of number of total trials     
     for k=1:size(pre_licks,2)
         
         if isempty(pre_licks{k})==0
             stimulus_start=[stimulus_start(1:k-1) NaN stimulus_start(k:end)];
         end
         
         
     end
     
         
  
 %find water start sample points
 e=find(board_dig_in_data(2,:)==1);
    f=diff(e);
        g=find(f>1);
            h=[1,g+1];
    water_start=e(h);
    
    %%add error trials to water_start vector, final water_start vector has length of number of total trials     
     for k=1:size(pre_licks,2)
         
         if isempty(pre_licks{k})==0
             water_start=[water_start(1:k-1) NaN water_start(k:end)];
         end
         
         
     end
  
    
%find water end sample points
 o=find(board_dig_in_data(2,:)==1);
    p=diff(o);
        q=find(p>1);
            r=[q,q(end)];
     water_end=o(r);  
      %%add error trials to water_end vector, final water_start vector has length of number of total trials     

     for k=1:size(pre_licks,2)
         
         if isempty(pre_licks{k})==0
             water_end=[water_end(1:k-1) NaN water_end(k:end)];
         end
         
         
     end
     
    

     %get 'post' licks: from stimulus start till reward delivery start
 post_licks={};
 
    for k=1:size(trial_start,2)
        
        if isempty(pre_licks{k})==0 %if error trial occured, which means pre_licks is non empty
                post_licks{k}=[];%fill post_licks with empty vector
        
     
        else  
     
     L=find(board_dig_in_data(3,(trial_start(k):water_start(k)))==1); %get licks from trial start...pre licks should not exist since its a Hit trial, if staring with stimulus_start trial some licks are missed
     V=find(diff(L)==1);%get only start time of lick
     O=L(V);%+(stimulus_start(k)-trial_start(k)); %add pre stimulus time t_stimONSET, individual for eacht trial calculated from trial start till stimulus onset (practical its jittering a bit, theoretical it should be the same for each trial)
     
     post_licks{k}=O;
            end
        
    end
    
     
   %get 'reward' licks: from water end till reward delivery start    
    rew_licks={};
 
    for k=1:size(trial_start,2)
        
        if isempty(pre_licks{k})==0 %if error trial occured, which means pre_licks is non empty
                rew_licks{k}=[];%fill post_licks with empty vector
        
     
        else  
     
     Le=find(board_dig_in_data(3,(water_start(k):trial_end(k)))==1);
     Ve=find(diff(Le)==1);%get only start time of lick
     Oe=Le(Ve)+(water_start(k)-trial_start(k)); %add water_start time to start of reward lick count time, 
     
     reward_licks{k}=Oe;
            end
        
    end
                    
     
      
     
    
     
s=figure; 



for trials=1:(size(CombData,1)-3) %-3 because of header animal id and session

    
    
        if isempty(pre_licks{trials}) %if pre_licks cell is empty (meaning trial runs and doesnt broke in pre trial) than plot the licks
       
       if isempty(post_licks{trials})==0     
       plot(post_licks{trials},trials,'Marker','o','MarkerEdgeColor','black'); 
       hold on
       end
       plot(stimulus_start(trials)-trial_start(trials):(stimulus_start(trials)-trial_start(trials))+100*(frequency_parameters.amplifier_sample_rate /1000) ,trials*ones(1,101));
       hold on
       plot(water_start(trials)-trial_start(trials):(water_end(trials)-trial_start(trials)) ,trials*ones(1,size(water_start(trials):water_end(trials),2)),'Color','blue');
        end
        
        if isempty(reward_licks{trials})==0
            
        plot(reward_licks{trials},trials,'Marker','.','MarkerEdgeColor','black'); 
        hold on
        end
    
    if isempty(pre_licks{trials})==0
        
        plot(pre_licks{trials},trials,'Marker','+','MarkerEdgeColor','red'); 
       hold on
    end
       
    xlim([-100 CombData{2,11}+100])
    ylim([0 CombData{2,7}+5])
    xlabel('time (ms)');
    ylabel('trial');
    
end



%check timing parameters
trial_duration=trial_start-trial_end;
water_duration_water_end-water_start;
cs_onset=stimulus_start-trial_start;
