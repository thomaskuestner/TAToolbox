y=[408,161,71,226,39,33,44,900,173,78,50,94,134,224,93,107,346,157,65,211,245,62,113,166,319,55,157,61,820,742,253,441,41,733,162,238,63,25,26,128,416,73];
x=1:1:42;
plot(x,y,'bo');
hold on;
plot(8,900,'ro');
xticks(1:1:42);
ylim([0 900]);
yticks(0:50:900);
grid on;
string_for_x_label=sprintf('TFs substituted by numbers');
xlabel(string_for_x_label,'FontSize', 15);
ylabel('sum of coefficients of variation of ROI 1 and ROI 2', 'FontSize', 15);

