clear 
clc 
rand('twister',0);
blockpu=[];
blocksu=[];
for N=3:2:7
    block=[];
    for lambdap =0.1:0.05:0.5
%***************************************** 
%����  1. CR�����������(��Ȩ����)��ͬ������ͬһ���򣬲���ʹ��ͬһƵ�Ρ������Ƶ�ι���N���ŵ���ÿ�����û���CR�û�ÿ�ν���ֻռ��һ���ŵ���
%        �������ŵ��������û�ռ�ã���ʱCR�û�����ͱ���������CR�û�����ʹ�õ��ŵ������û����֣���ʱCR�û������жϣ������뻺�����Ŷӵȴ�
%        ���п����ŵ��Լ����ձ��жϵ�ͨ�ţ����ȴ�����һ��ʱ�ޣ����ж�CR�û�ǿ���ж����뻺������
%        �ʹ����������У��ֱ��ʾ���£�
%          X���С������û����У���ռ���ȣ����ȼ����
%          Y���С������û����У����ȼ����
%          Z���С������û��л����У����ȼ��θߣ�����ʱ��Tao�ڣ���ϴ��û��������Ƚ�������ŵ�
%      2. ���û��ʹ��û��ĵ�����Ӳ��ɷֲ��������ֱ�Ϊlambdap��lambdas��ƽ������ʱ����Ӳ���Ϊmup��mus�ĸ�ָ���ֲ�
%      3. �Դ��û����ԣ����û���ռ���ȡ��ܹ���N���ŵ���Ҳ������������N�����û���ռ�����ŵ���
%         ��Z���еĳ��Ȳ��ᳬ��N���������Z���г���ΪN��
%      4. �����ʼ״̬����N���ŵ������У����û������֪����֪��ʱΪ0.005
%***************************************** 
%����   2009��10��12��  10��25��
%***************************************** 
%��ʼ�� 
%***************************************** 
a = 10; %���û�����
b = 100; %���û�����
%N =2  %Z������󳤶�/�ܵ��ŵ���
%Tao=5;%�л�ʱ������Tao
A = [ ]; %ĳ���û�����ʱ��ռ���ŵ���ŵļ���
B = [ ]; %ĳ���û�����ʱ��ռ���ŵ���ŵļ���
C = [ ]; %�л��û�ռ�õĵ�ǰ�����ŵ���ż���
D = [ ]; %ĳ���û�����ʱ�����û�ռ���ŵ�����
member = [ ];
member_CR = [ ];
j1=1;
%���û�����***************************************** 
%lambdap = 0.1; 
mup =0.6; %���û��������������
arr_meanp = 1/lambdap; 
ser_meanp = 1/mup;%���û�ƽ������ʱ����ƽ������ʱ�� 
arr_nump = a; %round(Total_time*lambdap*2);
tp = zeros(6,arr_nump); 
tp(1,:) = exprnd(arr_meanp,1,arr_nump); %����ָ���ֲ����������û�����ʱ���� 
tp(1,:) = cumsum(tp(1,:)); %�����û��ĵ���ʱ�̵���ʱ�������ۻ��� 
tp(2,:) = exprnd(ser_meanp,1,arr_nump); %����ָ���ֲ����������û�����ʱ��
%���û�����***************************************** 
lambdas =0.4; 
mus =0.7; %���û��������������
arr_means = 1/lambdas; 
ser_means = 1/mus; %���û�ƽ������ʱ����ƽ������ʱ��
arr_nums = b;  
ts = zeros(6,arr_nums); 
ts(1,:) = exprnd(arr_means,1,arr_nums); %����ָ���ֲ����������û��ﵽʱ����
ts(1,:) = cumsum(ts(1,:)); %�����û��ĵ���ʱ�̵���ʱ�������ۻ��� 
ts(2,:) = exprnd(ser_means,1,arr_nums); %����ָ���ֲ����������û�����ʱ�� 
%�л��û�����*****************************************������lambdah��muh
arr_numh = 10; %�л��û��Ŷӳ�������
th = zeros(6,arr_numh); 
tsh=[];
%***************************************** 
%�����1�����û�����Ϣ 
%***************************************** 
if arr_nump>=1
tp(3,1) = 0; %��1�����û�����ϵͳ��ֱ�ӽ��ܷ�������ȴ� 
n = ceil(rand*N); %����һ����N��Χ�ڵ��������Ϊ������ŵ����
tp(4,1) = tp(1,1)+tp(2,1); %���뿪ʱ�̵����䵽��ʱ�������ʱ��֮�� 
tp(5,1) = 1; %��϶���ϵͳ���ɣ���ʱϵͳ�ڹ���1�����û����ʱ�־λ��1 
tp(6,1) = n; %���μ�¼���û�ռ���ŵ������
A=[A n];
member = [1]; %�����ϵͳ��ϵͳ�����г�Ա���Ϊ1 
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
        ts(3,i) = 0.005; %��ȴ�ʱ��Ϊ 0
        ts(4,i) = ts(1,i)+ts(2,i)+ts(3,i); %���뿪ʱ�̵��ڵ���ʱ�������ʱ��֮�� 
        ts(5,i) = 1; %���־λ�� 1 ,�����û����õ�ǰ�ŵ�
        m = ceil(rand*N); %����һ����N��Χ�ڵ��������Ϊ������ŵ����
        ts(6,i) = m; %���μ�¼���û�ռ���ŵ������
        B=[B m];
        member_CR =[1];
        handoff1=find(tp(1,:)>ts(1,i));
        handoff2=find(tp(1,:)<ts(4,i));
        if isempty(handoff1)==0&&isempty(handoff2)==0
        handoff3=setdiff(handoff1,handoff2);%��ǰ���û�ͨ���ڼ䣨ʱ��Σ���������û�
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
                %�л������������ŵ�
                num_arrivep=find(tp(1,:)<=th(1,j1));
                num_leavep=find(tp(4,:)>=th(1,j1));
                num_present1=setdiff(num_arrivep,num_leavep);
                num_present2=setdiff(num_arrivep,num_present1);%��ǰ�ڵ����û�
                num_arrives=find(ts(1,:)<th(1,j1));
                num_leaves=find(ts(4,:)>th(1,j1));
                num_present3=setdiff(num_arrives,num_leaves);
                num_present4=setdiff(num_arrives,num_present3);%��ǰ�ڵĴ��û�
                num_present6=[];
