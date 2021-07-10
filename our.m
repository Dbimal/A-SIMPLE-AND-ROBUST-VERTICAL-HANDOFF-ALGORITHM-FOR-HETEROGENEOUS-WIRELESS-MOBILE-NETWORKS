clc;
clear all;
axis([-1 1 0 1])
x= -1:0.1:1
y= [0.9 0.89 0.89 0.89 0.88 0.87 0.87 0.79 0.74 0.60 0.55 0.45 0.35 0.25 0.24 0.01 0.009 0.004 0.003 0.002 0.001]
plot(x,y,'-..r');
hold on
y= [0.59 0.591 0.592 0.593 0.594 0.595 0.596 0.597 0.6 0.598 0.62 0.29 0.095 0.085 0.075 0.065 0.055 0.045 0.035 0.025 0.015]
plot(x,y,'-..b');
hold on
y= [0.92 0.92 0.92 0.92 0.92 0.92 0.92 0.92 0.92 0.91 0.62 0.29 0.085 0.075 0.065 0.055 0.045 0.035 0.025 0.015 0.005]
plot(x,y,'-..g');
hold on
xlabel('p * 10 ----->');
ylabel('Average Percenatge of User Satisfied Outputs(APUSR)----->');
title('Average Percenatge of User Satisfied Outputs(APUSR)');
legend('RSS','RSS + mobility','MUSE-VDA');