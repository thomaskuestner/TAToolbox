ROI=1; % 1 or 2

if ROI==1
    rawdata = load('summarized_data_of_all_Patients_ROI1.mat');
else
    rawdata = load('summarized_data_of_all_Patients_ROI2.mat');
end

roi_sizes=rawdata.data.all_Patients_ROI_sizes;
boxplot(roi_sizes,'Whisker',1);