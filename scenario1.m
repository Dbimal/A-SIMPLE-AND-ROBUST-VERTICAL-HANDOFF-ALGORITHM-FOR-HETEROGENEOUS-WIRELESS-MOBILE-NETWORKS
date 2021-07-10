clear all;
close all;
clc;
sys=newfis('FLC');

sys=addvar(sys,'input','DR',[1 20]);

sys=addmf(sys,'input',1,'A1','trapmf',[0 1 5 8]);
sys=addmf(sys,'input',1,'A2','trimf',[5 10 15]);
sys=addmf(sys,'input',1,'A3','trapmf',[11 15 20 25]);
plotmf(sys,'input',1);title('Data Rate');

sys=addvar(sys,'input','IR',[-18 20]);

sys=addmf(sys,'input',2,'B1','trapmf',[-20 -18 -14 -1]);
sys=addmf(sys,'input',2,'B2','trimf',[-14 0 14]);
sys=addmf(sys,'input',2,'B3','trapmf',[1 14 20 25]);
figure;
plotmf(sys,'input',2);title('Interference Ratio');

sys=addvar(sys,'input','RSSI',[-90 -70]);

sys=addmf(sys,'input',3,'C1','trapmf',[-95 -90 -85 -82]);
sys=addmf(sys,'input',3,'C2','trimf',[-85 -80 -75]);
sys=addmf(sys,'input',3,'C3','trapmf',[-78 -75 -70 -65]);
figure;
plotmf(sys,'input',3);title('RSSI');

sys=addvar(sys,'output','APCV',[1 10]);

sys=addmf(sys,'output',1,'D1','trapmf',[0 1 2 3]);
sys=addmf(sys,'output',1,'D2','trimf',[4 6 7]);
sys=addmf(sys,'output',1,'D3','trapmf',[7 8 9 11]);
figure;
plotmf(sys,'output',1);title('APCV');

rule=[1 1 1 2 1 1 ;1 1 2 3 1 1;1 1 3 3 1 1;2 1 1 2 1 1 ;2 1 2 3 1 1;2 1 3 3 1 1;3 1 1 3 1 1 ;3 1 2 3 1 1;3 1 3 3 1 1;...
1 2 1 1 1 1 ;1 2 2 1 1 1;1 2 3 2 1 1;2 2 1 2 1 1 ;2 2 2 2 1 1;2 2 3 2 1 1;3 2 1 3 1 1 ;3 2 2 3 1 1;3 2 3 3 1 1;...
1 3 1 1 1 1 ;1 3 2 2 1 1;1 3 3 2 1 1;2 3 1 2 1 1 ;2 3 2 2 1 1;2 3 3 2 1 1;3 3 1 3 1 1 ;3 3 2 3 1 1;3 3 3 3 1 1];
sys=addrule(sys,rule);

figure;
plotfis(sys);


t=100:10:3500;
DR=randint(1,341,[10 20]);
inter=randint(1,341,[15 20]);
RSSI=randint(1,341,[-80 -70]);

for i=1:341
APCV(1,i)=evalfis([DR(1,i) inter(1,i) RSSI(1,i)],sys);
end

figure;
plot(t,APCV,'--rs');grid on;
axis([100 3500 0 10]);
xlabel('Time(sec)');ylabel('APCV');title('APCV (GSM1)');

DR=randint(1,341,[10 20]);
inter=randint(1,341,[15 20]);
RSSI=randint(1,341,[-80 -70]);

for i=1:341
APCV1(1,i)=evalfis([DR(1,i) inter(1,i) RSSI(1,i)],sys);
end

figure;
plot(t,APCV1,'-gd');grid on;
axis([100 3500 0 10]);
xlabel('Time(sec)');ylabel('APCV');title('APCV (GSM2)');

DR=[randint(1,10,[10 20]) randint(1,200,[3 4]) randint(1,131,[1 1])];
inter=randint(1,341,[15 20]);
RSSI=[randint(1,10,[-75 -70]) randint(1,200,[-86 -87]) randint(1,131,[-90 -90])];


for i=1:341
APCV2(1,i)=evalfis([DR(1,i) inter(1,i) RSSI(1,i)],sys);
end

figure;
plot(t,APCV2,'-*');grid on;
axis([100 3500 0 10]);
xlabel('Time(sec)');ylabel('APCV');title('APCV (WiFi)');

figure;
plot(t,APCV,'--rs',t,APCV1,'-gd',t,APCV2,'-*');grid on;
legend('GSM1','GSM2','WiFi');
axis([100 3500 0 10]);
xlabel('Time(sec)');ylabel('APCV');title('Output APCV');