%READ CSV FILE
%This creates a matrix without the headings 
clear, clc
str = 'VIX';
fileID = fopen([str '.csv']);
C = textscan(fileID, '%s%*f%*f%*f%*f%*f%f','HeaderLines',1,'Delimiter',',');
fclose(fileID);%This grabs the dates and adjusted closing price 

date = C{1,1}; %First cell contains dates
date_format= 'yyyy-mm-dd';  %used to convert to datenum 
date=datenum(date,date_format);


closing = C{1,2}; %Second cell contains closing values

date=flipud(date); %reverse the order of date
closing=flipud(closing); %reverse the order of date

%a. You compute the ratio of the price on day i to the price on day i-1.
%b. Then compute the natural Log of this ratio.
%c. Then square it.

%Define delta_P function. This For loop function steps through the date array
% and performs the delta_P alogorithm, saving it to an array called delta_P

for i = 23:numel(date, :, 1)%starts on day 22 and ends with number of elements in date array
    
    %d. Then repeat a.-c. with the ratio of day i-1 to day i-2 and add to the term from a.-c.
    %e. Keep repeating this process until you have added up 21 terms over the last 21 trading
    %days (counting today as the 1st day ? thus today is i=1).
    sum_P =0;
    for j = 1:21 %21 days 
        delta_P(i) = log(closing(i-j)/closing(i-j-1))^2;
        sum_P = sum_P + delta_P(i);
    end
    V(i) = sum_P;
end     

%f. Now divide by 21 to compute a ratio.
%g. ?Annualize? the result by multiplying by 252 trading days = 1 year. 
%h. Take the square root.
V(i) = sqrt((252/21)*V(i));

figure(1)
plot(date,V)
title(['Historical volatility of ', str])
ylabel('V')
xlabel('Date')
datetick('x','mm/dd/yyyy', 'keepticks')
hold
axis ([min(date(:))+23 max(date(:))-1 min(V(:)) max(V(:))])