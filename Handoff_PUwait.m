clear 
clc 
rand('twister',0);
blockpu=[];
blocksu=[];
for N=3:2:7
    block=[];
    for lambdap =0.1:0.05:0.5
%***************************************** 
%假设  1. CR网络和主网络(授权网络)共同存在于同一区域，并且使用同一频段。假设该频段共有N个信道，每个主用户或CR用户每次接入只占用一个信道。
%        若所有信道均被主用户占用，此时CR用户到达就被阻塞。若CR用户正在使用的信道有主用户出现，此时CR用户被迫中断，并进入缓存区排队等待
%        空闲可用信道以继续刚被中断的通信，若等待超过一定时限，则判定CR用户强制中断退离缓存区。
%        故共有三个队列，分别表示如下：
%          X队列——主用户队列，抢占优先，优先级最高
%          Y队列——次用户队列，优先级最低
%          Z队列——次用户切换队列，优先级次高，若在时延Tao内，则较次用户队列优先接入可用信道
%      2. 主用户和次用户的到达服从泊松分布，参数分别为lambdap和lambdas，平均服务时间服从参数为mup和mus的负指数分布
%      3. 对次用户而言，主用户抢占优先。总共有N个信道，也就是最多可以有N个主用户抢占所有信道，
%         故Z队列的长度不会超过N，这里给定Z队列长度为N。
%      4. 假设初始状态所有N个信道均空闲，次用户理想感知，感知延时为0.005
%***************************************** 
%吴呈瑜   2009年10月12日  10月25日
%***************************************** 
%初始化 
%***************************************** 
a = 10; %主用户数量
b = 100; %次用户数量
%N =2  %Z队列最大长度/总的信道数
%Tao=5;%切换时延门限Tao
A = [ ]; %某主用户到达时刻占用信道序号的集合
B = [ ]; %某次用户到达时刻占用信道序号的集合
C = [ ]; %切换用户占用的当前所有信道序号集合
D = [ ]; %某次用户到达时刻主用户占用信道集合
member = [ ];
member_CR = [ ];
j1=1;
%主用户参数***************************************** 
%lambdap = 0.1; 
mup =0.6; %主用户到达率与服务率
arr_meanp = 1/lambdap; 
ser_meanp = 1/mup;%主用户平均到达时间与平均服务时间 
arr_nump = a; %round(Total_time*lambdap*2);
tp = zeros(6,arr_nump); 
tp(1,:) = exprnd(arr_meanp,1,arr_nump); %按负指数分布产生各主用户到达时间间隔 
tp(1,:) = cumsum(tp(1,:)); %各主用户的到达时刻等于时间间隔的累积和 
tp(2,:) = exprnd(ser_meanp,1,arr_nump); %按负指数分布产生各主用户服务时间
%次用户参数***************************************** 
lambdas =0.4; 
mus =0.7; %次用户到达率与服务率
arr_means = 1/lambdas; 
ser_means = 1/mus; %次用户平均到达时间与平均服务时间
arr_nums = b;  
ts = zeros(6,arr_nums); 
ts(1,:) = exprnd(arr_means,1,arr_nums); %按负指数分布产生各次用户达到时间间隔
ts(1,:) = cumsum(ts(1,:)); %各次用户的到达时刻等于时间间隔的累积和 
ts(2,:) = exprnd(ser_means,1,arr_nums); %按负指数分布产生各次用户服务时间 
%切换用户参数*****************************************待计算lambdah和muh
arr_numh = 10; %切换用户排队长度设置
th = zeros(6,arr_numh); 
tsh=[];
%***************************************** 
%计算第1个主用户的信息 
%***************************************** 
if arr_nump>=1
tp(3,1) = 0; %第1个主用户进入系统后直接接受服务，无需等待 
n = ceil(rand*N); %产生一个在N范围内的随机数作为接入的信道序号
tp(4,1) = tp(1,1)+tp(2,1); %其离开时刻等于其到达时刻与服务时间之和 
tp(5,1) = 1; %其肯定被系统接纳，此时系统内共有1个主用户，故标志位置1 
tp(6,1) = n; %依次记录主用户占用信道的序号
A=[A n];
member = [1]; %其进入系统后，系统内已有成员序号为1 
else
    !echo No Primary Users!!!!
