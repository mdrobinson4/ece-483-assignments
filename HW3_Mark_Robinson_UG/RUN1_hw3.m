clc; close all;
% set random seed
rng(sum('MarkRobinson'));
% coordinates of the rectangle C1
xa=2; xb=4; ya=1; yb=3;     
% coordinates of the rectangle C2
xa2=2; xb2=7; ya2=3; yb2=5;

models = {'Arbitrary Covariance','Shared Covariance','Diagonal Covariance','Equal Variance'};

% vary the number of datapoints in the training set
q = linspace(100,2000,4);
% matrix to hold error for every complexity for each point count
totalError = zeros(length(q),length(models));

for cnt = 1:length(q)
    % generate positive and negative examples
    % no of data points
    N=floor(q(cnt));
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
        % within the bounds of rectangle 2
        elseif ((x > xa2) && (y > ya2) && (y < yb2) && ( x < xb2)) 
            ls(i)=2; 
        % not within either rectangle (does not belong to a class)
        else
            ls(i)=0;
        end
    end

    % get points that belong to class 1 and 2
    [pts1,pts2] = getPts(ls,ds);
    % get mean and covariance for class 1 and 2
    [mean1,mean2,cov1,cov2,sharedCov] = getParams(pts1,pts2);
    % generate new values for validation (testing) dataset
    x=rand(N,1)*8; 
    y=rand(N,1)*8;
    % vector to hold predicted class for each complexity
    prediction=zeros(N,4);
    % vector to hold actual class for point
    actual = zeros(N,1);
    % vector to hold error for each complexity
    error=zeros(N,4);
    % vector to hold false negative results for each point given each complexity
    fn = zeros(1,4);
    % vector to hold false positive results for each point given each complexity
    fp = zeros(1,4);

    % loop through the testing set and classify points
    for i=1:N
        % get the predicted class for the point
        [prediction] = getPrediction(x(i),y(i),mean1,mean2,cov1,cov2,sharedCov,prediction,i);
        % get the actual class for the point
        [actual(i)] = actualClass(x(i),y(i));
        % get the error 
        [fn,fp] = getErr(prediction(i,:),actual(i),fn,fp);
    end

    % display the error rates and predicted classes
    fprintf('Error Rates: (%d data points)\n',N);
    figure(cnt)
    
    % loop through each complexity
    for i=1:length(models)
        totalError(cnt,i) = (fn(i)+fp(i))/N;
        % display error rates for each complexity
        fprintf('%s: %.4f\n', string(models(i)),100*(fn(i)+fp(i))/N);

        % show points
        subplot(2,2,i)
        hold on

        title(string(models(i)));
        xlabel('x');
        ylabel('y');

        % draw boundaries
        plot([xa xb xb xa xa],[ya ya yb yb ya],'-');
        plot([xa2 xb2 xb2 xa2 xa2],[ya2 ya2 yb2 yb2 ya2],'-');

        % plot points
        for j=1:N
           if(prediction(j,i)==1)
               plot(x(j),y(j),'b+')
           else
               plot(x(j),y(j),'k*')
           end
        end
        hold off
    end
    sgtitle("Multivariant Classification: (" + N + ") datapoints");
    fprintf('\n')
end
 plotErr(totalError,models,q)
 

function [pts1,pts2] = getPts(ls,ds)
% get the indices for each class
i1 = find(ls==1);
i2 = find(ls==2);
% get the coordinates for each point in class 1
x1 = ds(i1,1);
y1 = ds(i1,2);
pts1 = [x1,y1];
% get the coordinates for each point in class 2
x2 = ds(i2,1);
y2 = ds(i2,2);
pts2 = [x2,y2];
end

function [mean1,mean2,cov1,cov2,sharedCov] = getParams(pts1,pts2)
mean1 = mean(pts1);
mean2 = mean(pts2);
cov1 = cov(pts1);
cov2 = cov(pts2);
x = [pts1(:,1);pts2(:,1)];
y = [pts1(:,2);pts2(:,2)];
pts = [x y];
sharedCov = cov(pts);
end

function [prediction] = getPrediction(x,y,mean1,mean2,cov1,cov2,sharedCov,prediction,i)
% Arbitrary Covariance
if mvnpdf([x y],mean1,cov1) > mvnpdf([x y],mean2,cov2)
    prediction(i,1) = 1;
else
    prediction(i,1) = 2;
end
% Shared Covariance
if mvnpdf([x y],mean1,sharedCov) > mvnpdf([x y],mean2,sharedCov)
    prediction(i,2) = 1;
else
    prediction(i,2) = 2;
end
% Diagonal Covariance -> covariance (off-diagonals equal)
covMean = mean([sharedCov(1,2),sharedCov(2,1)]);
sharedCov(1,2) = covMean;
sharedCov(2,1) = covMean;
if mvnpdf([x y],mean1,sharedCov) > mvnpdf([x y],mean2,sharedCov)
    prediction(i,3) = 1;
else
    prediction(i,3) = 2;
end
% Equal Variance
varMean = mean([sharedCov(1,1),sharedCov(2,2)]);
sharedCov(1,1) = varMean;
sharedCov(2,2) = varMean;
if mvnpdf([x y],mean1,sharedCov) > mvnpdf([x y],mean2,sharedCov)
    prediction(i,4) = 1;
else
    prediction(i,4) = 2;
end
end

function [actual] = actualClass(x,y)
actual = 0;
xa=2; xb=4; ya=1; yb=3;     
% coordinates of the rectangle C2
xa2=2; xb2=7; ya2=3; yb2=5;

% withing the bounds of rectange 1
if ((x > xa) && (y > ya) && (y < yb) && ( x < xb)) 
    actual = 1; 
% within the bounds of rectangle 2
elseif ((x > xa2) && (y > ya2) && (y < yb2) && ( x < xb2)) 
    actual = 2;
end
end

function [fn,fp] = getErr(pred,act,fn,fp)
for i=1:4
    % false negative
    if ((pred(i)==1 && act==2) || (pred(i)==1 && act==0))
        fn(1,i) = fn(1,i)+1;
    % false positive
    elseif ((pred(i)==2 && act==1) || (pred(i)==2 && act==0))
        fp(1,i) = fp(1,i)+1;
    end
end
end

function plotErr(totalError,models,q)
figure(5)
hold on
for i=1:length(models)
   subplot(2,2,i);
   plot(q,totalError(:,i))
   title(string(models(i)));
   xlabel('Data Points');
   ylabel('Error');
end
hold off
end