clear; clc;

%% Reading data
fid = fopen('C:\JulyData\DEXCHUS2.dat','r');
Data = textscan(fid, '%10s %f');
fclose(fid);

n = 4;

P = length(Data{1});
P1 = P-n;
% Creating table T which contains the timestamps
formatin = 'yyyy-mm-dd';
D = zeros(1,P1);
for i=P1:-1:n
    di = Data{1}(i);
    D(i) = datenum(Data{1}(i),formatin);
end

X = zeros(n,P1);
T = zeros(1,P1);
% Creating X
a=n+1;
for i=P:-1:a
    for j=1:n
        b=i-j;
        bi = Data{2}(b);
        X(j,i-n) = bi;
    end
    %Creating T (a.k.a. targets)
    diff = Data{2}(i)-Data{2}(i-1);
    if(diff >= 0)
        T(i-n) = 1;
    else
        T(i-n) = -1;
    end
end
%% CHECK TARGET TABLE (for testing only)
% 
% for i=P:-1:a
%     diff =sign(Data{2}(i)-Data{2}(i-1));
% 	fprintf('%f\t-\t%f\t=\t%d\n',Data{2}(i), Data{2}(i-1),diff*Y(i-n));
%     
%     
% end
%% ITERATIONS
Iter = 50;
A = zeros(1,Iter);
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

    svmrbf = svmtrain(ttrain', xtrain','-s 1 -t 2 -q');

    [predict_label, accuracy, prob_values] = svmpredict(ttest', xtest', svmrbf, '-q');
    A(i) = accuracy(1);
end

fprintf('The accuracy for %d iterations is %.1f%% \n',Iter, mean(A));