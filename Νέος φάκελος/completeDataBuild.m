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
dex_max = max(Data{2});
gold_max = max(Data{3});
oil_max = max(Data{4});
libor_max = max(Data{5});

X = zeros(n*4,P1);
T = zeros(1,P1);
% Creating X
a=n+1;
for i=P:-1:a
    for j=1:n
        %dex
        dex=i-j;
        dex_i = Data{2}(dex);
        X(j,i-n) = dex_i / dex_max;
        %gold
        gold=i-j;
        gold_i = Data{3}(gold);
        X(j+4,i-n) = gold_i / gold_max;
        %oil
        oil=i-j;
        oil_i = Data{4}(oil);
        X(j+8,i-n) = oil_i / oil_max;
        %libor
        libor=i-j;
        libor_i = Data{5}(libor);
        X(j+12,i-n) = libor_i / libor_max;
    end
    X(17,i) = Data{1}(i);
    %Creating T (a.k.a. targets)
    diff = Data{2}(i)-Data{2}(i-1);
    if(diff >= 0)
        X(18,i-n) = 1;
    else
        X(18,i-n) = -1;
    end
end

% open a file for writing
fid = fopen('completeData.txt', 'w');
 
% Table Header
fprintf(fid, 'DEX1;DEX2;DEX3;DEX4;Gold1;Gold2;Gold3;Gold4;Oil1;Oil2;Oil3;Oil4;LIBOR1;LIBOR2;LIBOR3;LIBOR4,Date,Target\n');
 
% print values in column order
fprintf(fid, '%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%.4f;%d;%d\n', X);
fclose(fid);

fprintf('Execution Completed\n');