%% generate plot data

x=1:1:10;
y1=x;
y2=x.^2;
y3=x.^3;
y4=x.^4;

subplot(2,4,[1 2 3])
plot(x,y1);
subplot(2,4,[4])
plot(x,y2)

subplot(2,4,[5 6 7])
plot(x,y3);
subplot(2,4,[8])
plot(x,y4)
