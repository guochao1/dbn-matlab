%% clearing workspace
clc;
clear all
close all

%% Setting parameters
pretrain_maxepoch = 400;
layer_sizes = 200;
numhid=layer_sizes; numpen=layer_sizes; numpen2=layer_sizes; 
finetuning_maxepoch = 100;
conjugate_gradient_max_iter = 3;

%% Specifying dataset
curr_set = '/set01';
f_train0 = strcat('normalize_softmax',curr_set,'/train0');
f_train1 = strcat('normalize_softmax',curr_set,'/train1');
f_test0 =  strcat('normalize_softmax',curr_set,'/test0');
f_test1 = strcat('normalize_softmax',curr_set,'/test1');

%% Running the experiment
classify;
  
%% Showing results
res = 100*test_err(maxepoch)/(testnumcases*testnumbatches);
fprintf(1,'Result:%.2f %%\n',res);

%% Storing to ofile
% fid = fopen('experiment_results.csv','a');
% format = '%d;%d;%d;%d;%d;%d;%.2f\n';
% fprintf(fid,format, pretrain_maxepoch, numhid, numpen, numpen2, finetuning_maxepoch, conjugate_gradient_max_iter, res );
% fclose(fid);