wait=0;
   if j1>1
      j2=1:j1-1;
      num_arriveh=find(th(1,j2)<th(1,j1));
      num_leaveh=find(th(4,j2)>th(1,j1));
      num_present5=setdiff(num_arriveh,num_leaveh);
      num_present6=setdiff(num_arriveh,num_present5);%��ǰ�ڵ��л��û�
      for j3=1:length(num_present6)
      wait=wait+th(3,num_present6(j3));
      end
      th(3,j1)=wait;%�л��û��Ŷӵȴ�ʱ��
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
        number_CR = find(ts(4,j) > ts(1,i));  %��ǰռ���ŵ��Ĵ��û�����
        [th1,th2]=find(th==0);
        th(:,th2)=[];
        if isempty(number_CR)&&isempty(th)
         m = ceil(rand*N); %����һ����N��Χ�ڵ��������Ϊ������ŵ����
         ts(3,i) = 0.005;
         ts(4,i) = ts(1,i)+ts(2,i)+ts(3,i); %���뿪ʱ�̵��ڵ���ʱ�������ʱ��֮��
         ts(5,i) = 1; %���־λ�� 1 ,�����û����õ�ǰ�ŵ�
         ts(6,i) = m; %���μ�¼���û�ռ���ŵ������
         B=[B m]; 
         member_CR = [member_CR,i];
         handoff1=find(tp(1,:)>ts(1,i));
        handoff2=find(tp(1,:)<ts(4,i));
        if isempty(handoff1)==0&&isempty(handoff2)==0
        handoff3=setdiff(handoff1,handoff2);%��ǰ���û�ͨ���ڼ䣨ʱ��Σ���������û�
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
             %�л������������ŵ�
                num_arrivep=find(tp(1,:)<=th(1,j1));
                num_leavep=find(tp(4,:)>=th(1,j1));
                num_present1=setdiff(num_arrivep,num_leavep);
                num_present2=setdiff(num_arrivep,num_present1);%��ǰ�ڵ����û�
                num_arrives=find(ts(1,:)<th(1,j1));
                num_leaves=find(ts(4,:)>th(1,j1));
                num_present3=setdiff(num_arrives,num_leaves);
                num_present4=setdiff(num_arrives,num_present3);%��ǰ�ڵĴ��û�
                num_present6=[];
