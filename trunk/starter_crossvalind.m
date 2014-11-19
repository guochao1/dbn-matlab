clc;
clear all
close all
for layer_sizes = 500:100:700
%% Initialization
    res_sum = 0;
    curr_res = 0;
    % test_array = [];
    for rounds = 1:10
%% Setting parameters        
        pretrain_maxepoch = 400;
    %     numhid=200; numpen=200; numpen2=200; 
         numhid=layer_sizes; numpen=layer_sizes; numpen2=layer_sizes; 
        finetuning_maxepoch = 100;
        conjugate_gradient_max_iter = 3;
%% Selecting dataset
        curr_set = strcat('/set',num2str(rounds, '%02i'));
        f_train0 = strcat('normalize_softmax',curr_set,'/train0');
        f_train1 = strcat('normalize_softmax',curr_set,'/train1');
        f_test0 =  strcat('normalize_softmax',curr_set,'/test0');
        f_test1 = strcat('normalize_softmax',curr_set,'/test1');

%% Running experiment
        fprintf(1,'Round:%i \n',rounds);
        classify;
        close all;
        clc; 
%% Storing result from individual run
        curr_res = 100*test_err(maxepoch)/(testnumcases*testnumbatches);
        res_sum = res_sum + curr_res;
    %     test_array = [ test_array curr_res];
    end

%% Calculating final result 
    res = res_sum/10;
    fprintf(1,'Result:%.2f %%\n',res);
%% Storing result
    fid = fopen('experiment_results.csv','a');
    format = '%d;%d;%d;%d;%d;%d;%.2f\n';
    fprintf(fid,format, pretrain_maxepoch, numhid, numpen, numpen2, finetuning_maxepoch, conjugate_gradient_max_iter, res );
    fclose(fid);
end
