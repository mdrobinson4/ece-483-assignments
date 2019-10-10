clear all;
close all;
load YaleB_32x32.mat

h=32;w=32;
x = double(fea)';
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
figure,subplot(4,4,1)
imagesc(reshape(mean_matrix, [h,w]))
colormap gray
for i = 1:15
    subplot(4,4,i+1)
    imagesc(reshape(V(:,i),h,w))
end