end
%***************************************** 
if arr_nums>=1
if arr_nump>=1
k1 = sum(ts(1,:) < tp(1,1));
if k1~=0
  for i =1:k1
    if i==1
        ts(3,i) = 0.005; %其等待时间为 0
        ts(4,i) = ts(1,i)+ts(2,i)+ts(3,i); %其离开时刻等于到达时刻与服务时间之和 
        ts(5,i) = 1; %其标志位置 1 ,即次用户在用当前信道
        m = ceil(rand*N); %产生一个在N范围内的随机数作为接入的信道序号
        ts(6,i) = m; %依次记录次用户占用信道的序号
        B=[B m];
        member_CR =[1];
        handoff1=find(tp(1,:)>ts(1,i));
        handoff2=find(tp(1,:)<ts(4,i));
        if isempty(handoff1)==0&&isempty(handoff2)==0
        handoff3=setdiff(handoff1,handoff2);%当前次用户通信期间（时间段）到达的主用户
        handoff=setdiff(handoff1,handoff3);
        handoff4=[];
        for puid=1:length(handoff)
           if tp(6,handoff(puid))==ts(6,i)
               handoff4=[handoff4,handoff(puid)];
               break;
           end
        end    
        if isempty(handoff4)==0
            if j1<=arr_numh                
                th(1,j1)=tp(1,handoff4(1));
                th(2,j1)=ts(4,i)-tp(1,handoff4(1));
                ts(4,i)=tp(1,handoff4(1));  
                tsh=ts(:,i);                     
                %切换到其他可用信道
                num_arrivep=find(tp(1,:)<=th(1,j1));
                num_leavep=find(tp(4,:)>=th(1,j1));
                num_present1=setdiff(num_arrivep,num_leavep);
                num_present2=setdiff(num_arrivep,num_present1);%当前在的主用户
                num_arrives=find(ts(1,:)<th(1,j1));
                num_leaves=find(ts(4,:)>th(1,j1));
                num_present3=setdiff(num_arrives,num_leaves);
                num_present4=setdiff(num_arrives,num_present3);%当前在的次用户
                num_present6=[];
wait=0;
   if j1>1
      j2=1:j1-1;
      num_arriveh=find(th(1,j2)<th(1,j1));
      num_leaveh=find(th(4,j2)>th(1,j1));
      num_present5=setdiff(num_arriveh,num_leaveh);
      num_present6=setdiff(num_arriveh,num_present5);%当前在的切换用户
      for j3=1:length(num_present6)
      wait=wait+th(3,num_present6(j3));
      end
      th(3,j1)=wait;%切换用户排队等待时间
   end
                if length(num_present2)==N
                    wait1=tp(4,num_present2(1));
                    for k=1:length(num_present2)
                    wait1=min(tp(4,num_present2(k)),wait1);
                    end
                    for k=1:length(num_present2)
                        if wait1==tp(4,num_present2(k))
                            wait2=num_present2(k);
                            break;
                        end
                    end
                   th(3,j1)=wait1-th(1,j1)+th(3,j1);
                   th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=tp(6,wait2);
                    tsh=[tsh,th(:,j1)];
                elseif isempty(num_present2)&&length(num_present4)==N
                    wait1=ts(4,num_present4(1));
                    for k=1:length(num_present4)
                    wait1=min(ts(4,num_present4(k)),wait1);
                    end
                    for k=1:length(num_present4)
                        if wait1==ts(4,num_present4(k))
                            wait3=num_present4(k);
                            break;
                        end
                    end
                    th(3,j1)=wait1-th(1,j1)+th(3,j1);
                    th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=ts(6,wait3);
                    tsh=[tsh,th(:,j1)];
                elseif length(num_present2)+length(num_present4)==N&&isempty(num_present2)==0&&isempty(num_present4)==0
                    wait1=tp(4,num_present2(1));
                    for k=1:length(num_present2)
                    wait1=min(tp(4,num_present2(k)),wait1);
                    end
                    for k=1:length(num_present4)
                    wait1=min(ts(4,num_present4(k)),wait1);
                    end
                    tps=[tp(:,num_present2),ts(:,num_present4)];
                    for k=1:length(tps)
                       if wait1==tps(4,k)
                       wait4=k;
                       break;
                       end
                    end 
                    th(3,j1)=wait1-th(1,j1)+th(3,j1);
                    th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=tps(6,wait4);
                    tsh=[tsh,th(:,j1)];
                elseif length(num_present2)+length(num_present4)<N
                    channel1=[tp(6,num_present2),ts(6,num_present4)];
                    channel=setdiff([1:N],channel1);
                    th(3,j1)=0.006+th(3,j1);
                    th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=channel(1);
                    tsh=[tsh,th(:,j1)];
                end
                j1=j1+1;
            end
        end         
        end
    elseif i >= 2
        j=1:i-1;
        number_CR = find(ts(4,j) > ts(1,i));  %当前占用信道的次用户个数
        [th1,th2]=find(th==0);
        th(:,th2)=[];
        if isempty(number_CR)&&isempty(th)
         m = ceil(rand*N); %产生一个在N范围内的随机数作为接入的信道序号
         ts(3,i) = 0.005;
         ts(4,i) = ts(1,i)+ts(2,i)+ts(3,i); %其离开时刻等于到达时刻与服务时间之和
         ts(5,i) = 1; %其标志位置 1 ,即次用户在用当前信道
         ts(6,i) = m; %依次记录次用户占用信道的序号
         B=[B m]; 
         member_CR = [member_CR,i];
         handoff1=find(tp(1,:)>ts(1,i));
        handoff2=find(tp(1,:)<ts(4,i));
        if isempty(handoff1)==0&&isempty(handoff2)==0
        handoff3=setdiff(handoff1,handoff2);%当前次用户通信期间（时间段）到达的主用户
        handoff=setdiff(handoff1,handoff3);
        handoff4=[];
        for puid=1:length(handoff)
           if tp(6,handoff(puid))==ts(6,i)
               handoff4=[handoff4,handoff(puid)];
               break;
           end
        end    
        if isempty(handoff4)==0
            if j1<=arr_numh
            th(1,j1)=tp(1,handoff4(1));
            th(2,j1)=ts(4,i)-tp(1,handoff4(1));
            ts(4,i)=tp(1,handoff4(1));
            tsh=[tsh,ts(:,i)]; 
             %切换到其他可用信道
                num_arrivep=find(tp(1,:)<=th(1,j1));
                num_leavep=find(tp(4,:)>=th(1,j1));
                num_present1=setdiff(num_arrivep,num_leavep);
                num_present2=setdiff(num_arrivep,num_present1);%当前在的主用户
                num_arrives=find(ts(1,:)<th(1,j1));
                num_leaves=find(ts(4,:)>th(1,j1));
                num_present3=setdiff(num_arrives,num_leaves);
                num_present4=setdiff(num_arrives,num_present3);%当前在的次用户
                num_present6=[];
