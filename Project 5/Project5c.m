%READ CSV FILE
%This creates a matrix without the headings, these are x(t) inputs  
clear, clc
str = 'VIX';
fileID = fopen([str '.csv']);
C = textscan(fileID, '%s%*f%*f%*f%*f%*f%f','HeaderLines',1,'Delimiter',',');
fclose(fileID);%This grabs the dates and adjusted closing price 

date = C{1,1}; %First cell contains dates
date_format= 'yyyy-mm-dd';  %used to convert to datenum 
date=datenum(date,date_format);

%This creates a matrix without the headings, these are y(t) inputs  
str2 = 'GSPC';
fileID = fopen([str2 '.csv']);
C2 = textscan(fileID, '%s%*f%*f%*f%*f%*f%f','HeaderLines',1,'Delimiter',',');
fclose(fileID);%This grabs the dates and adjusted closing price 

date2 = C2{1,1}; %First cell contains dates
date2=datenum(date2,date_format);



closing = C{1,2}; %Second cell contains closing values
closing2 = C2{1,2};

date=flipud(date); %reverse the order of date
closing=flipud(closing); %reverse the order of closing
date2=flipud(date2); %reverse the order of date
closing2=flipud(closing2); %reverse the order of closing


t1 = datenum('1995-01-04',date_format);%converts string date to serial date
%datestr(t1,date_format) %converts serial date to sting date

%find(date == t1)%locates indix for given serial date

t2 = datenum('2013-01-03',date_format);%converts string date to serial date
%datestr(t2,date_format) %converts serial date to sting date

ts1x = find(date == t1);%locates index for given serial date
ts2x = find(date == t2);%locates index for given serial date
ts1y = find(date2 == t1);%locates index for given serial date
ts2y = find(date2 == t2);%locates index for given serial date
%sometimes these yield errors because not all of the stocks are traded on
%the same dates



%By subtracting dates we can insure vectors of the same lenght, this might
%be a problem because not all stocks have the same number of trading days
deltat = ts2x-ts1x;
newdate = date(ts2x-deltat:ts2x);     % Extract the ith through the jth elements for x(t)
closingPx = closing(ts2x-deltat:ts2x);% Extract the ith through the jth elements 

newdate2 = date2(ts2y-deltat:ts2y);     % Extract the ith through the jth elements 
closingPy = closing2(ts2y-deltat:ts2y); % Extract the ith through the jth elements 

%Find variance by integrating over time period 
varx = (1/deltat)*trapz(newdate,closingPx.^2);
vary = (1/deltat)*trapz(newdate2,closingPy.^2);

rhoxy = (1/sqrt(varx*vary))*(1/(deltat))*trapz(newdate2,closingPx.*closingPy)%this does yield for the same x(t)



