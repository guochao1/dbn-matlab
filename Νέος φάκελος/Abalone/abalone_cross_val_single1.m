%% TRAINING MLP WITH BACK-PROPAGATION
clear; clc; close all;
time_stamp = datestr(now, 'yyyy-mm-dd-tHHMMSS');
threshold_target=1;
%% LOAD DATA AND PREPROCESS
% Read-in, the ABALONE dataset
fid = fopen('abalone.org.csv','r');
Data = textscan(fid, '%f,%f,%f,%f,%f,%f,%f,%f,%f');
fclose(fid);
n = 8;    % number of pattern dimensions
for i=1:n
 X(i,:) = double(Data{i}(:))';
%X(i,:) = Data{i}(:);
end
P = size(X,2);  % number of patterns
% Form the target vector for "a range" of rings number vs. the rest, having the sigmoid function in mind
for i=1:P
    if (Data{9}(i)>=8 && Data{9}(i)<13) %define the range
   %if (Data{9}(i)==10)
    t(i) = 1*threshold_target;
   else
    t(i) = -1*threshold_target;
   end 
end

%%CROSSVALIDATION
  % Cross-validation
     hold_out=0.2;
    [trainidx, testidx] = crossvalind('HoldOut', P, hold_out);
    % train set:
    xtrain = X(:,trainidx); %train set(data)
    ttrain = t(trainidx); %train set (targets)
    % test set:
    xtest = X(:,testidx); %test set (data)
    ttest = t(testidx); %test set (targets)
    % Πλήθος προτύπων train
    Ptrain = sum(trainidx);
    % Πλήθος προτύπων test
    Ptest = sum(testidx);

% Define structure of MLP
%numHidden = input('Δώσε πλήθος κρυφών νευρώνων --> ');
numHidden=110;

%% MODELS (select model)
% Define structure of MLP
%net = newff(P,T,S,TF,BTF,BLF,PF,IPF,OPF,DDF)

%Gradient descent with momentum
%net = newff(xtrain,ttrain,numHidden,{'tansig','tansig'},'traingdm');

%Conjugate gradient backpropagation with Powell-Beale restarts 
%net = newff(xtrain,ttrain,numHidden,{'tansig','tansig'},'traincgb');

%Conjugate gradient backpropagation with Polak-Ribi?re updates 
% net = newff(xtrain,ttrain,numHidden,{'tansig','tansig'},'traincgp');

% *** Conjugate gradient backpropagation with Fletcher-Reeves updates  *** 
 %net = newff(xtrain,ttrain,numHidden,{'tansig','tansig'},'traincgf');

%Levenberg-Marquardt model
net = newff(xtrain,ttrain,numHidden,{'tansig','tansig'},'trainlm');

%% Train MLP
% Training parameters
net.trainParam.mc = 0.01;
net.trainParam.epochs = 50;
net.trainParam.goal = 0.01;
net.trainParam.max_fail=1005;
%Go train the network
[net2,tr] = train(net,xtrain,ttrain);

%% PLOTS
title_general=['Cross Validation HoldOut: ' num2str(hold_out) char(10) 'Time stamp: ' time_stamp  char(10)];
title_general=[title_general 'Hidden neurons: ' num2str(numHidden) ' - Epochs: ' num2str(net.trainParam.epochs) ' - Training Function: ' tr.trainFcn ];

figure(1)
grid on;
grid minor;
hold on;

plot(tr.epoch, tr.perf, 'b', 'LineWidth', 2);
hold on;
plot(tr.epoch, tr.vperf, 'g', 'LineWidth', 2);
plot(tr.epoch, tr.tperf, 'r', 'LineWidth', 2);
hold off
legend('Training MSE','Validation MSE', 'Test MSE');
xlabel('Εποχή Εκπαίδευσης', ...
    'FontSize', 14);
ylabel('Σφάλμα - MSE (απόκλιση από το στόχο)', ...
    'FontSize', 14);
title(['ΕΚΠΑΙΔΕΥΣΗ MLP με "BACK PROPAGATION"' char(10) title_general], ...
    'FontSize', 10);


%% ΑΝΑΚΛΙΣΗ
%%SIMULATE AGAINST THE TEST SET
Y = sim(net2,xtest); % test the network using the test set data
% Y is the neuron's output. Make Y crisp and compare with the target
 %Characherize the output of the net ("Y")
  %if "Y > threshold_crispness" it is correctly clasified
  decision=(2*(Y>0)-1)*threshold_target; % 1 if correctly classified, 0 if not
  classified_OK=sum(decision==ttest);
  classidied_TESTED=Ptest;
  classified_RATIO=classified_OK./Ptest; % echo this in the command window

 %%SIMULATE AGAINST THE TRAIN SET
 Y_tr = sim(net2,xtrain); % test the network using the test set data
  % Y is the neuron's output. Make Y crisp and compare with the target
  
  %Characherize the output of the net ("Y_tr")
  %if "Y_tr > threshold_crispness" it is correctly clasified
  decision_tr=(2*(Y_tr>0)-1)* threshold_target; % 1 if correctly classified, 0 if not
  classified_OK_tr=sum(decision_tr==ttrain);
  classidied_TESTED_tr=Ptrain;
  classified_RATIO_tr=classified_OK_tr./Ptrain; % echo this in the command window

  
