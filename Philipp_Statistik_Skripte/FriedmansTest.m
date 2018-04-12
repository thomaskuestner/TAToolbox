function [p_friedman] = FriedmansTest(dicom,corrected,gated)
load('feature_Names');
path = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\Friedman_final';
counter = 1;
for n = 1:42
temp_save = [dicom(:,n),corrected(:,n),gated(:,n)];
p_friedman(counter) = friedman(temp_save);
filename_plot = feature_Names{n,1};
saveas(gcf, fullfile(path,filename_plot),'png');
close all;
counter = counter + 1;
end
end