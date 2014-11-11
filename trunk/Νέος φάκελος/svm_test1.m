%% Clear previous session
clear; clc;

%% Calculate the line where the keyword "DATE" exists in order to skip the header lines

filename = 'dataready.txt';
path = 'C:\Users\John\Documents\MATLAB\';

resfile = strcat(path, filename);
format = [repmat('%f;', [1 15]) '%f'];

fid = fopen(resfile,'r');
Data = textscan(fid, format,'HeaderLines',1);
fclose(fid);