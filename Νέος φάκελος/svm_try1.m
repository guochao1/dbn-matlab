% ’σκηση 4.5
clear; clc;

fid = fopen('C:\JulyData\DEXCHUS.txt','r');
Data = textscan(fid, '%f,%f,%f,%f,%[^\n]\n');
fclose(fid);

P = length(Data{1});    % Πλήθος προτύπων (P = 150)
n = 4;                  % Διάσταση προτύπων (n = 4)
% Patterns
X = zeros(n,P);
for i=1:P
    X(1,i) = Data{1}(i);
    X(2,i) = Data{2}(i);
    X(3,i) = Data{3}(i);
    X(4,i) = Data{4}(i);
end
% Targets
d = zeros(1,P);
for i=1:P
    if strcmp(Data{5}(i),'Iris-versicolor')
        d(i) = 1;
    else
        d(i) = -1;
    end
end

%% SVM

% Γραμμικός πυρήνας
model = svmtrain(X', d',  'Autoscale', false);
y = svmclassify(model, X');
decision = 2*(y>0)' - 1;
misclass_linear = sum(decision ~= d);
num_sv_linear = length(model.SupportVectorIndices);
fprintf('*** Πυρήνας: Γραμμικός\n');
fprintf('Πλήθος δ.υ. = %d\n', num_sv_linear);
fprintf('misclass = %d\n', misclass_linear);

% Πυρήνας RBF, σ = 0.5
i = 0;
sarr = [0.1, 0.2, 0.5, 1, 2, 3, 4, 5];
for sigma = sarr
    i = i+1;
    model = svmtrain(X', d', 'Kernel_Function', 'rbf', 'RBF_Sigma', sigma, 'Autoscale', false);
    y = svmclassify(model, X');
    decision = 2*(y>0)' - 1;
    misclass(i) = sum(decision ~= d);
    num_sv(i) = length(model.SupportVectorIndices);
    fprintf('*** Πυρήνας: RBF (σ=%f):\n', sigma);
    fprintf('Πλήθος δ.υ. = %d\n', num_sv(i));
    fprintf('misclass = %d\n', misclass(i));
end

%%
figure(1);
AX = plotyy(sarr, misclass, sarr, num_sv);
set(get(AX(1),'Ylabel'), 'String', 'misclass');
set(get(AX(2),'Ylabel'), 'String', '# support vectors');
set(get(AX(1),'Children'), 'LineWidth',3);
set(get(AX(2),'Children'), 'LineWidth',3);
xlabel('\sigma');
title('Iris class 2 vs rest (Kernel RBF)');

print('-dtiff','-f1','askisi45.tif');