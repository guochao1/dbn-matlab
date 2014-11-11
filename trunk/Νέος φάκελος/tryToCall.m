%% Clear previous session
clear; clc;
%%
dataStartPoint = '2001-01-02';
fprintf('Running...\n');
fprintf('Getting US - EU Exchange Rate...\n');
dex = getDex('C:\JulyData\Data\INTLFXD_txt_2\data\DEXUSEU.txt',dataStartPoint);
fprintf('Getting Gold...\n');
gold = getCommodities('C:\JulyData\Commodities\GOLD\GOLDPMGBD228NLBM.csv',dataStartPoint);
fprintf('Getting Oil...\n');
oil = getCommodities('C:\JulyData\Commodities\OIL\DCOILWTICO.csv',dataStartPoint);
fprintf('Getting LIBOR...\n');
libor = getCommodities('C:\JulyData\Commodities\LIBOR\USDONTD156N.csv',dataStartPoint);

i = find(gold{1} == datenum(dataStartPoint));
fprintf('Creating master table...\n');


%Create a table with the timestamps
%Have every matrix fill the table
%
% Master table 
startDate = datenum('2001-01-02');
endDate = datenum('2014-01-02');
Data{1}(:,1) = startDate:1:endDate;

lenData = length(Data{1});
lenDex = length(dex{2});
lenGold = length(gold{2});
lenOil = length(oil{2});
lenLibor = length(libor{2});

% Adding dex
c = 1;
for i=1:lenData
    if(Data{1}(i,1) == dex{1}(c,1) && ~isempty(dex{2}(c,1)))
        Data{2}(i,1) = dex{2}(c,1);
        c=c+1;
    else
        Data{2}(i,1) = -1;
    end
end


% Adding gold
c = 1;
for i=1:lenData
    if(Data{1}(i,1) == gold{1}(c,1) && ~isempty(gold{2}(c,1)))
        Data{3}(i,1) = gold{2}(c,1);
        c=c+1;
    else
        Data{3}(i,1) = -1;
    end
end

% Adding oil
c = 1;
for i=1:lenData
    if(Data{1}(i,1) == oil{1}(c,1) && ~isempty(oil{2}(c,1)))
        Data{4}(i,1) = oil{2}(c,1);
        c=c+1;
    else
        Data{4}(i,1) = -1;
    end
end

% Adding libor
c = 1;
for i=1:lenData
    if(Data{1}(i,1) == libor{1}(c,1) && ~isempty(libor{2}(c,1)))
        Data{5}(i,1) = libor{2}(c,1);
        c=c+1;
    else
        Data{5}(i,1) = -1;
    end
end

idx = [];
for i=1:lenData
    if((Data{2}(i,1) ~= -1) && (Data{3}(i,1) ~= -1) && (Data{4}(i,1) ~= -1) && (Data{5}(i,1) ~= -1) )
        idx = [idx i];
    end
end

j = 1;
for i=idx
        Res{1}(j,1) = Data{1}(i,:);
        Res{2}(j,1) = Data{2}(i,:);
        Res{3}(j,1) = Data{3}(i,:);
        Res{4}(j,1) = Data{4}(i,:);
        Res{5}(j,1) = Data{5}(i,:);
        j=j+1;
end

lenRes = length(Res{1});
header = {'Date';'DEX';'Gold';'Oil';'LIBOR'};
t = zeros(length(Res{1}),5);
for i=1:lenRes
    t(i,:) = [Res{1}(i,1);Res{2}(i,1);Res{3}(i,1);Res{4}(i,1);Res{5}(i,1);];
end
len_t = length(t(:,1));
t2_max = max(t(:,2));
t3_max = max(t(:,3));
t4_max = max(t(:,4));
t5_max = max(t(:,5));
for i=1:len_t
    t(i,2) = t(i,2)/t2_max;
    t(i,3) = t(i,3)/t3_max;
    t(i,4) = t(i,4)/t4_max;
    t(i,5) = t(i,5)/t5_max;
end
fprintf('Writing to file...\n');

% open a file for writing
fid = fopen('masterdatatable.txt', 'w');
 
% Table Header
fprintf(fid, 'Date;DEX;Gold;Oil;LIBOR\n');
 
% print values in column order
fprintf(fid, '%d;%.4f;%.4f;%.4f;%.4f\n', t');
fclose(fid);

fprintf('Execution Completed\n');

% [rNum, cellNum] = size(Data);
% for i=1:cellNum
%     [x, y] = size(Data{i});
%     fprintf('%d\t\n',x);
% end





