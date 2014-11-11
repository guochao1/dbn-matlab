%% Clear previous session
clear; clc;

%% Calculate the line where the keyword "DATE" exists in order to skip the header lines

filename = 'DEXJPUS2.txt';
path = 'C:\JulyData\Data\INTLFXD_txt_2\data\';

resfile = strcat(path, filename);

haystack = fopen(resfile,'r');
needle   = 'DATE';

line  = 0;
found = false;
while ~feof(haystack)

    tline = fgetl(haystack);
    line = line + 1;

    if ischar(tline) && ~isempty(strfind(tline, needle))
        found = true;
        break;
    end

end

if ~found
    line = NaN; end

fclose(haystack);


%% Reading data
fid = fopen(resfile,'r');

% Ignore all lines of text, until we see one that just consists of this:
startString = 'DATE';

while 1
    tline = fgetl(fid);

    % Break if we hit end of file, or the start marker
    if ~ischar(tline)  ||  strncmp(tline, startString,4)
        break
    end
end
i=1;
while 1

    % Real file input stuff here
    tline=fgetl(fid);
    
    if (~ischar(tline))
        break
    end
    
    [date, dex] = sscanf(char(tline), '%10s %f',inf);
    if(length(date) == 11)
        Data{1}{i,1}(1:10) = char(date(1:10,1)');
        Data{2}(i,1) = double(date(11));
        i=i+1;
    end
    %fprintf('%s \n',date);
end
fclose(fid);
% for i=1:length(Data{1})
%     fprintf('%s \t%.4f \n',Data{1}{i}, Data{2}(i)); 
% end

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

%% Parameters
g_arr = [ 0.015 0.014 0.013 0.012 0.011];
for gamma = g_arr 

    
%% ITERATIONS
Iter = 25;
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
    
    
    parameters = sprintf('-s 1 -t 2 -g %.4f -q',gamma);
    svmrbf = svmtrain(ttrain', xtrain',parameters);

    [predict_label, accuracy, prob_values] = svmpredict(ttest', xtest', svmrbf, '-q');
    A(i) = accuracy(1);
    %fprintf('Finished Iteration no.%d out of %d\t-\tAccuracy: %.1f%%\n',i,Iter,A(i));
end

fprintf('The mean accuracy for %d iterations and gamma = %f is %.1f%% \n',Iter,gamma, mean(A));

end

