clc; close all; clear all;
load("hmm.mat");

addpath(genpath('./HMMall')) 

% learn parameters
[q1, prior1, transmat1, obsmat1, llVal1, LL1, loglik1] = estParams(data1, 3);
[q2, prior2, transmat2, obsmat2, llVal2, LL2, loglik2] = estParams(data2, 3);

% classify sequences
X = [X1 ; X2 ; X3 ; X4 ; X5 ; X6];
[class, classProb] = classify(X, prior1, prior2, transmat1, transmat2, obsmat1, obsmat2);


clc; % clear the training details
% show the results
hold on;
displayResults(1, LL1, llVal1, q1, prior1, obsmat1, transmat1, loglik1);
displayResults(2, LL2, llVal2, q2, prior2, obsmat2, transmat2, loglik2);
sgtitle('Logarithmic Likelihood of Sequence');
hold off;

classResults(class, classProb);

function classResults(class, classProb)
fprintf('----------------------------------------------\n');
fprintf('|          Classification Results            |\n');
fprintf('----------------------------------------------\n');
%fprintf('\n------------------------------------------------------\n\n');
for j=1:1:6
    fprintf('Process %d generated sequence X%d\n', class(j), j);
    fprintf('Logarithmic likelihood: %f\n\n\n', classProb(j));
end
%fprintf('------------------------------------------------------\n\n');
end

function displayResults(j, ll, llVal, q, prior, obsmat, transmat, loglik)  
subplot(1,2,j);
plot(1:1:length(loglik), loglik);
str = sprintf('Process: %d', j);
title(str)
ylabel('Log Likelihood')
xlabel('Number of states')
fprintf('---------------------------------\n');
fprintf('|          Process: %d            |\n', j);
fprintf('---------------------------------\n');
fprintf('States: %d\nObservations: %d\n',q,3);
fprintf('Initial State Probabilites:\n');
prior
fprintf('Observation Probabilies:\n');
obsmat
fprintf('Transition Probablities:\n');
transmat
fprintf('Logarithmic Likelihood: %f\n', llVal);
fprintf('\n\n\n');
end



function [stateCount, prior, transmat, obsmat, llVal, LL, loglik] = estParams(data, obCount)
prior = {};
transmat = {};
obsmat = {};
loglik = [];
LL = {};

for q=1:1:40
    rng(sum('MarkRobinson'), 'twister');
    prior{q} = normalise(rand(q,1));
    transmat{q} = mk_stochastic(rand(q,q));
    obsmat{q} = mk_stochastic(rand(q,obCount));
    [LL{q}, prior{q}, transmat{q}, obsmat{q}] = dhmm_em(data, prior{q}, transmat{q}, obsmat{q}, 'max_iter', 100);
    loglik(q) = dhmm_logprob(data, prior{q}, transmat{q}, obsmat{q});
end
[llVal, I] = max(loglik);
prior = prior{I};
transmat = transmat{I};
obsmat = obsmat{I};
stateCount = I;
LL = LL{q};
end

function [class, classProb] = classify(X, prior1, prior2, transmat1, transmat2, obsmat1, obsmat2)
class = zeros(1,6);
classProb = zeros(1,6);
for i=1:1:6
    x = X(i,:);
    loglik1 = dhmm_logprob(x, prior1, transmat1, obsmat1);
    loglik2 = dhmm_logprob(x, prior2, transmat2, obsmat2);
    if loglik1 >= loglik2
        class(i) = 1;
        classProb(i) = loglik1;
    else
        class(i) = 2;
        classProb(i) = loglik2;
    end
end
end
