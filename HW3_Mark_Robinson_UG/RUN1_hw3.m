clc; close all; clear all;

% coordinates of the rectangle C1
xa=2; xb=4; ya=1; yb=3;     
% coordinates of the rectangle C2
xa2=2; xb2=7; ya2=3; yb2=5;
hold on; 
% draw rectangle C1
plot([xa xb xb xa xa],[ya ya yb yb ya],'-');
% draw rectangle C2
plot([xa2 xb2 xb2 xa2 xa2],[ya2 ya2 yb2 yb2 ya2],'-');

% generate positive and negative examples
% no of data points
N=500;
% store coordinates for each point
ds=zeros(N,2); 
% store our labels
ls=zeros(N,1);

% create N random variables and generate population
for i=1:N

x=rand(1,1)*8; 
y=rand(1,1)*8;
ds(i,1)=x; 
ds(i,2)=y;
% +ve if falls in the rectangle, -ve otherwise
% within the bounds of rectangle 1
if ((x > xa) && (y > ya) && (y < yb) && ( x < xb)) 
    ls(i)=1;
    plot(x,y,'b+'); 
% within the bounds of rectangle 2
elseif ((x > xa2) && (y > ya2) && (y < yb2) && ( x < xb2)) 
    ls(i)=2; 
    plot(x,y,'k*');
% not within either rectangle (does not belong to a class)
else
    ls(i)=0;
    plot(x,y,'go'); 
end;
end;

hold off;
% get the indices for each class
i0 = find(ls==0);
i1 = find(ls==1);
i2 = find(ls==2);
% calculate the prior for each class: P(Ci)
prior0 = length(i0)/N;
prior1 = length(i1)/N;
prior2 = length(i2)/N;
% get the [x,y] coordinates for each point in the corresponding class
x0 = ds(i0,1);
y0 = ds(i0,2);
x1 = ds(i1,1);
y1 = ds(i1,2);
x2 = ds(i2,1);
y2 = ds(i2,2);
% calculate the mean of each class
m0 = mean([x0 y0]);
m1 = mean([x1 y1]);
m2 = mean([x2 y2]);
% calculate the covariance of each class
c0 = cov([x0 y0]);
c1 = cov([x1 y1]);
c2 = cov([x2 y2]);

figure(2)
hold on

% create new population. this time we will use multivarian distribution to
% figure out which class each point belongs to
for i=1:N
x=rand(1,1)*8; 
y=rand(1,1)*8;
% within the bounds of rectangle 1
if (mvnpdf([x y],m1,c1)*prior1 >= mvnpdf([x y],m2,c2)*prior2 && mvnpdf([x y],m1,c1)*prior1 >= mvnpdf([x y],m0,c0)*prior0)
    plot(x,y,'b+'); 
% within the bounds of rectangle 2
elseif (mvnpdf([x y],m2,c2)*prior2 >= mvnpdf([x y],m1,c1)*prior1 && mvnpdf([x y],m2,c2)*prior2 >= mvnpdf([x y],m0,c0)*prior0) 
    plot(x,y,'k*');
% not within either rectangle (does not belong to a class)
else
    plot(x,y,'go'); 
end;
end;

hold off