wait=0;
   if j1>1
      j2=1:j1-1;
      num_arriveh=find(th(1,j2)<th(1,j1));
      num_leaveh=find(th(4,j2)>th(1,j1));
      num_present5=setdiff(num_arriveh,num_leaveh);
      num_present6=setdiff(num_arriveh,num_present5);%当前在的切换用户
      for j3=1:length(num_present6)
      wait=wait+th(3,num_present6(j3));
      end
      th(3,j1)=wait;%切换用户排队等待时间
   end
                if length(num_present2)==N
                    wait1=tp(4,num_present2(1));
                    for k=1:length(num_present2)
                    wait1=min(tp(4,num_present2(k)),wait1);
                    end
                    for k=1:length(num_present2)
                        if wait1==tp(4,num_present2(k))
                            wait2=num_present2(k);
                            break;
                        end
                    end
                   th(3,j1)=wait1-th(1,j1)+th(3,j1);
                   th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=tp(6,wait2);
                    tsh=[tsh,th(:,j1)];
                elseif isempty(num_present2)&&length(num_present4)==N
                    wait1=ts(4,num_present4(1));
                    for k=1:length(num_present4)
                    wait1=min(ts(4,num_present4(k)),wait1);
                    end
                    for k=1:length(num_present4)
                        if wait1==ts(4,num_present4(k))
                            wait3=num_present4(k);
                            break;
                        end
                    end
                    th(3,j1)=wait1-th(1,j1)+th(3,j1);
                    th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=ts(6,wait3);
                    tsh=[tsh,th(:,j1)];
                elseif length(num_present2)+length(num_present4)==N&&isempty(num_present2)==0&&isempty(num_present4)==0
                    wait1=tp(4,num_present2(1));
                    for k=1:length(num_present2)
                    wait1=min(tp(4,num_present2(k)),wait1);
                    end
                    for k=1:length(num_present4)
                    wait1=min(ts(4,num_present4(k)),wait1);
                    end
                    tps=[tp(:,num_present2),ts(:,num_present4)];
                    for k=1:length(tps)
                       if wait1==tps(4,k)
                       wait4=k;
                       break;
                       end
                    end 
                    th(3,j1)=wait1-th(1,j1)+th(3,j1);
                    th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=tps(6,wait4);
                    tsh=[tsh,th(:,j1)];
                elseif length(num_present2)+length(num_present4)<N
                    channel1=[tp(6,num_present2),ts(6,num_present4)];
                    channel=setdiff([1:N],channel1);
                    th(3,j1)=0.006+th(3,j1);
                    th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=channel(1);
                    tsh=[tsh,th(:,j1)];
                end
            j1=j1+1;
            end
        end       
        end
        elseif length(number_CR)+length(th(1,:))>0&&length(number_CR)+length(th(1,:))<N
            m = ceil(rand*N); %产生一个在N范围内的随机数作为接入的信道序号
            while any(m == ts(6,number_CR))&&any(m == th(6,:))
                  m = ceil(rand*N);                        
            end
         ts(3,i) = 0.005;
         ts(4,i) = ts(1,i)+ts(2,i)+ts(3,i); %其离开时刻等于到达时刻与服务时间之和
         ts(5,i) = 1; %其标志位置 1 ,即次用户在用当前信道
         ts(6,i) = m; %依次记录次用户占用信道的序号
         B=[B m]; 
         member_CR = [member_CR,i]; %如果系统有次用户正在接受服务，且系统等待队列未满，则第i个次用户进入系统
        handoff1=find(tp(1,:)>ts(1,i));
        handoff2=find(tp(1,:)<ts(4,i));
        if isempty(handoff1)==0&&isempty(handoff2)==0
        handoff3=setdiff(handoff1,handoff2);%当前次用户通信期间（时间段）到达的主用户
        handoff=setdiff(handoff1,handoff3);
        handoff4=[];
        for puid=1:length(handoff)
           if tp(6,handoff(puid))==ts(6,i)
               handoff4=[handoff4,handoff(puid)];
               break;
           end
        end    
        if isempty(handoff4)==0
            if j1<=arr_numh
            th(1,j1)=tp(1,handoff4(1));
            th(2,j1)=ts(4,i)-tp(1,handoff4(1));
            ts(4,i)=tp(1,handoff4(1));
            tsh=[tsh,ts(:,i)]; 
             %切换到其他可用信道
                num_arrivep=find(tp(1,:)<=th(1,j1));
                num_leavep=find(tp(4,:)>=th(1,j1));
                num_present1=setdiff(num_arrivep,num_leavep);
                num_present2=setdiff(num_arrivep,num_present1);%当前在的主用户
                num_arrives=find(ts(1,:)<th(1,j1));
                num_leaves=find(ts(4,:)>th(1,j1));
                num_present3=setdiff(num_arrives,num_leaves);
                num_present4=setdiff(num_arrives,num_present3);%当前在的次用户
                num_present6=[];
