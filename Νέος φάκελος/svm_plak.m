clear; clc;

%% Reading data
fid = fopen('C:\Python27\Lib\site-packages\xy\Projects\Data\plak_data.csv','r');
format = repmat('%f;',1,193);
Data = textscan(fid, [format, '%d\n']);
fclose(fid);


P = length(Data{1});

% Creating table T which contains the timestamps


X = zeros(193,P);
T = zeros(1,P);
% Creating X

for i=1:P
    for j=1:193
        X(j,i) = Data{j}(i);
    end
    %Creating T (a.k.a. targets)
    T(i) = Data{194}(i);
end
%% CHECK TARGET TABLE (for testing only)

% for i=1:P
%     diff =sign(Data{194}(i));
% 	fprintf('%f\t=\t%d\n',Data{194}(i),diff*T(i));
% end
%% ITERATIONS
Iter = 50;
A = zeros(1,Iter);
for i=1:Iter
    % CROSS-VALIDATION
    hold_out=0.2;
    [trainidx, testidx] = crossvalind('HoldOut', P, hold_out);
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
    fprintf('iteration: %d\t%f\n',i, A(i));
end
clc;
fprintf('The accuracy for %d iterations is %.1f%% \n',Iter, mean(A));