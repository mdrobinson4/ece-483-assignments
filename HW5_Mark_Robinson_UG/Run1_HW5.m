clear all;
close all;
clc;

rng(sum('MarkRobinson'))

load("264_optdigits.mat");

% split data between training and testing
[trainlabels,trainfeatures,testlabels,testfeatures] = splitData(class_label,data);
% grid search iteration count
n = 20;
% find the best cost and gamma values
[c,g,a,params] = gridSearch(trainlabels,trainfeatures,n);
% train the model using the best cost and gamma
model = train(trainlabels,trainfeatures,params);
% predict the number values
[predicted_label,cm] = predict(testlabels,testfeatures,model);
str = sprintf('Cost: %d, Gamma: %d, Acuraccy: %d',c,g,a);
disp(str);


% split data between training and testing
function [trainlabels,trainfeatures,testlabels,testfeatures] = splitData(class_label,data)
len = length(class_label);
%training data
trainlabels = class_label(1:len/2,:);
trainfeatures = data(1:len/2,:);
%testing data
testlabels = class_label(len/2+1:end,:);
testfeatures = data(len/2+1:end,:);
end

% perform grid search to get the best parameters
% try different cost and gamma values
function [cost,gamma,accuracy,params] = gridSearch(trainlabels, trainfeatures,n)
optimalParams = [0,0,0];
costArr = exp(linspace(-10.8198,35.2319,n));
gammaArr = exp(linspace(-33.8456,7.6009,n));
for cost = costArr
    for gamma = gammaArr
        params = sprintf('-s 0 -t 0 -c %d -v 4 -g %d -q', cost,gamma);
        currAcc = svmtrain(trainlabels, trainfeatures, params);
        if currAcc > optimalParams(3)
            optimalParams(1) = cost;
            optimalParams(2) = gamma;
            optimalParams(3) = currAcc;
        end
    end
end
accuracy = optimalParams(3);
cost = optimalParams(1);
gamma = optimalParams(2);
params = sprintf('-s 0 -t 0 -c %d -g %d -q', cost,gamma);
end
    
function model = train(trainlabels,trainfeatures,params)
model = svmtrain(trainlabels, trainfeatures, params);
end

%test model on new data
function [predicted_label,cm] = predict(testlabels,testfeatures,model)
[predicted_label] = svmpredict(testlabels,testfeatures,model);
%display confusion matrix
cm = confusionchart(testlabels, predicted_label);
end