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
bankroll = 5000; %Assume a bankroll of $5000
for m = delta_t+1:numel(date, :, 1) %starts with delta t and ends with number of elements in date array
    Returns(m) = (closing(m)-closing(m-delta_t))/closing(m-delta_t)*100;
    
    pos = Returns(Returns>0);%returns matrix with positive values
    avgpos(m) = mean(pos);%avg of positive values 
    p(m) = numel(pos, 1, :)/numel(Returns, 1, :); %wins / (total returns)
    q(m) = 1-p(m); %probability of losing
    
    neg = Returns(Returns<0);
    avgneg(m) = mean(neg);
    
    b(m) = (1+avgpos(m)/100)/abs(avgneg(m)/100); %win to loss ratio 
    f(m) = (b(m)*p(m)-q(m))/b(m); 
    f(f<0)=0;%make negative values of f equal to zero.
    f(isnan(f))=0;%make NaN values of f equal to zero.
    
    bankroll = (bankroll -f(m)*bankroll) + f(m)*bankroll*(1+Returns(m)/100)-9;%need to annualize, trading fee assessed  
    br(m) = bankroll; 
    br(br<0)=0;%make negative values of br equal to zero.


end     


avgreturns = mean(Returns)

drawdown=min(Returns(:)) % returns the minimum value in array: 

figure(1)
plot(date, Returns)
title(['Trailing Returns ' str ', Drawdown =' num2str(drawdown) ',\Delta t = ' num2str(delta_t), ', R_{avg} =', num2str(avgreturns), '%'])
ylabel('%')
xlabel('Date')
datetick('x','mm/dd/yyyy', 'keepticks')
axis ([date(delta_t) max(date(:)) min(Returns(:)) max(Returns(:))])

figure(2)
plot(date, f)
title(['Kelly fraction ' str ', Drawdown =' num2str(drawdown) ',\Delta t = ' num2str(delta_t), ', R_{avg} =', num2str(avgreturns)])
ylabel('f')
xlabel('Date')
datetick('x','mm/dd/yyyy', 'keepticks')
axis ([date(delta_t) max(date(:)) min(f(:)) max(f(:))])

figure(3)
plot(date, br)
title(['Bankroll  ' str ', Drawdown =' num2str(drawdown) ',\Delta t = ' num2str(delta_t), ', R_{avg} =', num2str(avgreturns)])
ylabel('br')
xlabel('Date')
datetick('x','mm/dd/yyyy', 'keepticks')
axis ([date(delta_t) max(date(:)) min(br(:)) max(br(:))])
%set(gca, 'Yscale', 'log')