wait=0;
   if j1>1
      j2=1:j1-1;
      num_arriveh=find(th(1,j2)<th(1,j1));
      num_leaveh=find(th(4,j2)>th(1,j1));
      num_present5=setdiff(num_arriveh,num_leaveh);
      num_present6=setdiff(num_arriveh,num_present5);%��ǰ�ڵ��л��û�
      for j3=1:length(num_present6)
      wait=wait+th(3,num_present6(j3));
      end
      th(3,j1)=wait;%�л��û��Ŷӵȴ�ʱ��
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
            m = ceil(rand*N); %����һ����N��Χ�ڵ��������Ϊ������ŵ����
            while any(m == ts(6,number_CR))&&any(m == th(6,:))
                  m = ceil(rand*N);                        
            end
         ts(3,i) = 0.005;
         ts(4,i) = ts(1,i)+ts(2,i)+ts(3,i); %���뿪ʱ�̵��ڵ���ʱ�������ʱ��֮��
         ts(5,i) = 1; %���־λ�� 1 ,�����û����õ�ǰ�ŵ�
         ts(6,i) = m; %���μ�¼���û�ռ���ŵ������
         B=[B m]; 
         member_CR = [member_CR,i]; %���ϵͳ�д��û����ڽ��ܷ�����ϵͳ�ȴ�����δ�������i�����û�����ϵͳ
        handoff1=find(tp(1,:)>ts(1,i));
        handoff2=find(tp(1,:)<ts(4,i));
        if isempty(handoff1)==0&&isempty(handoff2)==0
        handoff3=setdiff(handoff1,handoff2);%��ǰ���û�ͨ���ڼ䣨ʱ��Σ���������û�
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
             %�л������������ŵ�
                num_arrivep=find(tp(1,:)<=th(1,j1));
                num_leavep=find(tp(4,:)>=th(1,j1));
                num_present1=setdiff(num_arrivep,num_leavep);
                num_present2=setdiff(num_arrivep,num_present1);%��ǰ�ڵ����û�
                num_arrives=find(ts(1,:)<th(1,j1));
                num_leaves=find(ts(4,:)>th(1,j1));
                num_present3=setdiff(num_arrives,num_leaves);
                num_present4=setdiff(num_arrives,num_present3);%��ǰ�ڵĴ��û�
                num_present6=[];
wait=0;
   if j1>1
      j2=1:j1-1;
      num_arriveh=find(th(1,j2)<th(1,j1));
      num_leaveh=find(th(4,j2)>th(1,j1));
      num_present5=setdiff(num_arriveh,num_leaveh);
      num_present6=setdiff(num_arriveh,num_present5);%��ǰ�ڵ��л��û�
      for j3=1:length(num_present6)
      wait=wait+th(3,num_present6(j3));
      end
      th(3,j1)=wait;%�л��û��Ŷӵȴ�ʱ��
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
        elseif number_CR+length(th(1,:)) >= N %���ϵͳ��������ϵͳ�ܾ���i�����û������־λ�� 0  //���û�����
            ts(5,i) = 0; %���־λ�� 0 ,�����û����õ�ǰ�ŵ�
       end
    end   
 end
