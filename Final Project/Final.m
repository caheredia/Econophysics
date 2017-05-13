%READ CSV FILE
%This creates a matrix without the headings 
clear, clc
str = 'SPY';
fileID = fopen([str '.csv']);
C = textscan(fileID, '%s%*f%*f%*f%*f%*f%f','HeaderLines',1,'Delimiter',',');
fclose(fileID);

date = C{1,1}; %First cell contains dates
date_format= 'yyyy-mm-dd';  %used to convert to datenum 
date=datenum(date,date_format);


closing = C{1,2}; %Second cell contains closing values

date=flipud(date); %reverse the order of date
closing=flipud(closing); %reverse the order of date


%need first date in date array: date_1=date(1,1)
% give the number of elements in array numel(date, :, 1)

delta_t = 21;
%Define returns function. This For function steps through the date array
% and performs the returns alogoithm, saving it to an array called Returns
for m = delta_t+1:numel(date, :, 1) %starts with delta t and ends with number of elements in date array
    Returns(m) = (closing(m)-closing(m-delta_t))/closing(m-delta_t)*100;
end     


pos = Returns(Returns>0);%returns matrix with positive values
avgpos = mean(pos)
p = numel(pos, 1, :)/numel(Returns, 1, :)

neg = Returns(Returns<0);
avgneg = mean(neg)

b = (1+avgpos/100)/abs(avgneg/100)

q = 1-p; %probability of losing
k = (b*p-q)/b

avgreturns = mean(Returns)

drawdown=min(Returns(:)) % returns the minimum value in array: 

plot(date, Returns)
title(['Trailing Returns ' str ', Drawdown =' num2str(drawdown) ',\Delta t = ' num2str(delta_t), ', R_{avg} =', num2str(avgreturns)])
ylabel('%')
xlabel('Date')
datetick('x','mm/dd/yyyy', 'keepticks')
axis ([date(delta_t) max(date(:)) min(Returns(:)) max(Returns(:))])

