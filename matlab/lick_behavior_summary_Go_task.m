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
          %L=find(board_dig_in_data(3,500:1000))==1);
         
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
    water_start_sample=e(h);
    
    water_counter=1;
    water_start={};
    %%add error trials and Miss trials to water_start vector, final water_start vector has length of number of total trials     
     for k=1:size(pre_licks,2)
         
         if CombData{k+1,1}=='H'
             water_start{k}=water_start_sample(water_counter);
             water_counter=water_counter+1;
         end
         
         if  CombData{k+1,1}=='N' || CombData{k+1,1}=='e'
             water_start{k}=[];
         
            
         end
         
        
     end
 
    
%find water end sample points
 o=find(board_dig_in_data(2,:)==1);
    p=diff(o);
        q=find(p>1);
            r=[q,q(end)];
     water_end_sample=o(r);  
      %%add error trials to water_end vector, final water_start vector has length of number of total trials     
 water_counter=1;
    water_end={};
     for k=1:size(pre_licks,2)
         
         
          if CombData{k+1,1}=='H'
             water_end{k}=water_end_sample(water_counter);
             water_counter=water_counter+1;
         end
         
         if  CombData{k+1,1}=='N' || CombData{k+1,1}=='e'
             water_end{k}=[];
         
            
         end
         
     end
     
    

     %get 'post' licks: from stimulus start till stimulus start+time till
     %reward comes
 post_licks={};
 
    for k=1:size(stimulus_start,2)
        
        if isnan(stimulus_start(k)) %CombData{k+1,1}=='e' %if error trial occured, which means pre_licks is non empty
                post_licks{k}=[];%fill post_licks with empty vector
        
        end
          
        if isnan(stimulus_start(k))==0
          
     L=find(board_dig_in_data(3,(stimulus_start(k):stimulus_start(k)+CombData{2,10}))==1); %get licks from trial start...pre licks should not exist since its a Hit trial, if staring with stimulus_start trial some licks are missed
     V=find(diff(L)==1);%get only start time of lick
     O=L(V)+(stimulus_start(k)-trial_start(k)); %add pre stimulus time t_stimONSET, individual for eacht trial calculated from trial start till stimulus onset (practical its jittering a bit, theoretical it should be the same for each trial)
     
     post_licks{k}=O;
        end 
    
        
    end
    
     
   %get 'reward' licks: from water end till reward delivery start    
    rew_licks={};
 
    for k=1:size(trial_start,2)
        
        if isempty(pre_licks{k})==0 %if error trial occured, which means pre_licks is non empty
                rew_licks{k}=[];%fill rew_licks with empty vector
        
     
        else  
     
     Le=find(board_dig_in_data(3,(water_start{k}:trial_end(k)))==1);
     Ve=find(diff(Le)==1);%get only start time of lick
     Oe=Le(Ve)+(water_start{k}-trial_start(k)); %add water_start time to start of reward lick count time, 
     
     rew_licks{k}=Oe;
            end
        
    end
                    
     
      
     
    
     
s=figure; 



for trials=1:(size(trial_start,2)) %-3 because of header animal id and session

    
    
        if (CombData{trials+1,1}=='H')  % trial runs and doesnt broke in pre trial) than plot the licks
       
       if isempty(post_licks{trials})==0     
       plot(post_licks{trials},trials,'Marker','o','MarkerEdgeColor','black'); 
       hold on
       end
       plot(stimulus_start(trials)-trial_start(trials):(stimulus_start(trials)-trial_start(trials))+100*(frequency_parameters.amplifier_sample_rate /1000) ,trials*ones(1,101));
       hold on
        if isempty(pre_licks{trials})==0
       plot(pre_licks{trials},trials,'Marker','+','MarkerEdgeColor','black'); 
        end
       
        if isempty(water_start{trials})==0  
      plot(water_start{trials}-trial_start(trials):(water_end{trials}-trial_start(trials)) ,trials*ones(1,size(water_start{trials}:water_end{trials},2)),'Color','blue');
        end
        
        if isempty(rew_licks{trials})==0
            
        plot(rew_licks{trials},trials,'Marker','.','MarkerEdgeColor','black'); 
        hold on
        end
        end
        
        if (CombData{trials+1,1}=='N')
            
        if isempty(post_licks{trials})==0     
       plot(post_licks{trials},trials,'Marker','o','MarkerEdgeColor','black'); 
       hold on
       end
       plot(stimulus_start(trials)-trial_start(trials):(stimulus_start(trials)-trial_start(trials))+100*(frequency_parameters.amplifier_sample_rate /1000) ,trials*ones(1,101));
       hold on 
       if isempty(pre_licks{trials})==0
       plot(pre_licks{trials},trials,'Marker','+','MarkerEdgeColor','black'); 
        end
       
        if isempty(water_start{trials})==0  
      plot(water_start{trials}-trial_start(trials):(water_end{trials}-trial_start(trials)) ,trials*ones(1,size(water_start{trials}:water_end{trials},2)),'Color','blue');
        end
        
        if isempty(rew_licks{trials})==0
            
        plot(rew_licks{trials},trials,'Marker','.','MarkerEdgeColor','black'); 
        hold on
        end
       
        end  
        
    if (CombData{trials+1,1}=='e' && isempty(pre_licks{trials})==0)
        
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
%water_duration=water_end-water_start;
cs_onset=stimulus_start-trial_start;
