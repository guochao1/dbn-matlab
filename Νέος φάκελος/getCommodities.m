function [Data] = getCommodities(filepath,date)

%% Clear previous session
%clear; clc;

%% Calculate the line where the keyword "DATE" exists in order to skip the header lines

%filename = 'DEXJPUS2.txt';
%path = 'C:\JulyData\Data\INTLFXD_txt_2\data\';

resfile = filepath;

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
dateString = datenum(date);
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
    
    [date, dex] = sscanf(char(tline), '%10s,%f',inf);
    if(dateString <= datenum(char(date(1:10,1)'),'yyyy-mm-dd'))
        if(length(date) == 11)
                Data{1}(i,1) = datenum(char(date(1:10,1)'),'yyyy-mm-dd');
                Data{2}(i,1) = double(date(11));
                i=i+1;
        end
    end
    %fprintf('%s \n',date);
end
fclose(fid);
% for i=1:length(Data{1})
%     fprintf('%s \t%.4f \n',Data{1}(i), Data{2}(i)); 
% end
%% Adjusting to needed date
% dataStartPoint = datenum(date);
% i =find(Data{1} == dataStartPoint);
% Data{1} = Data{1}(i:end,1);
% Data{2} = Data{2}(i:end,1);

end