wait=0;
   if j1>1
      j2=1:j1-1;
      num_arriveh=find(th(1,j2)<th(1,j1));
      num_leaveh=find(th(4,j2)>th(1,j1));
      num_present5=setdiff(num_arriveh,num_leaveh);
      num_present6=setdiff(num_arriveh,num_present5);%当前在的切换用户
      for j3=1:length(num_present6)
      wait=wait+th(3,num_present6(j3));
      end
      th(3,j1)=wait;%切换用户排队等待时间
   end
                if length(num_present2)==N
                    wait1=tp(4,num_present2(1));
                    for k=1:length(num_present2)
                    wait1=min(tp(4,num_present2(k)),wait1);
                    end
                    for k=1:length(num_present2)
                        if wait1==tp(4,num_present2(k))
                            wait2=num_present2(k);
                            break;
                        end
                    end
                   th(3,j1)=wait1-th(1,j1)+th(3,j1);
                   th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=tp(6,wait2);
                    tsh=[tsh,th(:,j1)];
                elseif isempty(num_present2)&&length(num_present4)==N
                    wait1=ts(4,num_present4(1));
                    for k=1:length(num_present4)
                    wait1=min(ts(4,num_present4(k)),wait1);
                    end
                    for k=1:length(num_present4)
                        if wait1==ts(4,num_present4(k))
                            wait3=num_present4(k);
                            break;
                        end
                    end
                    th(3,j1)=wait1-th(1,j1)+th(3,j1);
                    th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=ts(6,wait3);
                    tsh=[tsh,th(:,j1)];
                elseif length(num_present2)+length(num_present4)==N&&isempty(num_present2)==0&&isempty(num_present4)==0
                    wait1=tp(4,num_present2(1));
                    for k=1:length(num_present2)
                    wait1=min(tp(4,num_present2(k)),wait1);
                    end
                    for k=1:length(num_present4)
                    wait1=min(ts(4,num_present4(k)),wait1);
                    end
                    tps=[tp(:,num_present2),ts(:,num_present4)];
                    for k=1:length(tps)
                       if wait1==tps(4,k)
                       wait4=k;
                       break;
                       end
                    end 
                    th(3,j1)=wait1-th(1,j1)+th(3,j1);
                    th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=tps(6,wait4);
                    tsh=[tsh,th(:,j1)];
                elseif length(num_present2)+length(num_present4)<N
                    channel1=[tp(6,num_present2),ts(6,num_present4)];
                    channel=setdiff([1:N],channel1);
                    th(3,j1)=0.006+th(3,j1);
                    th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=channel(1);
                    tsh=[tsh,th(:,j1)];
                end
            j1=j1+1;
            end
        end       
        end
        elseif number_CR+length(th(1,:)) >= N %如果系统已满，则系统拒绝第i个次用户，其标志位置 0  //次用户阻塞
            ts(5,i) = 0; %其标志位置 0 ,即次用户在用当前信道
       end
    end   
 end
