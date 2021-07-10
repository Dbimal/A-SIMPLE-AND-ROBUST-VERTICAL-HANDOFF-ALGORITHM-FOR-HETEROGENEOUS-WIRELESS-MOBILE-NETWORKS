%%         the simulation of this program is for heterogeneous          %%
%%         network in vertical handoff;                                 %%
%initial the parameters of network
clear
clc
global fc_LTE fc_Wimax LTE_BS_coordinate Wimax_BS_coordinate ...
    Wimax_BS_coordinate LTE_BS_coordinate
service_type=0;                %the subscriber type of service
                               %0 refers to real time service,on the
                               % contrary,1 refers to nonreal-time service
MS_coordinate=[100,0];    
LTE_BS_coordinate=[0,0]; %the coordinate of LTE BS
Wimax_BS_coordinate=[600,0];   %the coordinate of wimaxE BS
MS_speed=10;                   %the speed of mobile station

fc_LTE=2000*10^6;              %the frequency of the carrier for LTE
fc_Wimax=2500*10^6;            %the frequency of the carrier for Wimax
Net_state=0;                   %0 refers to LTE;1 refers to Wimax
handoff_drop=1;
handoff_clock=0;
count_handoff_number=0;
Tc=0.5;                      %time of measure interval
record_time=0;                %record the number of interval time of system
countinue_run=true;

while countinue_run
    
    %#################  measure the receieved signal strength  ############ 
    %if the mobile station is in the LTE network
    if is_in_LTE_coverage(MS_coordinate)
        RSS_LTE=calculate_RSS(MS_coordinate,'LTE');
    else
        RSS_LTE=-inf;
    end
    
    %if the mobile station is in the LTE network
    if is_in_Wimax_coverage(MS_coordinate)
        RSS_Wimax=calculate_RSS(MS_coordinate,'Wimax');
    else
        RSS_Wimax=-inf;
    end
    
    %###############  decide whether to handoff according to RSS  #########
    if Net_state==0&&RSS_LTE<RSS_Wimax
        if handoff_clock>handoff_drop
            if is_network_performance_meet(service_type)==1||(...
                    ~is_in_LTE_coverage(MS_coordinate)&&...
                    is_in_Wimax_coverage(MS_coordinate))
                                             %compare the performance of 
                                             %new network with the past
                                             %network
                count_handoff_number=count_handoff_number+1;
                Net_state=1;
                handoff_clock=0;             %reset the counter
            else
               handoff_clock=0;              %stay in the past network
            end
        else
            handoff_clock=handoff_clock+Tc;
        end
    elseif Net_state==1&&RSS_LTE>RSS_Wimax
        if handoff_clock>handoff_drop
            if is_network_performance_meet(service_type)==0||(...
                    is_in_LTE_coverage(MS_coordinate)&&...
                    ~is_in_Wimax_coverage(MS_coordinate))
                                             %compare the performance of 
                                             %new network with the past
                                             %network
                count_handoff_number=count_handoff_number+1;
                Net_state=0;
                handoff_clock=0;             %reset the counter
            else
               handoff_clock=0;              %stay in the past network
            end
        else
            handoff_clock=handoff_clock+Tc;
        end
    else
        handoff_clock=0;
    end
    
    %#####################  decide whether to continue run ################
    if is_in_LTE_coverage(MS_coordinate)||...
            is_in_Wimax_coverage(MS_coordinate)  
        
        %########################  record the data ########################
        record_time=record_time+1;
        record_RSS_LTE(record_time)=RSS_LTE;
        record_RSS_Wimax(record_time)=RSS_Wimax;
        record_Net_state(record_time)=Net_state; 
        MS_coordinate(1)=MS_coordinate(1)+MS_speed*Tc;
    else
        countinue_run=false;
    end 
end

%######################## plot the simulation results  ####################
t=[1:record_time]*Tc;
plot(t,record_RSS_LTE,'--ro','MarkerEdgeColor','g','MarkerFaceColor','y',...
    'MarkerSize',2);
hold on
plot(t,record_RSS_Wimax,'-.ks','MarkerEdgeColor','b',...
    'MarkerFaceColor','c','MarkerSize',2);
hold off
grid on
xlabel('time(s)');
ylabel('RSS(dBm)');
legend('LTE','Wimax');
title('the received signal strength about two networks');
figure
plot(t,record_Net_state,'--ro','MarkerEdgeColor','g','MarkerFaceColor','y',...
    'MarkerSize',2)
grid on
xlabel('time(s)');
ylabel('mark of network');
text(0,0,'\leftarrow LTE','FontSize',10)
text(0,1,'\leftarrow Wimax','FontSize',10)
title('the state of mobile station in LTE and Wimax network')
%############################END THE PROGRAM ##############################