end
else
    %***********************��һ�����û�������Ϣ
        ts(3,1) = 0.005; %��ȴ�ʱ��Ϊ 0
        ts(4,1) = ts(1,1)+ts(2,1)+ts(3,1); %���뿪ʱ�̵��ڵ���ʱ�������ʱ��֮�� 
        ts(5,1) = 1; %���־λ�� 1 ,�����û����õ�ǰ�ŵ�
        m = ceil(rand*N); %����һ����N��Χ�ڵ��������Ϊ������ŵ����
        ts(6,1) = m; %���μ�¼���û�ռ���ŵ������
        B=[B m];
        member_CR =[1];
    %************************��һ��֮��Ĵ��û�������Ϣ
    for i = 2:arr_nums  
    number = find(ts(4,:) > ts(1,i));  %��ǰռ���ŵ������û�����
    if isempty(number) %���ϵͳΪ�գ����i�����û�ֱ�ӽ��ܷ���
        m = ceil(rand*N); %����һ����N��Χ�ڵ��������Ϊ������ŵ����
        ts(3,i)=0.005;
        ts(4,i)=ts(1,i)+ts(2,i)+ts(3,1); %���뿪ʱ�̵��ڵ���ʱ�������ʱ��֮��
        ts(5,i) = 1; %���־λ�� 1   
        ts(6,i) = m; %���μ�¼���û�ռ���ŵ������
        B=[B m];
        member_CR = [member_CR,i]; %���ϵͳ�����û����ڽ��ܷ�����ϵͳ�ȴ�����δ�������i�����û�����ϵͳ
    elseif isempty(number)==0&&length(number)<N
        m = ceil(rand*N); %����һ����N��Χ�ڵ��������Ϊ������ŵ����
        while any(m==ts(6,number))
             m = ceil(rand*N);
        end            
        ts(3,i)=0.005;
        ts(4,i)=ts(1,i)+ts(2,i)+ts(3,1); %���뿪ʱ�̵��ڵ���ʱ�������ʱ��֮��
        ts(5,i) = 1; %���־λ�� 1   
        ts(6,i) = m; %���μ�¼���û�ռ���ŵ������
        B=[B m];  
        member_CR = [member_CR,i]; %���ϵͳ�����û����ڽ��ܷ�����ϵͳ�ȴ�����δ�������i�����û�����ϵͳ
    elseif  length(number) >= N %���ϵͳ��������ϵͳ�ܾ���i�����û������־λ�� 0  //���û�����
        ts(5,i) = 1; %���־λ�� 1 ,�����û����õ�ǰ�ŵ�                
    end     
end
end
else
    !echo No Cognitive Radio Users!!!!
