%% TRAINING MLP WITH BACK-PROPAGATION
clear; clc; close all;
%Make a note of the time and date
time_stamp = datestr(now, 'yyyy-mm-dd-tHHMMSS');

%%
%EXPERIMENT CONDITIONS
threshold_target=1;
runs_to_run=10 %echo this in the command window
epochs_to_run=10;
%numHidden = input('Äþóå ðëÞèïò êñõöþí íåõñþíùí --> ');
numHidden=100;

%% LOAD DATA AND PREPROCESS
% Read-in, the ABALONE dataset
fid = fopen('abalone.org.csv','r');
Data = textscan(fid, '%f,%f,%f,%f,%f,%f,%f,%f,%f');
fclose(fid);
n = 8;    % number of dimensions to use
for i=1:n
 X(i,:) = double(Data{i}(:))';% parse "Data" into "X" except the 9th dimension
%X(i,:) = Data{i}(:);
end
P = size(X,2);  % number of patterns
% Form the target vector for "a range" of rings number vs. the rest, having  the sigmoid function in mind
for i=1:P
    if (Data{9}(i)>=1 && Data{9}(i)<11) %define the range
   %if (Data{9}(i)==10)
    t(i) = 1*threshold_target; %target if in range
   else
    t(i) = -1*threshold_target; %target if out of range
   end 
end

%% DEFINE A LOOP SEQUENCE
['start:' time_stamp] %echo this in the command window

%% EXECUTE THE LOOP (define a model, train it, test it, store results and loop)

%prelocate some memory 
all_runs_data_array = zeros(runs_to_run, 7);

loop_index=0;

for runs=1:1:runs_to_run;
    loop_index=loop_index+1;
    runs %echo this in the command window
%%CROSS-VALIDATION
    hold_out=0.2;
    [trainidx, testidx] = crossvalind('HoldOut', P, hold_out);
    % train set:
    xtrain = X(:,trainidx); %train set(data)
    ttrain = t(trainidx); %train set (targets)
    % test set:
    xtest = X(:,testidx); %test set (data)
    ttest = t(testidx); %test set (targets)
    % ÐëÞèïò ðñïôýðùí train
    Ptrain = sum(trainidx);
    % ÐëÞèïò ðñïôýðùí test
    Ptest = sum(testidx);

    cross_validation_label=['Train=' num2str(Ptrain) ', Test=' num2str(Ptest) ', All=' num2str(P) '. Hold out=' num2str(hold_out*100) '%%' ];    
    

    
%% MODELS (select model)
% Define structure of MLP
%net = newff(P,T,S,TF,BTF,BLF,PF,IPF,OPF,DDF)

%Gradient descent with momentum
% net = newff(xtrain,ttrain,numHidden,{'tansig','tansig'},'traingdm');
% run_training_function='traingdm';
% run_training_model='Gradient descent with momentum ("traingdm")';

%Conjugate gradient backpropagation with Powell-Beale restarts 
% net = newff(xtrain,ttrain,numHidden,{'tansig','tansig'},'traincgb');
% run_training_function='traincgb';
% run_training_model='Conjugate gradient backpropagation with Powell-Beale restarts ("traincgb")';

%Conjugate gradient backpropagation with Polak-Ribi?re updates
% net = newff(xtrain,ttrain,numHidden,{'tansig','tansig'},'traincgp');
% run_training_function='traincgp';
% run_training_model='Conjugate gradient backpropagation with Polak-Ribi?re updates  ("traincgp")';

%Conjugate gradient backpropagation with Fletcher-Reeves updates   
 net = newff(xtrain,ttrain,numHidden,{'tansig','tansig'},'traincgf');
 run_training_function='traincgf';
 run_training_model='Conjugate gradient backpropagation with Fletcher-Reeves updates  ("traincgf")';

%Levenberg-Marquardt model
%net = newff(xtrain,ttrain,numHidden,{'tansig','tansig'},'trainlm');
%run_training_function='trainlm';
%run_training_model='Levenberg-Marquardt model ("trainlm")';


%% TRAIN MLP
% Training parameters
net.trainParam.mc =0.7;  % Momentum constant
net.trainParam.epochs = epochs_to_run; %Maximum number of epochs to train
net.trainParam.goal = 0.01; %Performance goal
net.trainParam.max_fail=110; %Maximum validation failures
net.trainParam.showWindow=1;% diplay the training window (1:display, 0:do not display) 
%Go train the network
[net2,tr] = train(net,xtrain,ttrain);

