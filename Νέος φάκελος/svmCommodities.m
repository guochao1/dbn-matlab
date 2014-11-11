%% Clear previous session
clear; clc;
tic;
%% Calculate the line where the keyword "DATE" exists in order to skip the header lines

filename = 'masterdata.dat';
path = 'C:\Users\John\Documents\MATLAB\';

resfile = strcat(path, filename);

fid = fopen('masterdata.dat','r');
Data = textscan(fid, '%d;%f;%f;%f;%f','HeaderLines',1);
fclose(fid);

%% Creating tables X and T

fprintf('Creating training and target tables...\n');

n = 4;
P = length(Data{1});
P1 = P-n;
% Creating table T which contains the timestamps
formatin = 'yyyy-mm-dd';
D = zeros(1,P1);
for i=P1:-1:n
    di = Data{1}(i);
    D(i) = Data{1}(i);
end

X = zeros(n*4,P1);
T = zeros(1,P1);
% Creating X
a=n+1;
for i=P:-1:a
    for j=1:n
        %dex
        dex=i-j;
        dex_i = Data{2}(dex);
        X(j,i-n) = dex_i;
        %gold
        gold=i-j;
        gold_i = Data{3}(gold);
        X(j+4,i-n) = gold_i;
        %oil
        oil=i-j;
        oil_i = Data{4}(oil);
        X(j+8,i-n) = oil_i;
        %libor
        libor=i-j;
        libor_i = Data{5}(libor);
        X(j+12,i-n) = libor_i;
    end
    %Creating T (a.k.a. targets)
    diff = Data{2}(i)-Data{2}(i-1);
    if(diff >= 0)
        T(i-n) = 1;
    else
        T(i-n) = -1;
    end
end

% open a file for writing
fid = fopen('dataready.txt', 'w');
 
% Table Header
fprintf(fid, 'DEX1;DEX2;DEX3;DEX4;Gold1;Gold2;Gold3;Gold4;Oil1;Oil2;Oil3;Oil4;LIBOR1;LIBOR2;LIBOR3;LIBOR4\n');
 
% print values in column order
fprintf(fid, '%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f\n', X');
fclose(fid);

fprintf('Execution Completed\n');

%% CHECK TARGET TABLE (for testing only)
% 
% for i=P:-1:a
%     diff =sign(Data{2}(i)-Data{2}(i-1));
% 	fprintf('%f\t-\t%f\t=\t%d\n',Data{2}(i), Data{2}(i-1),diff*Y(i-n));
%     
%     
% end

%%
fid = fopen('testruns.txt', 'w');
fprintf(fid,'Sigma;Gamma;Percentage\n');
%% Parameters
s_arr = [1 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100];
%s_arr = [1 2];
g_arr = [ 0.001 0.01 0.025 0.05 0.075 0.1 0.25 0.5 0.75 1 ];
%g_arr = [0.001 1];
for sigma = s_arr
fprintf('\nRunning tests for sigma = %.4f...\n',sigma);
fprintf('=============================\n');
for gamma = g_arr 

    
%% ITERATIONS
Iter = 30;
A = zeros(1,Iter);
fprintf('Running tests for gamma = %.4f...\n',gamma);
for i=1:Iter
    
    % CROSS-VALIDATION
    hold_out=0.2;
    [trainidx, testidx] = crossvalind('HoldOut', P1, hold_out);
    % train set:
    xtrain = X(:,trainidx); %train set(data)
    ttrain = T(trainidx); %train set (targets)
    % test set:
    xtest = X(:,testidx); %test set (data)
    ttest = T(testidx); %test set (targets)
    % Πλήθος προτύπων train
    Ptrain = sum(trainidx);
    % Πλήθος προτύπων test
    Ptest = sum(testidx);
    %cross_validation_label=['Train=' num2str(Ptrain) ',Test=' num2str(Ptest) ', All=' num2str(P) '. Hold out=' num2str(hold_out*100) '%%' ];

    % SVM
    
    
    parameters = sprintf('-s 1 -t 2 -g %.4f -c %d -q',gamma, sigma);
    svmrbf = svmtrain(ttrain', xtrain',parameters);

    [predict_label, accuracy, prob_values] = svmpredict(ttest', xtest', svmrbf, '-q');
    A(i) = accuracy(1);
    %fprintf('Finished Iteration no.%d out of %d\t-\tAccuracy: %.1f%%\n',i,Iter,A(i));
end

%fprintf('The mean accuracy for %d iterations and gamma = %f is %.1f%% \n',Iter,gamma, mean(A));
temp = [sigma gamma mean(A)];
fprintf(fid,'%d;%.4f;%.1f\n',temp');

end
end
fclose(fid);
fprintf('\n\n');
toc;
beep