end
%*****************************************�����ǵ�һ�����û�����ʱ��֮ǰ���ܵ���Ĵ��û���Ϣ OK 10��26��
%*****************************************�����ǵ�һ�����û�֮�󵽴�����û���Ϣ
if arr_nump>=1
for i = 2:arr_nump  
    number = find(tp(4,:) > tp(1,i));  %��ǰռ���ŵ������û�����
    if isempty(number)==1 %���ϵͳΪ�գ����i�����û�ֱ�ӽ��ܷ���
        n = ceil(rand*N); %����һ����N��Χ�ڵ��������Ϊ������ŵ����
        tp(3,i)=0;
        tp(4,i)=tp(1,i)+tp(2,i); %���뿪ʱ�̵��ڵ���ʱ�������ʱ��֮��
        tp(5,i) = 1; %���־λ�� 1   
        tp(6,i) = n; %���μ�¼���û�ռ���ŵ������
        A=[A n];
    elseif isempty(number)==0&&length(number)<N
        n = ceil(rand*N); %����һ����N��Χ�ڵ��������Ϊ������ŵ����
        while any(n==tp(6,number))
             n = ceil(rand*N);
        end            
        tp(3,i)=0;
        tp(4,i)=tp(1,i)+tp(2,i); %���뿪ʱ�̵��ڵ���ʱ�������ʱ��֮��
        tp(5,i) = 1; %���־λ�� 1   
        tp(6,i) = n; %���μ�¼���û�ռ���ŵ������
        A=[A n];   
    elseif  length(number) >= N %���ϵͳ��������ϵͳ�ܾ���i�����û������־λ�� 0  //���û�����
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
         tp(4,i) = tp(1,i)+tp(2,i)+tp(3,i); %���뿪ʱ�̵��ڵ���ʱ�������ʱ��֮��
         tp(5,i) = 1; %���־λ�� 1 ,�����û����õ�ǰ�ŵ�
         tp(6,i) = tp(6,tx(l)); %���μ�¼���û�ռ���ŵ������
         A=[A tp(6,i)];             
    end     
    member = [member,i]; %���ϵͳ�����û����ڽ��ܷ�����ϵͳ�ȴ�����δ�������i�����û�����ϵͳ
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
        num_S=find(ts(4,y) > ts(1,j));  %��ǰts(1,p)ʱ��ռ���ŵ��Ĵ��û�����
    end
    [th1,th2]=find(th==0);
    th(:,th2)=[];
    if isempty(num_S)&&isempty(num_P)&&isempty(th)    
    m = ceil(rand*N); %����һ����N��Χ�ڵ��������Ϊ������ŵ����
    ts(3,j) = 0.005;
    ts(4,j) = ts(1,j)+ts(2,j)+ts(3,j); %���뿪ʱ�̵��ڵ���ʱ�������ʱ��֮��         
    ts(5,j) = 1; %���־λ�� 1         
    ts(6,j) = m; %���μ�¼���û�ռ���ŵ������        
    B=[B m]; 
    member_CR = [member_CR,j]; %���ϵͳ�д��û����ڽ��ܷ�����ϵͳ�ȴ�����δ�������c�����û�����ϵͳ         
    handoff1=find(tp(1,:)>ts(1,j));
        handoff2=find(tp(1,:)<ts(4,j));
        if isempty(handoff1)==0&&isempty(handoff2)==0
        handoff3=setdiff(handoff1,handoff2);%��ǰ���û�ͨ���ڼ䣨ʱ��Σ���������û�
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
             %�л������������ŵ�
                num_arrivep=find(tp(1,:)<=th(1,j1));
                num_leavep=find(tp(4,:)>=th(1,j1));
                num_present1=setdiff(num_arrivep,num_leavep);
                num_present2=setdiff(num_arrivep,num_present1);%��ǰ�ڵ����û�
                num_arrives=find(ts(1,:)<th(1,j1));
                num_leaves=find(ts(4,:)>th(1,j1));
                num_present3=setdiff(num_arrives,num_leaves);
                num_present4=setdiff(num_arrives,num_present3);%��ǰ�ڵĴ��û�
                num_present6=[];
