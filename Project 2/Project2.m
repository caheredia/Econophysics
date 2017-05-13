%You will assume 1 trade (1 cluster) on each time step, 
%and you will use 10,000,000 time steps
time_step = 10.0e6;

%Need to generate a random number, p,  between 0 and 1
p = rand(time_step,1);
t = 2.857;
s = (p).^(-1/t); %s is the size of the trader-cluster

r = rand(time_step,1);
r2 = rand(); 
phi = r<r2; % This generates a random binary array
phi = 2*phi - 1; %This simple procedure produces a matrix with +1, and -1 

delta_P = s.*phi;%multiplies two vectros element by element
mu = mean(delta_P);
sigma = std(delta_P);


%figure(1)
x = (-200:.1:200);
new = histc(delta_P,x);
%plot(x,new)
title(['Histogram of 10e6 price changes,','\mu =', num2str(mu),'\sigma =', num2str(sigma),'\tau =', num2str(t)])
ylabel('H(\Delta P)')
xlabel('\Delta P')
set(gca, 'yscale', 'log')
new1 = log10(new);


HG = (time_step)*exp(-(1/2)*((x-mu)/(sigma)).^2)/(sigma*sqrt(2*pi));
HG2 = log10(transpose(HG));
new2 = HG2>0;
HG2 = HG2.*new2;

figure(2)
plot(x,HG2,x,new1)
title(['Histogram of 10e6 price changes,', '\mu =', num2str(mu),'\sigma =', num2str(sigma),'\tau =', num2str(t)])
ylabel('Log_{10} H(\Delta P)')
xlabel('\Delta P')
legend('H(\Delta P`)','H(\Delta P)');
%set(gca, 'Yscale', 'log')