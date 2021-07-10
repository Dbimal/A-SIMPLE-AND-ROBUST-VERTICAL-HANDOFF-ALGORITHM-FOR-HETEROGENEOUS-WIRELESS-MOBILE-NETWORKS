clc;
clear all;
axis([-1 1 0 0.9])
x= -1:0.1:1
y= [0 0 0 0 0 0 0 0 0 0 0 0 0 0.05 0.1 0.15 0.25 0.4 0.55 0.65 0.72]
plot(x,y,'-..r');
hold on
y1=[0 0 0 0 0 0 0 0 0 0 0 0 0.05 0.1 0.15 0.23 0.3 0.47 0.6 0.67 0.72]
plot(x,y1,'-..b');
hold on
y2= [0 0 0 0 0 0 0 0 0 0 0 0.05 0.1 0.2 0.3 0.4 0.5 0.65 0.75 0.85 0.9]
plot(x,y2,'-..g');
hold on
xlabel('p(row)----->');
ylabel('Blocking Probabilities');
title('Blocking Probabilities');
legend('Network 1 ','Network 2','Netwrok 3');