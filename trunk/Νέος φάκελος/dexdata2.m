clear; clc;

%% Calculate the line where the keyword "DATE" exists in order to skip the header lines

files = dir('C:\JulyData\Data\INTLFXD_txt_2\data\*.txt');
for file = files'

    %resfile = 'C:\JulyData\Data\INTLFXD_txt_2\data\DEXBZUS.txt';
    path = 'C:\JulyData\Data\INTLFXD_txt_2\data\';
    filename = file.name;
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

    fprintf('%s\t\t%d \n',filename,line);

end

