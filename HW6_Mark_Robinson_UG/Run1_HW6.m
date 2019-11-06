clc; close all; clear all;

rng(sum('MarkRobinson'));

k = 20;  % number of mixtures
N=500;  % number of points
% generate points
[X,X1,X2] = generateData(N);
% calculate covariance of points
sigma1 = cov(X1);
sigma2 = cov(X2);
% calculate mean of points
mu1 = mean(X1,1);
mu2 = mean(X2,1);
% sum of square error
sse = zeros(k,1);
% use the elbow method to find the optimal number of mixtures
for i=1:1:k
    [sigma, mu] = gmme(X,X1,X2,i);  % estimate mean and covariance for data given mixture count
    ls = ap2m(X,mu,sigma,i,N);  % use mahalanobis distance to assign points to correct mixtures
    sse(i) = calcSSE(X,ls,mu,sigma);  % calculate the sum of square error for each mixture
end
% display the plot of the sum of square errors versus the number of clusters used
plotElbow(k,sse);
for i=[1 2 3 9]
    [sigma, mu] = gmme(X,X1,X2,i); % estimate mean and covariance for data given mixture count
    ls = ap2m(X,mu,sigma,i,N); % use mahalanobis distance to assign points to correct mixtures
    displayMixtures(X,ls,i); % display the mixtures
end

function [X,X1,X2] = generateData(N)
xa=1; xb=4; ya=1; yb=2;         % coordinates of the rectangle C1
xa2=3; xb2=4; ya2=2; yb2=5;     % coordinates of the rectangle C2
% generate positive and negative examples
i=1;
ds=zeros(N,2);
ls=zeros(N,1);
% organize the data into datasets
while i<N
    x=rand(1,1)*8; y=rand(1,1)*8;
    % store data into mixture 1
    if ((x > xa) && (y > ya) && (y < yb) && ( x < xb))
        ls(i)=1;
        ds(i,1)=x; 
        ds(i,2)=y; 
        i=i+1;
    % store points into mixture 2
    elseif ((x > xa2) && (y > ya2) && (y < yb2) && ( x < xb2)) 
        ls(i)=2; 
        ds(i,1)=x; 
        ds(i,2)=y;
        i=i+1; 
    end
end
ind1 = find(ls == 1);   % get the indices for all of the points that belong to cluster 1
ind2 = find(ls == 2);   % get the indices for all of the points that belong to cluster 2
X1 = ds(ind1,:);    % cluster 1 datapoints
X2 = ds(ind2,:);    % cluster 2 datapoints
X = [X1; X2];   %  combine cluster 1 and 2
end

% return the mahalanobis distance between point p and the cluster with mean
% mu and covariance sigma
function [d] = md(p,mu,sigma)
d = (p-mu)*(sigma^-1)*(p-mu)';  % return the mahalanobis distance between the point and the mean of the corresponding datatset
end


function [sigma, mu] = gmme(X,X1,X2,k)
% Set 'm' to the number of data points.
m = size(X, 1);
n = 2;  % The vector lengths.
% Randomly select k data points to serve as the initial means.
indeces = randperm(m);
mu = X(indeces(1:k), :);
sigma = [];
% Use the overal covariance of the dataset as the initial variance for each cluster.
for j=1:k
    sigma{j} = cov(X);
end
% Assign equal prior probabilities to each cluster.
phi = ones(1, k) * (1 / k);
% Matrix to hold the probability that each data point belongs to each cluster.
% One row per data point, one column per cluster.
W = zeros(m, k);
% Loop until convergence.
for (iter = 1:1000)
    % STEP 3a: Expectation
    % Calculate the probability for each data point for each distribution.
    % Matrix to hold the pdf value for each every data point for every cluster.
    % One row per data point, one column per cluster.
    pdf = zeros(m, k);
    % For each cluster...
    for j=1:k
        % Evaluate the Gaussian for all data points for cluster 'j'.
        pdf(:, j) = gaussianND(X, mu(j, :), sigma{j});
    end
    % Multiply each pdf value by the prior probability for cluster.
    pdf_w = bsxfun(@times, pdf, phi);
    
    % Divide the weighted probabilities by the sum of weighted probabilities for each cluster.
    %   sum(pdf_w, 2) -- sum over the clusters.
    W = bsxfun(@rdivide, pdf_w, sum(pdf_w, 2));
    % STEP 3b: Maximization
    % Calculate the probability for each data point for each distribution.
    % Store the previous means.
    prevMu = mu;    
    % For each of the clusters...
    for j = 1 : k
        % Calculate the prior probability for cluster 'j'.
        phi(j) = mean(W(:, j), 1);
        % Calculate the new mean for cluster 'j' by taking the weighted
        % average of all data points.
        mu(j, :) = weightedAverage(W(:, j), X);
        % Calculate the covariance matrix for cluster 'j' by taking the 
        % weighted average of the covariance for each training example. 
        sigma_k = zeros(n, n);
        % Subtract the cluster mean from all data points.
        Xm = bsxfun(@minus, X, mu(j, :));
        % Calculate the contribution of each training example to the covariance matrix.
        for (i = 1 : m)
            sigma_k = sigma_k + (W(i, j) .* (Xm(i, :)' * Xm(i, :)));
        end
        % Divide by the sum of weights.
        sigma{j} = sigma_k ./ sum(W(:, j));
    end
    % Check for convergence.
    if (mu == prevMu)
        break
    end         
% End of Expectation Maximization    
end
end

% assign points to mixtures
function [ls] = ap2m(X,mu,sigma,k,N)
ls=zeros(N,1);
d=zeros(k,1);
% loop through all of the points
for i=1:length(X)
    p = X(i,:);
    % loop through all of the mixtures
    for j=1:k
        % calculate the mahalanobis distance from each mixture
        d(j) = md(p,mu(j,:),sigma{j});
    end
    % assign the point to the nearest mixture
    [M,I] = min(d);
    ls(i) = I;
end
end

function [sse] = calcSSE(X,ls,mu,sigma)
sse=0;
for i=1:1:length(mu)
    x = X(find(ls==i),:);   % get points that belong to cluster
    for j=1:1:length(x)
        sse = sse + md(x(j,:),mu(i,:),sigma{i}); % calculate the sum of squarred error using the mahalanobis distance
    end
end
end

function plotElbow(k,sse)
figure(1)
plot(1:1:k,sse)
title('Elbow Method');
ylabel('Within Groups Sum of Squares');
xlabel('Number of Clusters');
end

function displayMixtures(X,ls,k)
style={'bo','k+','r*','g.','yx','cs','md','b.','k*','r.','gx','ys','cd','mo','b*'};
figure(k+1)
hold on;
for i=1:k
    x = X(find(ls==i),1);
    y = X(find(ls==i),2);
   plot(x,y,style{i});
   title("Expectation Maximization (" + k + " clusters)");
   xlabel('x')
   ylabel('y')
end
hold off;
end

