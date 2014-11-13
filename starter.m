clc;
clear all
close all
for layer_sizes = 500:100:700

res_sum = 0;
for rounds = 1:10
    pretrain_maxepoch = 400;
%     numhid=200; numpen=200; numpen2=200; 
     numhid=layer_sizes; numpen=layer_sizes; numpen2=layer_sizes; 

    finetuning_maxepoch = 100;
    conjugate_gradient_max_iter = 3;

    curr_set = strcat('/set',num2str(rounds, '%02i'));
    f_train0 = strcat('normalize_softmax',curr_set,'/train0');
    f_train1 = strcat('normalize_softmax',curr_set,'/train1');
    f_test0 =  strcat('normalize_softmax',curr_set,'/test0');
    f_test1 = strcat('normalize_softmax',curr_set,'/test1');

    fprintf(1,'Round:%i \n',rounds);

    classify;
    close all;
    clc;     
    res_sum = res_sum + (100*test_err(maxepoch)/(numcases*numbatches));
end

res = res_sum/10;
fprintf(1,'Result:%.2f %%\n',res);

fid = fopen('experiment_results.csv','a');
format = '%d;%d;%d;%d;%d;%d;%.2f\n';
fprintf(fid,format, pretrain_maxepoch, numhid, numpen, numpen2, finetuning_maxepoch, conjugate_gradient_max_iter, res );

fclose(fid);
end
