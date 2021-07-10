clc;
clear all;
close all;

% BLOCKING PROBABILITY



%lamda=input('Enter the arrival rate of service requests per minute =');
%mu=input('Enter the departure rate of service requests per minute=');
Nn=input('Enter the No. of users (1-1000)= ');
lamda=linspace(1,1000);
mu=100;
row=lamda./mu;
%row=logspace(0.1,10);
disp('traffic load row is');
disp(row);

% NETWORK 1

rn1=input('Percentage of total request that will go to Network-1 = ');
%rn1=40;
N1=(rn1/100)*Nn;
%disp('N1 is');
%disp(N1);

row1=rn1.*row/100;
disp('traffic load of Network-1 is - row1 ')
disp(row1);

nume1=(row1.^N1).*(1-row1);
%disp('nume')
%disp(nume1);

pow1=row1.^(N1+1);
%disp('pow');
%disp(pow1);

deno1=1-(pow1);
%disp('deno');
%disp(deno1)

Pb1=nume1./deno1;
disp('BLOCKING PROBABILITY OF NETWORK-1 IS ');
disp(Pb1);


% NETWORK 2

rn2=input('Percentage of total request that will go to Network-2 = ');

%rn2=30;
N2=(rn2/100)*Nn;

row2=rn2.*row/100;
disp('traffic load of Network-1 is - row1 ')
disp(row2);

nume2=(row2.^N2).*(1-row2);
%disp('nume')
%disp(nume2);

pow2=row2.^(N2+1);
%disp('pow');
%disp(pow2);

deno2=1-(pow2);
%disp('deno');
%disp(deno2)

Pb2=nume2./deno2;
disp('BLOCKING PROBABILITY OF NETWORK-2 IS ');
disp(Pb2);


% NETWORK 3

rn3=input('Percentage of total request that will go to Network-3 = ');

%rn3=10;
N3=(rn3/100)*Nn;
row3=rn3.*row/100;
disp('traffic load of Network-1 is - row1 ')
disp(row3);

nume3=(row3.^N3).*(1-row3);
%disp('nume')
%disp(nume3);

pow3=row3.^(N3+1);
%disp('pow');
%disp(pow3);

deno3=1-(pow3);
%disp('deno');
%disp(deno3)

Pb3=nume3./deno3;
disp('BLOCKING PROBABILITY OF NETWORK-3 IS ');
disp(Pb3);

AR1=25/100;% percentage of max. APUSR for NETWORK-I

figure(1)
APUSR1=AR1*(1-Pb1)*1/6;
disp('Pb1');
disp(Pb1);
disp('APUSR1');
disp(APUSR1);
plot(row,APUSR1,'b*-')
title('row vs APUSR1')
xlabel('row')
ylabel('APUSR1')



AR2=33/100;% percentage of max. APUSR for NETWORK-II
figure(2)
APUSR2=AR2*(1-Pb2)*1/6;
disp('Pb2');
disp(Pb2);
disp('APUSR2');
disp(APUSR2);
plot(row,APUSR2,'b*-')
title('row vs APUSR2')
xlabel('row')
ylabel('APUSR2')


AR3=42/100;% percentage of max. APUSR for NETWORK-II
figure(3)
APUSR3=AR3*(1-Pb3)*1/6;
disp('Pb3');
disp(Pb3);
disp('APUSR3');
disp(APUSR3);
plot(row,APUSR3,'b*-')
title('row vs APUSR3')
xlabel('row')
ylabel('APUSR3')



%COMBINED
APUSRCOM=APUSR1+APUSR2+APUSR3;



figure(4)
plot(row,APUSR1,'b*-',row,APUSR2,'r*-',row,APUSR3,'g*-',row,APUSRCOM,'k*-')
title('row vs APUSR')
xlabel('row')
ylabel('APUSR')

figure(5)
MAXCBR=1000;
CBR=linspace(1,1000);
CBRNOR=CBR./MAXCBR;


APUSRCB=APUSRCOM.*CBR;

APUSRMAX=max(APUSRCB);
YAPUSR=APUSRCB./APUSRMAX;
plot(CBRNOR,YAPUSR,'b*-')
title('CBR vs APUSR')
xlabel('CBR')
ylabel('APUSR')



