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
    if (Data{9}(i)>=1 && Data{9}(i)<11) %define the range
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
    % ������ �������� train
    Ptrain = sum(trainidx);
    % ������ �������� test
    Ptest = sum(testidx);

% Define structure of MLP
%numHidden = input('���� ������ ������ �������� --> ');
numHidden=100;

%% MODELS (select model)
% Define structure of MLP
%net = newff(P,T,S,TF,BTF,BLF,PF,IPF,OPF,DDF)

%Gradient descent with momentum
% net = newff(xtrain,ttrain,numHidden,{'tansig','tansig'},'traingdm');

%Conjugate gradient backpropagation with Powell-Beale restarts 
%net = newff(xtrain,ttrain,numHidden,{'tansig','tansig'},'traincgb');

%Conjugate gradient backpropagation with Polak-Ribi?re updates 
% net = newff(xtrain,ttrain,numHidden,{'tansig','tansig'},'traincgp');

% *** Conjugate gradient backpropagation with Fletcher-Reeves updates  *** 
% net = newff(xtrain,ttrain,numHidden,{'tansig','tansig'},'traincgf');

%Levenberg-Marquardt model
net = newff(xtrain,ttrain,numHidden,{'tansig','tansig'},'trainlm');

%% Train MLP
% Training parameters
net.trainParam.mc = 0.6;
net.trainParam.epochs = 10;
net.trainParam.goal = 0.01;
net.trainParam.max_fail=105;
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
xlabel('����� �����������', ...
    'FontSize', 14);
ylabel('������ - MSE (�������� ��� �� �����)', ...
    'FontSize', 14);
title(['���������� MLP �� "BACK PROPAGATION"' char(10) title_general], ...
    'FontSize', 10);


%% ��������
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
   
 %PLOT THE RESULTS FOR THE TEST SET 
figure(2)
plot(1:Ptest,Y,'r.', ...
    'MarkerSize', 5);
hold on
grid on
plot(1:Ptest,0,'b.', ...
   'MarkerSize', 5);
hold off
legend('outputs','decision level for classification','Location','SO');
xlabel('�/� ��������', ...
    'FontSize', 14);
ylabel('�������� (������):  Y = sim(net2,xtest)', ...
    'FontSize', 14);
plot_title=['�������� ��� ������ MLP' char(10) title_general char(10) '������ �������� test:' num2str(Ptest) char(10)];
plot_title=[ plot_title '������ �������� �������� ������������������:' num2str(classified_OK) char(10)];
plot_title=[ plot_title '������� �������� ������������������: ' num2str(classified_RATIO)];
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
   print('-dpng', '-f1',[this_experiment_path '\' time_stamp '_BP-MSE.png']);
   print('-dpng', '-f2',[this_experiment_path '\' time_stamp '_BP-TEST.png']);
else
end
%   beep;
  ['classified_RATIO: ' num2str(classified_RATIO)]
  ['classified_RATIO_tr: ' num2str(classified_RATIO_tr)]
  time_stamp