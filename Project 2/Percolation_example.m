L = 3;
r = rand(L,L);
p = 0.6;
z = r<p; % This generates the binary array
[lw,num] = bwlabel(z,4);
img = label2rgb(lw);
image(img);
img = label2rgb(lw);
image(img);
