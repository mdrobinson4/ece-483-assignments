close all; clear all;
t = linspace(0, 2*pi);
y1 = sin(t);
plot(t, y1)

hold on
y2 = cos(t);
plot(t, y2, '--r') 
xlabel('Time (s)')
ylabel('Function value')
title('Sin and Cos functions')
legend({'Sin', 'Cos'})
xlim([0 2*pi])
ylim([-1.4 1.4])