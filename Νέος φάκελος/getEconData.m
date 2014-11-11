clear;clc;
load('C:\Python27\Lib\site-packages\xy\Projects\Data\final_data.mat')

% for i = 1:193
%     for j = 1:3250
%         final_data(j,i) = double(final_data(j,i));
%     end
% end

%% target
fid = fopen('C:\Python27\Lib\site-packages\xy\Projects\Data\plak_target.txt','r');
Data = textscan(fid, '%d');
fclose(fid);

for i=1:3250
    final_data(i,194) = Data{1}(i);
end


%% Deletes rows with no target
rows_to_delete = [];
colcount = size(final_data,2);
for i=1:3250
    if(final_data(i,colcount) == -1)
        rows_to_delete = [ rows_to_delete i];
    end
end
final_data(rows_to_delete, :) = [];

rowcount = size(final_data,1);


%%
temp = double(zeros(rowcount,194));
for i = 1:193
    for j = 1:rowcount
        temp(j,i) = final_data(j,i);
    end
end


%%

% %% Normalizes the data
% temp = double(zeros(rowcount,194));
% Mean = double(zeros(193,1));
% Dev = double(zeros(193,1));
% 
% old_range = zeros(1, rowcount);
% for i = 1:193
%     Mean(i) = 0;
%     for j = 1:rowcount
%         Mean(i) = Mean(i) + final_data(j,i);   
%     end
%     Mean(i) = Mean(i) / 193;
% end
% 
% for i = 1:193
%     Dev(i) = 0;
%     for j = 1:rowcount
%         Dev(i) = Dev(i) + (final_data(j,i) - Mean(i))^2;
%     end
%     Dev(i) = sqrt(Dev(i)/193);
% end
% 
% for i = 1:193
%     for j = 1:rowcount
%         temp(j,i) = 1/(1+exp(-((final_data(j,i) - Mean(i))/Dev(i))));
%     end
% end


%% Deletes columns with Inf
cols_to_delete = [];
for j= 1:193
    if(isinf((temp(1,j))))
        cols_to_delete = [ cols_to_delete j];
    end
end
    temp(:, cols_to_delete) = [];
%%
head = 'Date;Crude Oil;Gold;Copper;Pallladium;Platinum;Silver;aluminium;zinc;nickel;lead;tin;Cotton;Lumber;Cocoa;Coffee;Orange Juice;Sugar;Corn;Wheat;Oats;Rough Rice;Soybean Meal;Soybean Oil;Soybeans;Feeder Cattle;Lean Hogs;Live Cattle;Pork Bellies;Iron Ore;6 months maturity US;10 years maturity US;CPI US;US Debt;FED rate;GDP US;M3 US;trade balance US;US deficit or Surplus;Dow Jones;Nasdaq 100;S & P 500;Productivity US;Unemployment US;Spread FF-CP;Spread FF-EFF;dollar index;dollar index;dollar index;CPI EU;Current accounts EU;Debt EU;Deficit EU;CAC 40;DAX;GDP EU;Interest rate EU;M3 EU;Productivity EU;Unemployment EU;Spread MLP-Euribor 3M;Spread MLP-Eonia;US_EU;Euribor Overnight;Euribor 1 Week;Euribor 1 Month;five days usd_eur;MA3 USD_EUR;MA5 USD_EUR;MA10 USD_EUR;MA30 USD_EUR;US_Yen;ma3 us_yen;ma5 us_yen;ma10 us_yen;ma30 us_yen;5 days US_YEN;EU_Yen;MA3 EU_YEN;MA5 EU_YEN;MA10 EU_YEN;MA30 EU_YEN;5 days EU_YEN;Japan current account;CPI Japan;GDP Japan;Unemployement Japan;10 years treasury bills japan;Deficit or Surplus Japan;government securities japan;Productivity Japan;Nikkei 225;M3 Japan;Debt Japan;Central bank discount rate ;EU_UK;MA3 EU_UK;MA5 EU_UK;MA10 EU_UK;MA30 EU_UK;5 days EU_UK;US_UK;MA3 US_UK;MA5 US_UK;MA10 US_UK;MA30 US_UK;5 days US_UK;UK current account;CPI UK;Productivity UK;M3 UK;Deficit UK;Debt UK;Unemployement UK;Discount rate UK;3 months UK;10 year maturity UK;GDP UK;FTSE100;Productivity NZ;CPI NZ;GDP NZ;Balance NZ;Discount rate NZ;10 year treasure bill NZ;Debt NZ;M3 NZ;Unemployment NZ;Treasury bills brasil;CPI Brasil;Discount rate Brasil;Debt Brasil;Deficit Brasil;M3 Brasil;Unemployement Brasil;Productivity Brasil;GDP Brasil;Trade Balance Brasil;Debt South Africa;Deficit South Africa;CPI South Africa;Unemployement South Africa;GDP South Africa;Total trade South Africa;Discount rate south africa;Productivity South Africa;M3 South Africa;10 years treasury bills south africa;Treasure bills South Africa;GDP Australia;CPI Australia;trade balance Australia;Productivity Australia;Unemployment Australia;Deficit Australia;Debt Australia;Discount rate Australia;M3 Australia;10 years Australia;6 months Australia;Unemployement Australia;GDP Norway;Unemployment Norway;Current Account Norway;Total industry production Norway;M3 Norway;6 month rate;10 year Norway;Discount rate Norway;CPI Norway;Debt PHP;Current account PHP;Unemployement PHP;CPI PHP;Deficit PHP;GDP PHP;NZD/BRL;MA3 NZD/BRL;MA5 NZD/BRL;MA10 NZD/BRL;MA30 NZD/BRL;5 DAYS NZD/BRL;AUD/NOK;MA3 AUD/NOK;MA5 AUD/NOK;MA10 AUD/NOK;MA30 AUD/NOK;5 DAYS AUD/NOK;PHP/ZAR;MA3 PHP/ZAR;MA5 PHP/ZAR;MA10 PHP/ZAR;MA30 PHP/ZAR;5 days PHP/ZAR\n';

% print values in column order
fid = fopen('C:\Python27\Lib\site-packages\xy\Projects\Data\plak_data_unaltered.csv','w');
 colcount = size(temp,2);
% fprintf(fid, head);
format = repmat('%.4f;',1,193);
fprintf(fid,[format, '%d\n'], temp.');

fclose(fid);