%% DATA FOR THE TILTE OF THE PLOT (Build-up the label of the plot)
run_other_settings='Default other settings';
run_info_label=['Time stamp: ' time_stamp char(10)];
run_info_label=[run_info_label 'Model: ' run_training_model char(10)];
run_info_label=[run_info_label 'Cross-validation info: ' cross_validation_label char(10)];
run_info_label=[run_info_label 'Hidden neurons: ' num2str(numHidden) char(10)];
run_info_label=[run_info_label 'net.trainParam.epochs: ' num2str(net.trainParam.epochs) char(10)];
run_info_label=[run_info_label 'net.trainParam.goal: ' num2str(net.trainParam.goal) char(10)];
run_info_label=[run_info_label 'net.trainParam.max-fail: ' num2str(net.trainParam.max_fail) char(10)];
run_info_label=[run_info_label 'net.trainParam.mc (only for Gradient descent with momentum): ' num2str(net.trainParam.mc) char(10)];
run_info_label=[run_info_label 'Other settings: ' run_other_settings char(13) char(10)];
run_info_label=[run_info_label 'Runs performed: ' num2str(loop_index) ' , of total ' num2str(runs_to_run) ' runs'];

%% MANAGE THE STOP-CAUSE OF THE RUN (turn the nominal into numeric)
 switch tr.stop 
     case 'Performance goal met.'
      run_stop_cause=2;
     case 'Maximum epoch reached.'
      run_stop_cause=4;
     case 'Validation stop.'
      run_stop_cause=6;
     case 'Minimum gradient reached'
      run_stop_cause=8;
     case 'User stop.' 
      run_stop_cause=10;
     case 'User cancel.'
      run_stop_cause=10; 
     otherwise 
      run_stop_cause=12;
 end
 stop_description=['2=Performance goal met.' char(10)];
 stop_description=[stop_description '4=Maximum epoch reached.' char(10)];
 stop_description=[stop_description '6=Validation stop.' char(10)];
 stop_description=[stop_description '8=Minimum gradient reached.' char(10)];
 stop_description=[stop_description '10=User stop. or User cancel. ' char(10)];
 stop_description=[stop_description '12=Other stop cause.' char(10)];
 
 %%SIMULATE AGAINST THE TEST SET
 Y = sim(net2,xtest); % test the network using the test set data
  % Y is the neuron's output. Make Y crisp and compare with the target
  
  %Characherize the output of the net ("Y")
  %if "Y > threshold_crispness" it is correctly clasified
  decision=(2*(Y>0)-1)* threshold_target; % 1 if correctly classified, 0 if not
  classified_OK=sum(decision==ttest);
  classidied_TESTED=Ptest;
  classified_RATIO=classified_OK./Ptest % echo this in the command window
  
  %%SIMULATE AGAINST THE TRAIN SET
 Y_tr = sim(net2,xtrain); % test the network using the test set data
  % Y_tr is the neuron's output. Make Y_tr crisp and compare with the target
  
  %Characherize the output of the net ("Y_tr")
  %if "Y_tr > threshold_crispness" it is correctly clasified
  decision_tr=(2*(Y_tr>0)-1)* threshold_target; % 1 if correctly classified, 0 if not
  classified_OK_tr=sum(decision_tr==ttrain);
  classidied_TESTED_tr=Ptrain;
  classified_RATIO_tr=classified_OK_tr./Ptrain % echo this in the command window
  
  
  
 
%% COLLECT THE RESULTS OF THIS RUN AND PUT THEM IN AN ARRAY 
% echo the following line ("single_run_data_array=....")in the command window to known it is running
single_run_data_array=[runs,max(tr.epoch),tr.best_epoch,min(tr.perf),min(tr.vperf),min(tr.tperf),run_stop_cause,classified_RATIO,classified_RATIO_tr];
all_runs_data_array(loop_index,1:9)=[runs,max(tr.epoch),tr.best_epoch,min(tr.perf),min(tr.vperf),min(tr.tperf),run_stop_cause,classified_RATIO,classified_RATIO_tr];

end % End of this run. Go run another.

