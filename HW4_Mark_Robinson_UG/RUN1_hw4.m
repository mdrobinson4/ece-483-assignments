clear all;
close all;

load("264_optdigits.mat");

plotRecErr(data)
disp('Press Any Key To Continue')
w = waitforbuttonpress;
plotEval(data)
disp('Press Any Key To Continue')
w = waitforbuttonpress;
plotPCA(data, class_label)
disp('Press Any Key To Continue')
w = waitforbuttonpress;
eigenfaces(data, class_label)

function plotRecErr(data)
n = 20;
err = zeros(1,n);
for d=1:n
    [xd, xx, xxmse, vv, ll, b] = pca(data,d);
    err(d) = xxmse;
end
figure(1)
plot(err,1:n)
title('Reconstruction Error Vs. PCA Count')
xlabel('Reconstruction Error');
ylabel('Eigenvectors')
end

function plotEval(data)
d = 64;
[xd, xx, xxmse, evec, eval, b] = pca(data,d);
eval = sort(eval, 'descend');
eigsum = sum(eval);
csum = 0;
pov = zeros(1,d);
for k=1:d
    csum = csum + eval(k);
    pov(k) = csum / eigsum;
end

figure(2)
plot(1:d,pov)
title('Proportion Of Variance Vs. Eigenvector')
ylabel('Prop. of var.')
xlabel('Eigenvectors')
end

function plotPCA(data, class_label)
d = 4;
[xd, xx, xxmse, vv, ll, b] = pca(data,d);

figure(3)
scatter3(xd(:,1),xd(:,2),xd(:,3),10,class_label)
title('Opdigits after PCA')
xlabel('First Eigenvector')
ylabel('Second Eigenvector')
zlabel('Third Eigenvector')
end

function eigenfaces(data, class_label)
h=8;w=8;
x = double(data)';
%subtract mean
mean_matrix = mean(x,2);
x = bsxfun(@minus, x, mean_matrix);
% calculate covariance
s = cov(x');
% obtain eigenvalue & eigenvector
[V,D] = eig(s);
eigval = diag(D);
% sort eigenvalues in descending order
eigval = eigval(end:-1:1);
V = fliplr(V);
% show mean and 1th through 15th principal eigenvectors
figure(4)
imagesc(reshape(mean_matrix, [h,w]))
title('Mean of Eigendigits')
colormap gray
figure(5)
sgtitle('First 8 Principle Components')
colormap gray
for i = 1:18
    subplot(3,6,i)
    imagesc(reshape(V(:,i),h,w))
end
end