%% CONFUSION MATRIX ON THE TEST SET
 decision_c=((Y>0)); %same as "decision" but adjusted to 0/1 
 ttest_c=(ttest>0); %same as "ttest" but adjusted to 0/1
 %visualize the confusion matrix
 plotconfusion(ttest_c,decision_c); 
 %return the data of the confusion matrix  [targets(ttests_c) vs outputs(decision_c)]
 [c_miss,c_mat,c_indices,c_percents]=confusion(ttest_c,decision_c);
 
 %TP+TN  equals "classified_OK=sum(decision==ttest)";
 %FP+TP (predicted as 1): sum(decision==1)
 %TP+FN (all the true 1): equals "sum(ttest==1)"

 
%  TP=c_mat(2,2); %TRUE POSITIVE predicted as 1 and are truly 1
%  TN=c_mat(1,1); %TRUE NEGATIVE predicted as 0 and are truly 0
%  FP=c_mat(1,2); %FALSE POSITIVE predicted as 1 and are truly 0
%  FN=c_mat(2,1); %FALSE NEGATIVE predicted as 0 and are truly 1
 
 TP=c_mat(1,1); %TRUE POSITIVE predicted as 1 and are truly 1
  TN=c_mat(2,2); %TRUE NEGATIVE predicted as 0 and are truly 0
  FP=c_mat(2,1); %FALSE POSITIVE predicted as 1 and are truly 0
  FN=c_mat(1,2); %FALSE NEGATIVE predicted as 0 and are truly 1
 
 
 precision=TP./(TP+FP); %(predicted as 1 and are truly 1):
 recall=TP./(TP+FN); % (predicted as 1 from the total truly 1)
% classified_RATIO + c_miss; %equals 1
 

%% PLOT THE RESULTS FOR THE TEST SET 
figure(2)
plot(1:Ptest,Y,'r.', ...
    'MarkerSize', 5);
hold on
grid on
plot(1:Ptest,0,'b.', ...
   'MarkerSize', 5);
hold off
legend('outputs','decision level for classification','Location','SO');
xlabel('α/α προτύπων', ...
    'FontSize', 14);
ylabel('Ανάκληση (έξοδος):  Y = sim(net2,xtest)', ...
    'FontSize', 14);
plot_title=['ΑΝΑΚΛΗΣΗ ΣΤΟ ΔΙΚΤΥΟ MLP' char(10) title_general char(10) 'Πλήθος προτύπων test:' num2str(Ptest) char(10)];
plot_title=[ plot_title 'Πλήθος προτύπων επιτυχώς κατηγοριοποιημένων:' num2str(classified_OK) char(10)];
plot_title=[ plot_title 'Ποσοστό επιτυχώς κατηγοριοποιημένων: ' num2str(classified_RATIO)];
title(plot_title, ...
    'FontSize', 10);

%% SAVE FILES
%   time_stamp 
  prompt=(['SAVE FILES ?' char (10)]);
  prompt=([prompt '(Press "Y" or "y" and "enter" to save.)'  char (10)]);
  prompt=([prompt '(Press any other key and "enter" to abort)' char (10) '--> ' char (10)] );
  
 % beep;
  %save_experiment = input(prompt, 's');
  save_experiment='Y'
%   save_experiment='N'
%   beep;
  
if (save_experiment=='Y' || save_experiment=='y');
%Define the path
   results_path='c:\abalone_results'; %change this to an other location. 
   this_experiment_path =([results_path '\single_runs']);
   mkdir (this_experiment_path);
   %save files
   print('-dpng', '-f1',[this_experiment_path '\' time_stamp '_BP-CONF.png']);
   print('-dpng', '-f2',[this_experiment_path '\' time_stamp '_BP-TEST.png']);
   
else
end
%   beep;
  ['classified_RATIO_tr: ' num2str(classified_RATIO_tr)]
  ['classified_RATIO: ' num2str(classified_RATIO)]
  ['classified_RATIO + c_miss:' num2str(classified_RATIO + c_miss)]
  ['TP (predicted as 1 and are truly 1):' num2str(TP)]
  ['FP+TP (predicted as 1): ' num2str(TP+FP)]
  ['TP+FN (all the true 1):' num2str(TP+FN)]
  ['precision % (predicted as 1 and are truly 1): ' num2str(precision)]
  ['recall % (predicted as 1 from the total truly 1): ' num2str(recall)]
   
  time_stamp