wait=0;
   if j1>1
      j2=1:j1-1;
      num_arriveh=find(th(1,j2)<th(1,j1));
      num_leaveh=find(th(4,j2)>th(1,j1));
      num_present5=setdiff(num_arriveh,num_leaveh);
      num_present6=setdiff(num_arriveh,num_present5);%��ǰ�ڵ��л��û�
      for j3=1:length(num_present6)
      wait=wait+th(3,num_present6(j3));
      end
      th(3,j1)=wait;%�л��û��Ŷӵȴ�ʱ��
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
        ts(4,j) = ts(1,j)+ts(2,j)+ts(3,j); %���뿪ʱ�̵��ڵ���ʱ�������ʱ��֮��         
        ts(5,j) = 1; %���־λ�� 1         
        ts(6,j) = m; %���μ�¼���û�ռ���ŵ������        
        B=[B m];
        member_CR = [member_CR,j]; 
        handoff1=find(tp(1,:)>ts(1,j));
        handoff2=find(tp(1,:)<ts(4,j));
        if isempty(handoff1)==0&&isempty(handoff2)==0
        handoff3=setdiff(handoff1,handoff2);%��ǰ���û�ͨ���ڼ䣨ʱ��Σ���������û�
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
             %�л������������ŵ�
                num_arrivep=find(tp(1,:)<=th(1,j1));
                num_leavep=find(tp(4,:)>=th(1,j1));
                num_present1=setdiff(num_arrivep,num_leavep);
                num_present2=setdiff(num_arrivep,num_present1);%��ǰ�ڵ����û�
                num_arrives=find(ts(1,:)<th(1,j1));
                num_leaves=find(ts(4,:)>th(1,j1));
                num_present3=setdiff(num_arrives,num_leaves);
                num_present4=setdiff(num_arrives,num_present3);%��ǰ�ڵĴ��û�
                num_present6=[];
wait=0;
   if j1>1
      j2=1:j1-1;
      num_arriveh=find(th(1,j2)<th(1,j1));
      num_leaveh=find(th(4,j2)>th(1,j1));
      num_present5=setdiff(num_arriveh,num_leaveh);
      num_present6=setdiff(num_arriveh,num_present5);%��ǰ�ڵ��л��û�
      for j3=1:length(num_present6)
      wait=wait+th(3,num_present6(j3));
      end
      th(3,j1)=wait;%�л��û��Ŷӵȴ�ʱ��
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
    elseif (length(num_P)+length(num_S))+length(th(1,:))>=N %���ϵͳ��������ϵͳ�ܾ���i�����û����룬���־λ�� 0  //���û�����                
        ts(5,j)=0;
    end
    if j<arr_numss
        j=j+1;
    end
end
if arr_numss<arr_nums
    for i = arr_numss+1:arr_nums  
    number = find(ts(4,:) > ts(1,i));  %��ǰռ���ŵ������û�����
    if isempty(number) %���ϵͳΪ�գ����i�����û�ֱ�ӽ��ܷ���
        m = ceil(rand*N); %����һ����N��Χ�ڵ��������Ϊ������ŵ����
        ts(3,i)=0.005;
        ts(4,i)=ts(1,i)+ts(2,i)+ts(3,1); %���뿪ʱ�̵��ڵ���ʱ�������ʱ��֮��
        ts(5,i) = 1; %���־λ�� 1   
        ts(6,i) = m; %���μ�¼���û�ռ���ŵ������
        B=[B m];
        member_CR = [member_CR,i]; %���ϵͳ�����û����ڽ��ܷ�����ϵͳ�ȴ�����δ�������i�����û�����ϵͳ
    elseif isempty(number)==0&&length(number)<N
        m = ceil(rand*N); %����һ����N��Χ�ڵ��������Ϊ������ŵ����
        while any(m==ts(6,number))
             m = ceil(rand*N);
        end            
        ts(3,i)=0.005;
        ts(4,i)=ts(1,i)+ts(2,i)+ts(3,1); %���뿪ʱ�̵��ڵ���ʱ�������ʱ��֮��
        ts(5,i) = 1; %���־λ�� 1   
        ts(6,i) = m; %���μ�¼���û�ռ���ŵ������
        B=[B m];  
        member_CR = [member_CR,i]; %���ϵͳ�����û����ڽ��ܷ�����ϵͳ�ȴ�����δ�������i�����û�����ϵͳ
    elseif  length(number) >= N %���ϵͳ��������ϵͳ�ܾ���i�����û������־λ�� 0  //���û�����
        ts(5,i) = 1; %���־λ�� 1 ,�����û����õ�ǰ�ŵ�                
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