%% Clear previous session
clear; clc;
tic;
%% Calculate the line where the keyword "DATE" exists in order to skip the header lines

filename = 'completeData.dat';
path = 'C:\Users\John\Documents\MATLAB\';

resfile = strcat(path, filename);

fid = fopen('completeData.txt','r');
Data = textscan(fid, '%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%d;%d');
fclose(fid);

%% Creating tables X and T

fprintf('Creating training and target tables...\n');

P = length(Data{1});
% Creating table T which contains the timestamps

X = zeros(16,P);
T = zeros(1,P);
% Creating X

for j=1:16
    for i=1:P

            X(j,i) = Data{j}(i,1);
    end
end
% open a file for writing
fid = fopen('transposedData.txt', 'w');
 
% Table Header
 
% print values in column order
format = strcat(mat2str(repmat('%f;', [1 3151])),'%f\n');

fprintf(fid, format, X');
fclose(fid);

fprintf('Execution Completed\n');