end
else
    %***********************第一个次用户到达信息
        ts(3,1) = 0.005; %其等待时间为 0
        ts(4,1) = ts(1,1)+ts(2,1)+ts(3,1); %其离开时刻等于到达时刻与服务时间之和 
        ts(5,1) = 1; %其标志位置 1 ,即次用户在用当前信道
        m = ceil(rand*N); %产生一个在N范围内的随机数作为接入的信道序号
        ts(6,1) = m; %依次记录次用户占用信道的序号
        B=[B m];
        member_CR =[1];
    %************************第一个之后的次用户到达信息
    for i = 2:arr_nums  
    number = find(ts(4,:) > ts(1,i));  %当前占用信道的主用户个数
    if isempty(number) %如果系统为空，则第i个主用户直接接受服务
        m = ceil(rand*N); %产生一个在N范围内的随机数作为接入的信道序号
        ts(3,i)=0.005;
        ts(4,i)=ts(1,i)+ts(2,i)+ts(3,1); %其离开时刻等于到达时刻与服务时间之和
        ts(5,i) = 1; %其标志位置 1   
        ts(6,i) = m; %依次记录主用户占用信道的序号
        B=[B m];
        member_CR = [member_CR,i]; %如果系统有主用户正在接受服务，且系统等待队列未满，则第i个主用户进入系统
    elseif isempty(number)==0&&length(number)<N
        m = ceil(rand*N); %产生一个在N范围内的随机数作为接入的信道序号
        while any(m==ts(6,number))
             m = ceil(rand*N);
        end            
        ts(3,i)=0.005;
        ts(4,i)=ts(1,i)+ts(2,i)+ts(3,1); %其离开时刻等于到达时刻与服务时间之和
        ts(5,i) = 1; %其标志位置 1   
        ts(6,i) = m; %依次记录主用户占用信道的序号
        B=[B m];  
        member_CR = [member_CR,i]; %如果系统有主用户正在接受服务，且系统等待队列未满，则第i个主用户进入系统
    elseif  length(number) >= N %如果系统已满，则系统拒绝第i个主用户，其标志位置 0  //主用户阻塞
        ts(5,i) = 1; %其标志位置 1 ,即主用户在用当前信道                
    end     
end
end
else
    !echo No Cognitive Radio Users!!!!
end
%*****************************************以上是第一个主用户到达时刻之前可能到达的次用户信息 OK 10月26日
%*****************************************以下是第一个主用户之后到达的主用户信息
if arr_nump>=1
for i = 2:arr_nump  
    number = find(tp(4,:) > tp(1,i));  %当前占用信道的主用户个数
    if isempty(number)==1 %如果系统为空，则第i个主用户直接接受服务
        n = ceil(rand*N); %产生一个在N范围内的随机数作为接入的信道序号
        tp(3,i)=0;
        tp(4,i)=tp(1,i)+tp(2,i); %其离开时刻等于到达时刻与服务时间之和
        tp(5,i) = 1; %其标志位置 1   
        tp(6,i) = n; %依次记录主用户占用信道的序号
        A=[A n];
    elseif isempty(number)==0&&length(number)<N
        n = ceil(rand*N); %产生一个在N范围内的随机数作为接入的信道序号
        while any(n==tp(6,number))
             n = ceil(rand*N);
        end            
        tp(3,i)=0;
        tp(4,i)=tp(1,i)+tp(2,i); %其离开时刻等于到达时刻与服务时间之和
        tp(5,i) = 1; %其标志位置 1   
        tp(6,i) = n; %依次记录主用户占用信道的序号
        A=[A n];   
    elseif  length(number) >= N %如果系统已满，则系统拒绝第i个主用户，其标志位置 0  //主用户阻塞
        tx=[];
        ty=[];
        x=1:i-1;
        tx=find(tp(4,x)>tp(1,i));
        min_PU=tp(4,tx(1));
            for k=1:length(number)
                min_PU=min(tp(4,tx(k)),min_PU);
            end
            for k=1:length(number)
                if min_PU==tp(4,tx(k))
                    l=k;
                end
            end
         tp(3,i) = min_PU-tp(1,i);
         tp(4,i) = tp(1,i)+tp(2,i)+tp(3,i); %其离开时刻等于到达时刻与服务时间之和
         tp(5,i) = 1; %其标志位置 1 ,即主用户在用当前信道
         tp(6,i) = tp(6,tx(l)); %依次记录主用户占用信道的序号
         A=[A tp(6,i)];             
    end     
    member = [member,i]; %如果系统有主用户正在接受服务，且系统等待队列未满，则第i个主用户进入系统
