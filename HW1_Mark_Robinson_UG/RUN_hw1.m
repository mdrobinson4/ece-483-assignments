close all; clear all;

% 1) Scalar variables
a = 10
b = 2.5e23
c = 2 + 3i
d = exp((2i*pi)/3)

w = waitforbuttonpress;


% 2) Vector Variables
aVec = [3.14, 15, 9, 26]
bVec = [2.71 ; 8 ; 28 ; 182]
cVec = 5:-0.2:-5
dVec = logspace(0, 1)
eVec = "Hello"

w = waitforbuttonpress;

% 3) Matrix Variables
aMat = ones(9).*2
bMat = diag([1 2 3 4 5 4 3 2 1])
cMat = reshape(1:100, [10,10])
dMat = NaN([3,4])
eMat = [ 13 -1 5 ; -22 10 -87]
fMat = randi([-3 3],5,3)

w = waitforbuttonpress;

% 4) Scalar Equations
x = 1 / (1 + exp(-(a-15)/6))
y = (sqrt(a) + b^(1/21))^pi
z = log(real((c+d)*(c-d))*sin((a*pi)/3)) / (c*conj(c))

w = waitforbuttonpress;

% 5) Vector Equations
xVec = (exp(-cVec.^2)./(2*2.5^2)) ./ sqrt(2*pi*2.5^2)
yVec = sqrt(((aVec.').^2) + bVec.^2)
zVec = log10(1 ./ dVec)

w = waitforbuttonpress;

% 6) Matrix Equations
xMat = (aVec*bVec)*(aMat.^2)
yVec = bVec*aVec
zMat = det(cMat)*(aMat*bMat).'

w = waitforbuttonpress;

% 7) Common Functions and Indexing
cSum = sum(cMat)
eMean = mean(eMat)
eMat(1) = 1;
eMat(3) = 1;
eMat(5) = 1;
eMat
cSub = cMat(2:9, 2:9)

lin = 1:20;
for x = lin
    if mod(x,2) == 0
        lin(x) = -1 * lin(x);
    end
end
lin

r = rand([1,5]);
index = find(r < 0.5);
for i = index
    r(i) = 0;
end
r

w = waitforbuttonpress;

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

w = waitforbuttonpress;

load('classGrades.mat');
namesAndGrades(1:5, 1:size(namesAndGrades,2))
grades = namesAndGrades(1:15, 2:size(namesAndGrades,2));
meanGrades = mean(grades)
meanGrades = nanmean(grades)


meanMatrix = ones(15, 1)*meanGrades
curvedGrades = 3.5*(grades ./ meanMatrix);
nanmean(curvedGrades)

indices = find(curvedGrades > 5);
curvedGrades(indices) = 5;


totalGrade = ceil(nanmean(curvedGrades, 2));

letters = ['F' 'D' 'C' 'B' 'A'];
letterGrades = blanks(15);
disp(['Grades: ', letters(totalGrade)]);

w = waitforbuttonpress;

% 1) Semilog plot
x = 0:4;
y = [15 25 55 115 144];

figure
semilogy(x, y, 'ms', 'MarkerSize', 10, 'LineWidth', 4)
xlim([0 4])
xlabel('Year')
ylabel('Number of Students In 6.094')
title('Semilog Plot Of The Class Size Of 6.094 Over 4 Years')

w = waitforbuttonpress;

% 3) Bar Graph
r = randi(10,1,5);
bar(r, 'r')

w = waitforbuttonpress;

% 4) Interpolation and Surface Plots
Z0 = rand(5,5);
[X0, Y0] = meshgrid(1:5, 1:5);
[X1, Y1] = meshgrid(1:.1:5, 1:.1:5);
Z1 = interp2(X0, Y0, Z0, X1, Y1, 'cubic');
surf(X1,Y1,Z1);
colormap('hsv')
shading interp

hold on
contour(X1, Y1, Z1);
colorbar
caxis([0 1])