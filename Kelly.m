%Let's solve earnings for a coin flip bet: heads you double your bet; tails
%you lose. 
clear, clc
%First let's generate a matrix with random heads and tails, 1's and -1's. 
flips = 100;
r = rand(flips,1); 
r = r<0.5; % This generates a binary array
r = 3*r - 1; %This simple procedure produces a matrix with +2, and -1
m = mean(r) %calculate the mean of flips, should be 0.5

%Define Kelly Criterion
 b = 2; %net odds you could win on wager
 p = .5; %is the probability of winning
 q = 1-p; %probability of losing
 k = (b*p-q)/b;
 
%Let's simulate different betting strategies

%(1) Assume no strategy, bet 100% assets
a_purse(1) = 100;  %initial bank roll
for n = 2:flips %Steps through all the coin tosses
a_purse(n) = a_purse(n-1) + a_purse(n-1)*r(n);
end 
a_purse(flips);


%(2) bet 50% assets
b_purse(1) = a_purse(1);  %initial bank roll
for n = 2:flips %Steps through all the coin tosses
b_purse(n) = b_purse(n-1) + .5*b_purse(n-1)*r(n);
end 
b_purse(flips);


%(3) bet k assets
c_purse(1) = a_purse(1);  %initial bank roll
for n = 2:flips %Steps through all the coin tosses
c_purse(n) = c_purse(n-1) + k*c_purse(n-1)*r(n);
end 
c_purse(flips);

figure(1)
tosses = (1:1:flips); %generates number of tosses
plot(tosses,a_purse,tosses,b_purse,tosses,c_purse)
title('Bankroll growth with Kelly fraction,')
ylabel('Bankroll [$]')
xlabel('Coin flips')
legend('100%','50%','k');

figure(2)
tosses = (1:1:flips); %generates number of tosses
plot(tosses,a_purse,tosses,b_purse,tosses,c_purse)
title('Bankroll growth with Kelly fraction,')
ylabel('Log(Bankroll)')
xlabel('Coin flips')
set(gca, 'yscale', 'log')
legend('100%','50%','k');
