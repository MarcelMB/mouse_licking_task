function [output]=operant(ID,session,number_trials,t_stimDUR,t_stimONSET,... 
                        t_rewardDUR,t_trialDUR,minlickCount, waterVol, ITI, ITI_jitter,s);
                               
  
fprintf(s,'mode:o'); %send arduino operational mode
pause(0.5)%% each serial sending to arduino takes time to process
fprintf(s,sprintf('t_stimDUR:%d',t_stimDUR));
pause(0.5)
fprintf(s,sprintf('t_stimONSET:%d',t_stimONSET));
pause(0.5)
fprintf(s,sprintf('t_rewardDUR:%d',t_rewardDUR));
pause(0.5)
fprintf(s,sprintf('t_trialDUR:%d',t_trialDUR));
pause(0.5)
fprintf(s,sprintf('minlickCount:%d',minlickCount));
pause(0.5)
fprintf(s,sprintf('waterVol:%d',waterVol));
pause(1)                             
                               


ITI_min=ITI/1000-ITI_jitter/1000;
ITI_max=ITI/1000+ITI_jitter/1000;




 %live table with responses from arduino 
f=figure('NumberTitle','off','Name',ID);

l=figure('visible','off');
t=uitable(f,'ColumnName',{'response','water','pre_count','post_count','rew_count','ITI'}) ;   
l=uitable(l,'ColumnName',{'response','water','pre_count','post_count','rew_count','ITI', ...
    'number_trials','t_stimDUR','t_stimONSET','t_rewardDUR', ...
    't_trialDUR','minlickCount','waterVol','ITI setting','ITI_jitter'}) ;  
t.Position=[25 60 500 300];




table_extent = get(t,'Extent');
set(t,'Position',[1 1 table_extent(3) table_extent(4)])
figure_size = get(f,'outerposition');
desired_fig_size = [figure_size(1) figure_size(2) table_extent(3)+40 table_extent(4)+65];
set(f,'outerposition', desired_fig_size);


%create cancel pushbutton in figure
fig=figure('rend','painters','pos',[50 100 150 100]);
c=uicontrol('Style','togglebutton','String','Stop');
 


    current_trial=0;
   out=[];
    
   while current_trial<=number_trials
       
       
       stop_state = get(c, 'Value');
       if stop_state %if stop button in pressed
           break
       end
     
    
        
        output = fscanf(s,'%s')
               %grab responses and lick counts and put it into a table
               %figure
               if strcmp(output,'Enter_preTrial')
                    current_trial=current_trial+1 
               end
   
               %if current_trial>number_trials
                %break
                %fclose(s)
               
               if strcmp(output,'response:H')
                    colorgen =@(text) ['<html><table border=0 width=400 bgcolor=','#00FF7F', '><TR><TD>',text,'</TD></TR> </table></html>'];
                    t.Data{current_trial,1}=colorgen('H');%for live plotting with colors
                    l.Data{current_trial,1}=('H');%for generation of excel sheet
               end
               if strcmp(output,'response:N')
                    colorgen =@(text) ['<html><table border=0 width=400 bgcolor=','#DEB887', '><TR><TD>',text,'</TD></TR> </table></html>'];
                    t.Data{current_trial,1}=colorgen('N');
                    l.Data{current_trial,1}=('N');
               end
               if strcmp(output,'response:e')
                    colorgen =@(text) ['<html><table border=0 width=400 bgcolor=','#DC143C', '><TR><TD>',text,'</TD></TR> </table></html>'];
                    t.Data{current_trial,1}=colorgen('e');
                    l.Data{current_trial,1}=('e');
               end
               if strcmp(output,'Water:0') || strcmp(output,'response:e')
                    colorgen =@(text) ['<html><table border=0 width=400 bgcolor=','#C0C0C0', '><TR><TD>',text,'</TD></TR> </table></html>'];
                    t.Data{current_trial,2}=colorgen('0');
                    l.Data{current_trial,2}=('0');
               end
               if strcmp(output,'Water:1')
                    colorgen =@(text) ['<html><table border=0 width=400 bgcolor=','#00FFFF', '><TR><TD>',text,'</TD></TR> </table></html>'];
                    t.Data{current_trial,2}=colorgen('1');
                    l.Data{current_trial,2}=('1');
               end
              if strfind(output,'pre_count')
                   B = regexp(output,'\d*','Match');
                  C=cell2mat(B);
                  t.Data{current_trial,3}=C;
                  l.Data{current_trial,3}=C;
               end
               if strfind(output,'post_count')
                   C = regexp(output,'\d*','Match');
                  D=cell2mat(C);
                  t.Data{current_trial,4}=D;
                  l.Data{current_trial,4}=D;
               end
               if strfind(output,'rew_count')
                   E = regexp(output,'\d*','Match');
                  F=cell2mat(E);
                  t.Data{current_trial,5}=F;
                  l.Data{current_trial,5}=F;
               end
              
    
           
               if strcmp (output,'-Status:Ready') %at end of a trial (and once at beginning)
                        
                  
               
            %calculate ITI
            ITI_rand=(ITI_max-ITI_min).*rand(1,1)+ITI_min; %create random number between min and max ITI values
            ITI=round(10*ITI_rand)/10; %round ITI to first location after komma
            disp (sprintf('ITI for %0.5g seconds ', ITI));
            if current_trial>=1 %current_trial has to be 0 at beginning, cant put value in zero row in table
            t.Data{current_trial,6}=ITI;% put ITI into live table
            l.Data{current_trial,6}=ITI;%put ITI into saved excel sheet
            end
            
            %resize figure
            table_extent = get(t,'Extent');
set(t,'Position',[1 1 table_extent(3) table_extent(4)])
figure_size = get(f,'outerposition');
desired_fig_size = [figure_size(1) figure_size(2) table_extent(3)+15 table_extent(4)+100];
set(f,'outerposition', desired_fig_size);
            %
            
            if current_trial<number_trials
                
          
            pause(ITI)
            
            else
                break
            end
           
            
            fprintf(s,'%s','GO'); %send arduino GO signal
           
            
            
        
       
    
            
            
                
               
               
            end
            
      end

 disp('CONDITIONING FINISHED')
                disp(current_trial);
      
       ColumnName=get(l,'ColumnName')';
       
       Data=get(l,'Data');
       Data{1,end+1}=number_trials;
       
       Data{1,end+1}=t_stimDUR;
       Data{1,end+1}=t_stimONSET;
       Data{1,end+1}=t_rewardDUR;
       Data{1,end+1}=t_trialDUR;
       Data{1,end+1}=minlickCount;
       Data{1,end+1}=waterVol;
       Data{1,end+1}=ITI;
       Data{1,end+1}=ITI_jitter;
       Data{end+1,1}=ID;
       Data{end+1,1}=sprintf('session%s',session);
      
      
       CombData=[ColumnName;Data];
       
            date=datestr(now,'_yyyy_mm_dd__HH_MM');
       
       %xlswrite(sprintf('conditioning_%s_session%s%s',ID,session,date),CombData);
       save(sprintf('conditioning_%s_session%s%s.mat',ID,session,date),'CombData');
       

       
       
       print(f,'-fillpage',sprintf('pdf_conditioning_%s_session%s%s',ID,session,date),'-dpdf')








                               
                               
                               
                               
                               
                               

                               
                               
                               
                               
                               
end