end
end

 
if arr_nump>=1&&arr_nums>=1
    if tp(4,end)>=ts(1,end)
       arr_numss=arr_nums;
    else 
       xxx=find(ts(1,:)<=tp(1,end));
       arr_numss=xxx(end);
    end 
j = k1+1;
for i=2:arr_nump
        num_arrive=find(tp(1,:)<ts(1,j));
        num_leave=find(tp(4,:)>ts(1,j));
        num_P=[];
        num_S=[];
    for num=1:length(num_arrive)
       if any(num_arrive(num)==num_leave)
          num_P=[num_P,num_arrive(num)];
       end
    end
    if k1~=0
        y=1:j-1;
        num_S=find(ts(4,y) > ts(1,j));  %当前ts(1,p)时刻占用信道的次用户个数
    end
    [th1,th2]=find(th==0);
    th(:,th2)=[];
    if isempty(num_S)&&isempty(num_P)&&isempty(th)    
    m = ceil(rand*N); %产生一个在N范围内的随机数作为接入的信道序号
    ts(3,j) = 0.005;
    ts(4,j) = ts(1,j)+ts(2,j)+ts(3,j); %其离开时刻等于到达时刻与服务时间之和         
    ts(5,j) = 1; %其标志位置 1         
    ts(6,j) = m; %依次记录次用户占用信道的序号        
    B=[B m]; 
    member_CR = [member_CR,j]; %如果系统有次用户正在接受服务，且系统等待队列未满，则第c个次用户进入系统         
    handoff1=find(tp(1,:)>ts(1,j));
        handoff2=find(tp(1,:)<ts(4,j));
        if isempty(handoff1)==0&&isempty(handoff2)==0
        handoff3=setdiff(handoff1,handoff2);%当前次用户通信期间（时间段）到达的主用户
        handoff=setdiff(handoff1,handoff3);
        handoff4=[];
        for puid=1:length(handoff)
           if tp(6,handoff(puid))==ts(6,j)
               handoff4=[handoff4,handoff(puid)];
               break;
           end
        end        
        if isempty(handoff4)==0
            if j1<=arr_numh
            th(1,j1)=tp(1,handoff4(1));
            th(2,j1)=ts(4,j)-tp(1,handoff4(1));
            ts(4,j)=tp(1,handoff4(1));
            tsh=[tsh,ts(:,i)]; 
             %切换到其他可用信道
                num_arrivep=find(tp(1,:)<=th(1,j1));
                num_leavep=find(tp(4,:)>=th(1,j1));
                num_present1=setdiff(num_arrivep,num_leavep);
                num_present2=setdiff(num_arrivep,num_present1);%当前在的主用户
                num_arrives=find(ts(1,:)<th(1,j1));
                num_leaves=find(ts(4,:)>th(1,j1));
                num_present3=setdiff(num_arrives,num_leaves);
                num_present4=setdiff(num_arrives,num_present3);%当前在的次用户
                num_present6=[];
