xa=1; xb=4; ya=1; yb=2;         % coordinates of the rectangle C1

xa2=3; xb2=4; ya2=2; yb2=5;         % coordinates of the rectangle C2

hold on; plot([xa xb xb xa xa],[ya ya yb yb ya],'-');    % draw it

plot([xa2 xb2 xb2 xa2 xa2],[ya2 ya2 yb2 yb2 ya2],'-');    % draw it
% generate positive and negative examples
N=500;   % no of data points
ds=zeros(N,2); 


i=1;

while i<N

x=rand(1,1)*8; y=rand(1,1)*8;

% +ve if falls in the rectangle, -ve otherwise
if ((x > xa) && (y > ya) && (y < yb) && ( x < xb)) ds(i,1)=x; ds(i,2)=y; plot(x,y,'b+'); i=i+1;
elseif ((x > xa2) && (y > ya2) && (y < yb2) && ( x < xb2)) ls(i)=2; ds(i,1)=x; ds(i,2)=y; plot(x,y,'b+'); i=i+1;
end;  
end