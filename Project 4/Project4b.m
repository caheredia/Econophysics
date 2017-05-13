%READ CSV FILE
%This creates a matrix without the headings 
clear, clc
str = 'SWISX';
fileID = fopen([str '.csv']);
C = textscan(fileID, '%s%*f%*f%*f%*f%*f%f','HeaderLines',1,'Delimiter',',');
fclose(fileID);%This grabs the dates and adjusted closing price 

date = C{1,1}; %First cell contains dates
date_format= 'yyyy-mm-dd';  %used to convert to datenum 
date=datenum(date,date_format);


closing = C{1,2}; %Second cell contains closing values

date=flipud(date); %reverse the order of date
closing=flipud(closing); %reverse the order of date


%need first date in date array: date_1=date(1,1)
% give the number of elements in array numel(date, :, 1)

delta_t = 1;
%Define delta_P function. This For loop function steps through the date array
% and performs the delta_P alogorithm, saving it to an array called delta_P
for m = delta_t+1:numel(date, :, 1)%starts with delta_t and ends with number of elements in date array
    delta_P(m) = log(closing(m))-log(closing(m-delta_t));
end     
mu = mean(delta_P);
sigma = std(delta_P);

x = linspace(-.5,.5,numel(delta_P, 1, :));
% generates a row vector y of n points linearly spaced between and including a and b
% this is necessary for ploting HG
%creates bin sizes
new = histc(delta_P,x);

P = sort(delta_P);
HG = (2)*exp(-(.5)*((P-mu)/(sigma)).^2)/(sigma*sqrt(2*pi));


figure(2)
bar(x,new/trapz(x,new));hold on %Divide by area to normalize plot 
plot(P,HG,'r');hold off
title(['Histogram of price changes for 10yrs, ',str,',','\mu =', num2str(mu),'\sigma =', num2str(sigma)])
legend('H(\Delta P)','H(\Delta P`)');
ylabel('H(\Delta P)')
xlabel('log({P_t}/{P_{t-1}})')
axis ([min(x(:)) max(x(:)) 0 max(HG(:))])

