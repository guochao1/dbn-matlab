% Version 1.000
%
% Code provided by Ruslan Salakhutdinov and Geoff Hinton
%
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our
% web page.
% The programs and documents are distributed without any warranty, express or
% implied.  As the programs were written for research purposes only, they have
% not been tested to the degree that would be advisable in any important
% application.  All use of these programs is entirely at the user's own risk.

% This program reads raw MNIST files available at 
% http://yann.lecun.com/exdb/mnist/ 
% and converts them to files in matlab format 
% Before using this program you first need to download files:
% train-images-idx3-ubyte.gz train-labels-idx1-ubyte.gz 
% t10k-images-idx3-ubyte.gz t10k-labels-idx1-ubyte.gz
% and gunzip them. You need to allocate some space for this.  

% This program was originally written by Yee Whye Teh 

%% Read target data
fid = fopen('../../plak_target.txt', 'r');
t = cell2mat( textscan(fid,'%d') );
fclose(fid);
idx = find(t~=-1); % skip patterns without target
t = t(idx);

%% Read input data
load('../../final_data.mat');
n = size(final_data,2);
x = final_data(idx,:);
% Normalize by dividing with softmax of each column
for col=1:n
    mu = mean(x(:,col));
    sigma = std(x(:,col));
    x(:,col) = 1 ./ (1 + exp(-(x(:,col)-mu)/sigma));
end
P = size(x,1);
P = floor(P/100)*100;
t = t(1:P);
x = x(1:P,:);

%%
[trainidx, testidx] = crossvalind('LeaveMOut', P, 400);

% Save data to files
Xtrain = x(trainidx, :);
Ttrain = t(trainidx, :);
Xtest = x(testidx, :);
Ttest = t(testidx, :);

D = Xtrain(Ttrain==0, :);
save('train0.mat', 'D');
D = Xtrain(Ttrain==1, :);
save('train1.mat', 'D');
D = Xtest(Ttest==0, :);
save('test0.mat', 'D');
D = Xtest(Ttest==1, :);
save('test1.mat', 'D');