%% PLOT THE SIMULATION PERFOMÁNCE
figure(1)
grid on;
grid minor;
hold on;
%classified_RATIO (TEST)
plot(all_runs_data_array(:,1),all_runs_data_array(:,8),'b','LineWidth', 2);
plot(all_runs_data_array(:,1),all_runs_data_array(:,8),'b.',...
        'MarkerSize', 15)
 %classified_RATIO_tr (TRAIN)   
plot(all_runs_data_array(:,1),all_runs_data_array(:,9),'r','LineWidth', 2);
plot(all_runs_data_array(:,1),all_runs_data_array(:,9),'r.',...
        'MarkerSize', 15)
    
run_info_label2= ['all runs "max(classified-RATIO)": ' num2str(max(all_runs_data_array(:,8))) ' - '];
run_info_label2= [run_info_label2 '"max(classified-RATIO-tr)": ' num2str(max(all_runs_data_array(:,9))) char(10)];
run_info_label2= [run_info_label2 'all runs "mean(classified-RATIO)": ' num2str(mean(all_runs_data_array(:,8))) ' - '];
run_info_label3= [run_info_label2 '"mean(classified-RATIO-tr)": ' num2str(mean(all_runs_data_array(:,9))) char(10)];

legend('classified RATIO ','','classified RATIO-tr','','Location','SO');
 xlabel('ÅðáíÜëçøç(Run)', ... 
     'FontSize', 15);
 ylabel('Ðïóïóôü åðéôõ÷þò êáôçãïñéïðïéçìÝíùí', ...
     'FontSize', 15);
 
 title(['ÅÊÐÁÉÄÅÕÓÇ MLP ÓÅ "BACK PROPAGATION"' char(10) 'ÅÐÉÔÕ×ÇÌÅÍÅÓ ÊÁÔÇÃÏÑÉÏÐÏÉÇÓÅÉÓ (% åðß ôïõ óõíüëïõ åëÝã÷ïõ)' char(10) run_info_label char(10) run_info_label3 char(10) ] , ...
     'FontSize', 10) ;

%% PLOT THE TRAIN PERFORMANCE
figure(2)
% scrsz = get(0,'ScreenSize');
%figure('OuterPosition',[10 (scrsz(4)/2)-200 scrsz(3)/ scrsz(4)/1])

grid on;
grid minor;
hold on;

%min(tr.perf)
plot(all_runs_data_array(:,1),all_runs_data_array(:,4),'b','LineWidth', 2);
plot(all_runs_data_array(:,1),all_runs_data_array(:,4),'b.',...
    'MarkerSize', 15);
%"min(tr.vperf)
plot(all_runs_data_array(:,1),all_runs_data_array(:,5),'g','LineWidth', 2);
plot(all_runs_data_array(:,1),all_runs_data_array(:,5),'g.',...
    'MarkerSize', 15);
%min(tr.tperf)
plot(all_runs_data_array(:,1),all_runs_data_array(:,6),'r','LineWidth', 2);
plot(all_runs_data_array(:,1),all_runs_data_array(:,6),'r.',...
    'MarkerSize', 15);

legend('Training performance "min(tr.perf)"','','Validation performance "min(tr.vperf)"','','Test performance "min(tr.tperf)"','','Location','SO');
 xlabel('ÅðáíÜëçøç(Run)', ... 
     'FontSize', 15);
 ylabel('ÓöÜëìá -MSE (áðüêëéóç áðü ôï óôü÷ï)', ...
     'FontSize', 15);
 title(['ÅÊÐÁÉÄÅÕÓÇ MLP ÓÅ "BACK PROPAGATION" - ÓÖÁËÌÁ' char(10) run_info_label ' - ' 'all runs best "min(tr.tperf)": ' num2str(min(all_runs_data_array(:,6)))] , ...
     'FontSize', 10) ;

 %% PLOT THE STOP CAUSE
figure(3);
axis([1 runs_to_run 0 14])
grid on;
grid minor;
hold on;
plot(all_runs_data_array(:,1),all_runs_data_array(:,7),'g.',...
    'MarkerSize', 20);
