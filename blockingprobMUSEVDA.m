clc;
clear all;
close all;

% BLOCKING PROBABILITY-  MUSE VDA



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


plot(row,Pb1,'r*-',row,Pb2,'g*-',row,Pb3,'b*-')
title('TRAFFIC LOAD Vs BLOCKING PROBABILITY-MUSE VDA')
xlabel('Traffic Load (row)')
ylabel('Blocking Probability')
grid on
gtext({'Network1-Red'})
gtext({'Network2-Green'})
gtext({'Network3-Blue'})








