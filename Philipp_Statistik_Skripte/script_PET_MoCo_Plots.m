% Preprocessing of the PET MoCo Data
struct = load('C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\05_Code\Philipp_Statistik_Skripte\MoCo_Corrected_Cell');
current_Data= struct.features(:,:,:);
counter = 1;
for l = 1:42
    for i = 1:3:42
        feature_value_1(counter) = current_Data{l,i,i};
        counter = counter + 1;
    end
    l = l + 1;
end
counter = 1;
%var_temp_dicom = feature_value_1;
final_output_dicom = reshape(feature_value_1,14,42);
for o = 1:42
    for j = 2:3:42
        feature_value_2(counter) = current_Data{o,j,j};
        counter = counter + 1;
    end
    o = o + 1;
end
counter = 1;
%var_temp_corr = feature_value_2;
final_output_corrected = reshape(feature_value_2,14,42);
for s = 1:42
    for d = 3:3:42
        feature_value_3(counter) = current_Data{s,d,d};
        counter = counter + 1;
    end
    s = s + 1;
end
%var_temp_gated = feature_value_3;
final_output_gated = reshape(feature_value_3,14,42);
clearvars i j l o s d counter struct

%% Printing the TFs Values
% Section for plotting of a comparison of 2 sets of Data. Usually the same
% Features with each other from 2 different sets of data
    var_plot_pairing = inputdlg(sprintf('1 = Dicom and Corrected\n2 = Dicom and Gated\n3 = Corrected and Gated\n4 = All 3 Datasets in one Plot\n'),'Please enter option for plots',1,{'Type either 1, 2, 3 or 4'});
    switch str2double(var_plot_pairing{1})
        case 1
            final_output_1 = final_output_dicom;
            final_output_2 = final_output_corr;
            label_X_axis = 'PET- MoCo DICOM';
            label_Y_axis = 'PET- MoCo CORRECTED';
            path_00 = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\First_Comp_DIC_vs_COR';
        case 2
            final_output_1 = final_output_dicom;
            final_output_2 = final_output_gated;
            label_X_axis = 'PET- MoCo DICOM';
            label_Y_axis = 'PET- MoCo GATED';
            path_00 = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\First_Comp_DIC_vs_GAT';
        case 3
            final_output_1 = final_output_corr;
            final_output_2 = final_output_gated;
            label_X_axis = 'PET- MoCo CORRECTED';
            label_Y_axis = 'PET- MoCo GATED';
            path_00 = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\First_Comp_COR_vs_GAT';
        case 4
            sorted_dicom = sort(final_output_dicom,'ascend');
            sorted_corr = sort(final_output_corr,'ascend');
            sorted_gated = sort(final_output_gated,'ascend');
            for j = 1:42
                counter = 1;
                load('feature_Names');
                filename_plot = feature_Names{j,1};
                var_plottable = figure; title(filename_plot); grid on;
                plot(1:14,final_output_dicom(:,j),'o',1:14,final_output_corr(:,j),'o',1:14,final_output_gated(:,j),'o');
                % ,1:14,sorted_dicom(:,j),'r-o',1:14,sorted_corr(:,j),'b-*',1:14,sorted_gated(:,j),'c-x'
                legend('DICOM','CORRECTED','GATED','Location','northwest');
                path_01 = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\Second_Comp_All';
                saveas(gcf, fullfile(path_01, filename_plot), 'pdf');
                close(var_plottable);
            end
    end
    load('feature_Names');
    if str2double(var_plot_pairing{1}) == 4
        return
    else 
        for i = 1:42
            filename_plot = feature_Names{i,1};
            var_plottable = figure;
            plot(final_output_1(:,i),final_output_2(:,i),'bo');
            title(filename_plot);
            refline(1); 
            grid on;
            pos = get(var_plottable,'Position');
            set(var_plottable,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
            pos = get(var_plottable,'Position');
            text_labeling_plot = sprintf(strcat('\n','Absolute Values for Texture Features','\n',label_X_axis));
            xlabel(text_labeling_plot); % x-axis label
            ylabel(label_Y_axis); % y-axis label
            saveas(gcf, fullfile(path_00, filename_plot), 'pdf');
            close(var_plottable);
        end
    end
    clearvars var_feature_name i j path_00 path_01
%%
% Plots for means and variances
m1 = mean(final_output_dicom);
m2 = mean(final_output_corrected);
m3 = mean(final_output_gated);
vh1 = m1./m2; % Ratio of the TFs
vh2 = m1./m3;
vh3 = m2./m3;
diff1 = m1-m2; % originals minus corrected
diff2 = m1-m3;
diff3 = m2-m3;
plot(vh1,'bx');
saveas(gcf,'Mean_Ratio_Dicom_Corrected','jpg');    

v1 = var(final_output_dicom);
v2 = var(final_output_corrected);
v3 = var(final_output_gated);
ratio1 = v1./v2;
ratio2 = v1./v3;
ratio3 = v2./v3;
plot(ratio1,'bx');
name = 'Variance_Ratio_Dicom_Corrected';
xlabel('Nummer der TFs (siehe Liste)');
ylabel('Wert des Verhältnisses')
saveas(gcf,name,'pdf'); 
saveas(gcf,name,'jpg');
close all
plot(ratio2,'bx');
name = 'Variance_Ratio_Dicom_Gated';
xlabel('Nummer der TFs (siehe Liste)');
ylabel('Wert des Verhältnisses')
saveas(gcf,name,'pdf'); 
saveas(gcf,name,'jpg');
close all
plot(ratio3,'bx');
name = 'Variance_Ratio_Corrected_Gated';
xlabel('Nummer der TFs (siehe Liste)');
ylabel('Wert des Verhältnisses')
saveas(gcf,name,'pdf'); 
saveas(gcf,name,'jpg');
close all
%% All the separate plots from Bartletts Tests for all 42 features
for n = 1:42
bruh = [final_output_dicom(:,n),final_output_corrected(:,n),final_output_gated(:,n)];
out = vartestn(bruh);
filename = strcat(feature_Names{n,:},' mit dem P-Wert = ',num2str(p_vals_bart(n)));
saveas(gcf,strcat(filename,'.jpg')); 
pause(4.0)
close all
end
%% Plot !!P- Value!! of Bartlett_Test(from each of the 3 sequences) of all 42 features
load('feature_Names');
counter = 1;
for n = 1:42
var_PET_data = [final_output_dicom(:,n),final_output_corrected(:,n),final_output_gated(:,n)];
[p,stats] = vartestn(var_PET_data,'TestType','Bartlett','Display','off');
p_vals_bart(counter) = p;
chisq_vals_bart(counter) = stats.chisqstat;
axislabel_plot = feature_Names{n,1};
counter = counter + 1;
end

axislabel_plot_chi = strcat('Chi-squared of all TFs compared');
axislabel_plot_p = strcat('P_values of all TFs compared');

plot(chisq_vals_bart,'bx') % Actual Plotting of Chi-squared
title('Chi- Squared values of Bartlett-Test of all TFs compared with the same ones')
ylabel('Chi-squared Value');
xlabel('Number of Textur Feature');
saveas(gcf, axislabel_plot_chi,'pdf');
saveas(gcf, axislabel_plot_chi,'jpg');
close all
plot(p_vals_bart,'bx'); % Actual Plotting of the p-values
title('P-Values of Bartlett-Test of all TFs compared with the same ones');
ylabel('P-Value');
xlabel('Number of Textur Feature');
saveas(gcf, axislabel_plot_p,'pdf');
saveas(gcf, axislabel_plot_p,'jpg');
close all