wait=0;
   if j1>1
      j2=1:j1-1;
      num_arriveh=find(th(1,j2)<th(1,j1));
      num_leaveh=find(th(4,j2)>th(1,j1));
      num_present5=setdiff(num_arriveh,num_leaveh);
      num_present6=setdiff(num_arriveh,num_present5);%当前在的切换用户
      for j3=1:length(num_present6)
      wait=wait+th(3,num_present6(j3));
      end
      th(3,j1)=wait;%切换用户排队等待时间
   end
                if length(num_present2)==N
                    wait1=tp(4,num_present2(1));
                    for k=1:length(num_present2)
                    wait1=min(tp(4,num_present2(k)),wait1);
                    end
                    for k=1:length(num_present2)
                        if wait1==tp(4,num_present2(k))
                            wait2=num_present2(k);
                            break;
                        end
                    end
                   th(3,j1)=wait1-th(1,j1)+th(3,j1);
                   th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=tp(6,wait2);
                    tsh=[tsh,th(:,j1)];
                elseif isempty(num_present2)&&length(num_present4)==N
                    wait1=ts(4,num_present4(1));
                    for k=1:length(num_present4)
                    wait1=min(ts(4,num_present4(k)),wait1);
                    end
                    for k=1:length(num_present4)
                        if wait1==ts(4,num_present4(k))
                            wait3=num_present4(k);
                            break;
                        end
                    end
                    th(3,j1)=wait1-th(1,j1)+th(3,j1);
                    th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=ts(6,wait3);
                    tsh=[tsh,th(:,j1)];
                elseif length(num_present2)+length(num_present4)==N&&isempty(num_present2)==0&&isempty(num_present4)==0
                    wait1=tp(4,num_present2(1));
                    for k=1:length(num_present2)
                    wait1=min(tp(4,num_present2(k)),wait1);
                    end
                    for k=1:length(num_present4)
                    wait1=min(ts(4,num_present4(k)),wait1);
                    end
                    tps=[tp(:,num_present2),ts(:,num_present4)];
                    for k=1:length(tps)
                       if wait1==tps(4,k)
                       wait4=k;
                       break;
                       end
                    end 
                    th(3,j1)=wait1-th(1,j1)+th(3,j1);
                    th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=tps(6,wait4);
                    tsh=[tsh,th(:,j1)];
                elseif length(num_present2)+length(num_present4)<N
                    channel1=[tp(6,num_present2),ts(6,num_present4)];
                    channel=setdiff([1:N],channel1);
                    th(3,j1)=0.006+th(3,j1);
                    th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=channel(1);
                    tsh=[tsh,th(:,j1)];
                end
            j1=j1+1;
            end
        end         
        end
    elseif length(num_S)+length(num_P)+length(th(1,:))>0&&length(num_S)+length(num_P)+length(th(1,:))< N
        m = ceil(rand*N);
        while any(m == tp(6,num_P))&&any(m == ts(6,num_S))&&any(m == th(6,:))                   
            m = ceil(rand*N);            
        end
        ts(3,j) = 0.005;
        ts(4,j) = ts(1,j)+ts(2,j)+ts(3,j); %其离开时刻等于到达时刻与服务时间之和         
        ts(5,j) = 1; %其标志位置 1         
        ts(6,j) = m; %依次记录次用户占用信道的序号        
        B=[B m];
        member_CR = [member_CR,j]; 
        handoff1=find(tp(1,:)>ts(1,j));
        handoff2=find(tp(1,:)<ts(4,j));
        if isempty(handoff1)==0&&isempty(handoff2)==0
        handoff3=setdiff(handoff1,handoff2);%当前次用户通信期间（时间段）到达的主用户
        handoff=setdiff(handoff1,handoff3);
        handoff4=[];
        for puid=1:length(handoff)
           if tp(6,handoff(puid))==ts(6,j)
               handoff4=[handoff4,handoff(puid)];
               break;
           end
        end        
        if isempty(handoff4)==0
            if j1<=arr_numh
            th(1,j1)=tp(1,handoff4(1));
            th(2,j1)=ts(4,j)-tp(1,handoff4(1));
            ts(4,j)=tp(1,handoff4(1));
            tsh=[tsh,ts(:,i)]; 
             %切换到其他可用信道
                num_arrivep=find(tp(1,:)<=th(1,j1));
                num_leavep=find(tp(4,:)>=th(1,j1));
                num_present1=setdiff(num_arrivep,num_leavep);
                num_present2=setdiff(num_arrivep,num_present1);%当前在的主用户
                num_arrives=find(ts(1,:)<th(1,j1));
                num_leaves=find(ts(4,:)>th(1,j1));
                num_present3=setdiff(num_arrives,num_leaves);
                num_present4=setdiff(num_arrives,num_present3);%当前在的次用户
                num_present6=[];