legend(['"tr.stop" : ' char(10) stop_description ] ,'Location','SO');
 xlabel('ÅðáíÜëçøç(Run)', ... 
     'FontSize', 15);
 ylabel('Ëüãïò ôåñìáôéóìïý (tr.stop)', ...
     'FontSize', 15);
 title(['ÅÊÐÁÉÄÅÕÓÇ MLP ÓÅ "BACK PROPAGATION" - ÔÅÑÌÁÔÉÓÌÏÓ' char(10) (run_info_label)]);
hold on;

%% PLOT THE EPOCHS
figure(4);
grid on;
grid minor;
hold on;

%draw the limit-line at "net.trainParam.epochs"
s=all_runs_data_array(:,1);% the X axis
w=net.trainParam.epochs+(0*s); %trick for the Y axis (to be allways "net.trainParam.epochs")
plot(s,w,'c','LineWidth', 5);
hold on;

%plot the "final epoch" 
plot(all_runs_data_array(:,1),all_runs_data_array(:,2),'r','LineWidth', 2);
plot(all_runs_data_array(:,1),all_runs_data_array(:,2),'r.',...
    'MarkerSize', 25);

%plot the "best epoch"
plot(all_runs_data_array(:,1),all_runs_data_array(:,3),'b','LineWidth', 2);
plot(all_runs_data_array(:,1),all_runs_data_array(:,3),'b.',...
    'MarkerSize', 15);

legend(['max epochs to run (' num2str(net.trainParam.epochs) ')'],'actual epochs run','','best epoch','','Location','SO');
 xlabel('ÅðáíÜëçøç(Run)', ... 
     'FontSize', 15);
 ylabel('Åðï÷Ýò', ...
     'FontSize', 15);
 title(['ÅÊÐÁÉÄÅÕÓÇ MLP ÓÅ "BACK PROPAGATION" - ÅÐÏ×ÅÓ' char(10) (run_info_label)]);
 
%% END OF RUNs
time_stamp_end = datestr(now, 'yyyy-mm-dd-tHHMMSS');
%echo the start end end time stamp
['started: ' time_stamp] 
%char(10)
['ended:' time_stamp_end]
%char(10)
 
 %% SAVE FILES
%Save the plot into files  
 %Choose to save or not
%   beep;
  prompt=(['SAVE FILES ?' char (10)]);
  prompt=([prompt '(Press "Y" or "y" and "enter" to save.)'  char (10)]);
  prompt=([prompt '(Press any other key and "enter" to abort)' char (10) '--> ' char (10)] );
 
 %save_experiment = input(prompt, 's');
 save_experiment='Y';
 %save_experiment='N';
%   beep;
  
if (save_experiment=='Y' || save_experiment=='y');

 %Define the path
   results_path='c:\abalone_results'; %change this to an other location. 
   this_experiment_path =([results_path '\' run_training_function '\' run_training_function '_' time_stamp ]);
   mkdir (this_experiment_path);
   %Define file name prefixes
   filename_prefix = [run_training_function '_' time_stamp];
 
 %Save a text file summary
  %prepair the data
   data_out = (['EXPERIMENT STARTED at ' time_stamp char (10)]);
   data_out = ([data_out 'Training function:' run_training_function char(10) char(10)]);
   data_out = ([data_out run_info_label char(10)]);
   data_out = ([data_out run_info_label3 char(10)]);
   data_out = ([data_out 'EXPERIMENT ENDED at ' time_stamp_end (10) char(10)]);
   data_out= [data_out '================================================================================' char(10)]; 

  %open the file with write permission
    fid = fopen([this_experiment_path '\' filename_prefix '_summary.txt'], 'A');
    fprintf(fid, data_out); % write the data
    fclose(fid);
  
  %Save the Simulaton Performance plot
   print('-dpng', '-f1', [this_experiment_path '\' filename_prefix '_sim_perf.png']);
  %Save the Training Performance plot
   print('-dpng', '-f2', [this_experiment_path '\' filename_prefix '_train_perf.png']);
  %Save the Stop Cause plot
    print('-dpng', '-f3', [this_experiment_path '\' filename_prefix '_stop.png']);
  %Save the Epochs plot
    print('-dpng', '-f4', [this_experiment_path '\' filename_prefix '_epochs.png']);

  %Save this experiment's results (all output data in XLS format)   
    xlswrite([this_experiment_path '\' filename_prefix '_data.xls'], all_runs_data_array);
    ['Files Saved in the folder' char(10) '"' this_experiment_path '"'] 
else
end
%   beep;