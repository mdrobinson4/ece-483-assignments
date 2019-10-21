clear all;
close all;

load("264_optdigits.mat");
data = double(data);
class_label = double(class_label);
len = length(class_label);

%training data
trainlabels = class_label(1:len/2,:);
trainfeatures = data(1:len/2,:);
%testing data
testlabels = class_label(len/2+1:end,:);
testfeatures = data(len/2+1:end,:);

% get the best parameters (
max = [0,0,0];
for c = linspace(2*10^-5,2*10^15,4)
    for g = linspace(2*10^-15,2*10^3,4)
        params = sprintf('-s 0 -t 0 -c %d -v 4 -g %d -q', c,g);
        curr = svmtrain(trainlabels, trainfeatures, params);
        if curr > max(3)
            max(1) = c;
            max(2) = g;
            max(3) = curr;
        end
    end
end

accuracy = max(3);
c = max(1);
g = max(2);
    
params = sprintf('-s 0 -t 0 -c %d -g %d -q', c,g);
model = svmtrain(trainlabels, trainfeatures, params);

%test model on new data
[predicted_label] = svmpredict(testlabels,testfeatures,model);
%display confusion matrix
cm = confusionchart(testlabels, predicted_label);