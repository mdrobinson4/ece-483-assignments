% 1) Semilog plot
x = 0:4;
y = [15 25 55 115 144];

figure
semilogy(x, y, 'ms', 'MarkerSize', 10, 'LineWidth', 4)
xlim([0 4])
xlabel('Year')
ylabel('Number of Students In 6.094')
title('Semilog Plot Of The Class Size Of 6.094 Over 4 Years')

% 3) Bar Graph
r = randi(10,1,5);

bar(r, 'r')

% 4) Interpolation and Surface Plots
Z0 = rand(5,5);
[X0, Y0] = meshgrid(1:5, 1:5);
[X1, Y1] = meshgrid(1:.1:5, 1:.1:5);
Z1 = interp2(X0, Y0, Z0, X1, Y1, 'cubic');
surf(Z1);
colormap('hsv')
shading interp

hold on
contour(Z1);
colorbar
caxis([0 1])


