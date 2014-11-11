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

% f_train0 = 'normalize_softmax/train0';
% f_train1 = 'normalize_softmax/train1';
% f_test0 =  'normalize_softmax/test0' ;
% f_test1 = 'normalize_softmax/test1';

traindata=[]; 
targets=[]; 
load(f_train0);
traindata = [traindata; D]; targets = [targets; repmat([1 0], size(D,1), 1)];  
load(f_train1);
traindata = [traindata; D]; targets = [targets; repmat([0 1], size(D,1), 1)];

totnum=size(traindata,1);
fprintf(1, 'Size of the training dataset= %5d \n', totnum);

rand('state',0); %so we know the permutation of the training data
randomorder=randperm(totnum);

numbatches = ceil(totnum/100);
numdims  =  size(traindata,2);
batchsize = 100;
batchdata = zeros(batchsize, numdims, numbatches);
batchtargets = zeros(batchsize, 2, numbatches);

for b=1:numbatches
  batchdata(:,:,b) = traindata(randomorder(1+(b-1)*batchsize:b*batchsize), :);
  batchtargets(:,:,b) = targets(randomorder(1+(b-1)*batchsize:b*batchsize), :);
end;
clear traindata targets;

testdata=[];
targets=[];
load(f_test0);
testdata = [testdata; D]; targets = [targets; repmat([1 0], size(D,1), 1)]; 
load(f_test1);
testdata = [testdata; D]; targets = [targets; repmat([0 1], size(D,1), 1)]; 

totnum=size(testdata,1);
fprintf(1, 'Size of the test dataset= %5d \n', totnum);

rand('state',0); %so we know the permutation of the training data
randomorder=randperm(totnum);

numbatches = ceil(totnum/100);
numdims  =  size(testdata,2);
batchsize = 100;
testbatchdata = zeros(batchsize, numdims, numbatches);
testbatchtargets = zeros(batchsize, 2, numbatches);

for b=1:numbatches
  testbatchdata(:,:,b) = testdata(randomorder(1+(b-1)*batchsize:b*batchsize), :);
  testbatchtargets(:,:,b) = targets(randomorder(1+(b-1)*batchsize:b*batchsize), :);
end;
clear testdata targets;


%%% Reset random seeds 
rand('state',sum(100*clock)); 
randn('state',sum(100*clock)); 



