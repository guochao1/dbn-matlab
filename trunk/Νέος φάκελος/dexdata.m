clear; clc;


% Reading data
fid = fopen('C:\JulyData\DEXCHUS2.dat','r');
Data = textscan(fid, '%10s %f');
fclose(fid);

n = 4;

P = length(Data{1});
P1 = P-n;
% Creating Y
formatin = 'yyyy-mm-dd';
T = zeros(1,P1);
for i=P1:-1:n
    ti = Data{1}(i);
    T(i) = datenum(Data{1}(i),formatin);
end

X = zeros(n,P1);
Y = zeros(1,P1);
% Creating X
a=n+1;
for i=P:-1:a
    for j=1:n
        b=i-j;
        bi = Data{2}(b);
        X(j,i-n) = bi;
    end
    Y(i-n) = Data{2}(i);
end