wait=0;
   if j1>1
      j2=1:j1-1;
      num_arriveh=find(th(1,j2)<th(1,j1));
      num_leaveh=find(th(4,j2)>th(1,j1));
      num_present5=setdiff(num_arriveh,num_leaveh);
      num_present6=setdiff(num_arriveh,num_present5);%当前在的切换用户
      for j3=1:length(num_present6)
      wait=wait+th(3,num_present6(j3));
      end
      th(3,j1)=wait;%切换用户排队等待时间
   end
                if length(num_present2)==N
                    wait1=tp(4,num_present2(1));
                    for k=1:length(num_present2)
                    wait1=min(tp(4,num_present2(k)),wait1);
                    end
                    for k=1:length(num_present2)
                        if wait1==tp(4,num_present2(k))
                            wait2=num_present2(k);
                            break;
                        end
                    end
                   th(3,j1)=wait1-th(1,j1)+th(3,j1);
                   th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=tp(6,wait2);
                    tsh=[tsh,th(:,j1)];
                elseif isempty(num_present2)&&length(num_present4)==N
                    wait1=ts(4,num_present4(1));
                    for k=1:length(num_present4)
                    wait1=min(ts(4,num_present4(k)),wait1);
                    end
                    for k=1:length(num_present4)
                        if wait1==ts(4,num_present4(k))
                            wait3=num_present4(k);
                            break;
                        end
                    end
                    th(3,j1)=wait1-th(1,j1)+th(3,j1);
                    th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=ts(6,wait3);
                    tsh=[tsh,th(:,j1)];
                elseif length(num_present2)+length(num_present4)==N&&isempty(num_present2)==0&&isempty(num_present4)==0
                    wait1=tp(4,num_present2(1));
                    for k=1:length(num_present2)
                    wait1=min(tp(4,num_present2(k)),wait1);
                    end
                    for k=1:length(num_present4)
                    wait1=min(ts(4,num_present4(k)),wait1);
                    end
                    tps=[tp(:,num_present2),ts(:,num_present4)];
                    for k=1:length(tps)
                       if wait1==tps(4,k)
                       wait4=k;
                       break;
                       end
                    end 
                    th(3,j1)=wait1-th(1,j1)+th(3,j1);
                    th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=tps(6,wait4);
                    tsh=[tsh,th(:,j1)];
                elseif length(num_present2)+length(num_present4)<N
                    channel1=[tp(6,num_present2),ts(6,num_present4)];
                    channel=setdiff([1:N],channel1);
                    th(3,j1)=0.006+th(3,j1);
                    th(4,j1)=th(1,j1)+th(2,j1)+th(3,j1);
                    th(5,j1)=1;
                    th(6,j1)=channel(1);
                    tsh=[tsh,th(:,j1)];
                end
            j1=j1+1;
            end
        end         
        end
    elseif (length(num_P)+length(num_S))+length(th(1,:))>=N %如果系统已满，则系统拒绝第i个次用户接入，其标志位置 0  //次用户阻塞                
        ts(5,j)=0;
    end
    if j<arr_numss
        j=j+1;
    end
end
if arr_numss<arr_nums
    for i = arr_numss+1:arr_nums  
    number = find(ts(4,:) > ts(1,i));  %当前占用信道的主用户个数
    if isempty(number) %如果系统为空，则第i个主用户直接接受服务
        m = ceil(rand*N); %产生一个在N范围内的随机数作为接入的信道序号
        ts(3,i)=0.005;
        ts(4,i)=ts(1,i)+ts(2,i)+ts(3,1); %其离开时刻等于到达时刻与服务时间之和
        ts(5,i) = 1; %其标志位置 1   
        ts(6,i) = m; %依次记录主用户占用信道的序号
        B=[B m];
        member_CR = [member_CR,i]; %如果系统有主用户正在接受服务，且系统等待队列未满，则第i个主用户进入系统
    elseif isempty(number)==0&&length(number)<N
        m = ceil(rand*N); %产生一个在N范围内的随机数作为接入的信道序号
        while any(m==ts(6,number))
             m = ceil(rand*N);
        end            
        ts(3,i)=0.005;
        ts(4,i)=ts(1,i)+ts(2,i)+ts(3,1); %其离开时刻等于到达时刻与服务时间之和
        ts(5,i) = 1; %其标志位置 1   
        ts(6,i) = m; %依次记录主用户占用信道的序号
        B=[B m];  
        member_CR = [member_CR,i]; %如果系统有主用户正在接受服务，且系统等待队列未满，则第i个主用户进入系统
    elseif  length(number) >= N %如果系统已满，则系统拒绝第i个主用户，其标志位置 0  //主用户阻塞
        ts(5,i) = 1; %其标志位置 1 ,即主用户在用当前信道                
    end     
    end
end
end
thh=setdiff(th(1,:),zeros(1,10));
forcehandoff=length(thh(1,:))/length(member_CR);
block=[block,forcehandoff];
end
    if isempty(blocksu)
        blocksu=[blocksu,block];
    else
    blocksu=[blocksu;block]
    end
end
figure;
lambdap =0.1:0.05:0.5;
plot(lambdap,blocksu(1,:),'s-m'); 
hold on;
plot(lambdap,blocksu(2,:),'+-c');
hold on;
plot(lambdap,blocksu(3,:),'o--');
legend('N=3','N=5','N=7');
xlabel('Lamdap');
ylabel('SU Handoff probability');
title 'SU Handoff probability with lamdap';
grid on; 
hold off;