%% prework
clear all;clc;

%% 
filename_plot='Outlier_Boxplots';
h=figure;
for i=1:2
ROI=i;

if ROI==1
    rawdata = load('summarized_data_of_all_Patients_ROI1.mat');
else
    rawdata = load('summarized_data_of_all_Patients_ROI2.mat');
end
ax1=subplot(1,2,i);
hold on;
roi_sizes=rawdata.data.all_Patients_ROI_sizes;
roi_bp=boxplot(roi_sizes,'Whisker',1,'Labels','-');
median_ROIX = median(roi_sizes);
std_ROIX = round(std(roi_sizes),0);
outlier_ROIX = findobj(roi_bp,'Tag','Outliers');outlier_ROIX = get(outlier_ROIX,'YData'); 
num_outlier_ROIX=length(outlier_ROIX);
grid on;
grid minor;

if ROI==1
    ylim([1800 7500]);
    set(gca,'YTick',0:200:10000);
    title('ROI 1 - rechter Leberlappen')
else
    ylim([50 300]);
    set(gca,'YTick',0:10:500);
    title('ROI 2 - linker Leberlappen')
end
x_text_label=strcat('Median = ',num2str(median_ROIX), ' Voxel');
x_text_label=strcat(x_text_label,'\r\n','Standardabweichung = ', num2str(std_ROIX), ' Voxel');
x_text_label=strcat(x_text_label,'\r\n','Ausreißeranzahl = ', num2str(num_outlier_ROIX));
x_text_label=sprintf(x_text_label);
xlabel(x_text_label);
end
set(h,'Units','Inches');
pos = get(h,'Position');
%set(h,'position',[pos(1:2)/4 pos(3:4)*5])
set(h, 'Units', 'normalized', 'Position', [0.3, 0.2, 0.5, 0.5]);
%set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,filename_plot,'-bestfit','-dpdf','-r0') % ,'-bestfit'



