%% Preprocessing 
% Skript for statistical analysis with the Radiomics Toolbox features from PET MoCo- Data
clear vars
%%% -> Abfrage fuer die Abfrage der flags programmieren
% Preprocessing will be executed regardless the intention running this script (0th section)
flag_print_preprocessed_plots = 0; % Plotting of preprocessed data (1st section)
flag_statistics = 0; % Running statistical methods (2nd Section)
flag_plot_stats = 0; % Plotting of results of statistical analysis (3rd Section)
flag_stats_que = 0;

struct = load('C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\05_Code\Philipp_Statistik_Skripte\MoCo_Corrected_Cell');
current_Data= struct.features(:,:,:);
counter = 1;
datatype = inputdlg(sprintf('1 = all TFs sorted from all the 3 different types of data (Each Datatype will be sorted after its TFs)\n'),'Please enter one of the below discribed numbers',1,{'1'}); 

switch str2double(datatype{1})
        case 1 % Loop for same TFs of all 'Corrected Files' and for same TFs of all 'DICOM files'/ default
            for l = 1:42
                for i = 1:3:42
                feature_value_1(counter) = current_Data{l,i,i};
                counter = counter + 1;
                end
            l = l + 1;
            end
    counter = 1;    
    var_temp_dicom = feature_value_1; 
    final_output_dicom = reshape(feature_value_1,14,42);
            for o = 1:42
                for j = 2:3:42
                feature_value_2(counter) = current_Data{o,j,j};
                counter = counter + 1;
                end
                o = o + 1;
            end
    counter = 1;
    var_temp_corr = feature_value_2;
    final_output_corr = reshape(feature_value_2,14,42);
            for s = 1:42
                for d = 3:3:42
                feature_value_3(counter) = current_Data{s,d,d};
                counter = counter + 1;
                end
                s = s + 1;
            end
    counter = 1;
    var_temp_gated = feature_value_3;
    final_output_gated = reshape(feature_value_3,14,42);
    
    % case 2
    % Here one can add other preprocessing cases        
            
    otherwise
        error('Wrong Input!');
end

clearvars i k j l o d s counters struct

%% Printing the TFs Values
% Section for plotting of a comparison of 2 sets of Data. Usually the same
% Features with each other from 2 different sets of data
if flag_print_preprocessed_plots == 1
% Implement new cases for paired outputs!!!!
var_plot_pairing = inputdlg(sprintf('1 = Dicom and Corrected\n2 = Dicom and Gated\n3 = Corrected and Gated\n '),'Please enter option for plots',1,{'Type either 1, 2 or 3'}); 
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
end
    load('feature_Names');
    counter = 1;
    for i = 1:42 
    var_feature_name(counter) = feature_Names(i,:);
    filename_plot = feature_Names{i,1};
    var_plottable = figure;
    plot(final_output_1(:,i),final_output_2(:,i),'bo');
    title(filename_plot); refline(1); grid on;
    set(var_plottable,'Units','Inches');
    pos = get(var_plottable,'Position');
    set(var_plottable,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    pos = get(var_plottable,'Position');
    text_labeling_plot = sprintf(strcat('\n','Absolute Values for Texture Features','\n',label_X_axis));
    xlabel(text_labeling_plot); % x-axis label
    ylabel(label_Y_axis); % y-axis label
    saveas(gcf, fullfile(path_00, filename_plot), 'pdf');
    close(var_plottable);
    counter = counter + 1;
    end
    clearvars var_feature_name i
    
    sorted_dicom = sort(final_output_dicom,'ascend');
    sorted_corr = sort(final_output_corr,'ascend');
    sorted_gated = sort(final_output_gated,'ascend');
    for j = 1:42
    counter = 1;
    load('feature_Names');
    var_feature_name(counter) = feature_Names(j,:);
    filename_plot = feature_Names{j,1};
    var_plottable = figure; title(filename_plot); grid on;
    plot(1:14,final_output_dicom(:,j),'o',1:14,final_output_corr(:,j),'o',1:14,final_output_gated(:,j),'o');
 % ,1:14,sorted_dicom(:,j),'r-o',1:14,sorted_corr(:,j),'b-*',1:14,sorted_gated(:,j),'c-x'
    legend('DICOM','CORRECTED','GATED','Location','northwest');
    path_01 = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\Second_Comp_All';
    saveas(gcf, fullfile(path_01, filename_plot), 'pdf'); 
    close(var_plottable);
    counter = counter + 1;
    end  
end
    clearvars j path_00 path_01
%% Statistical Methods
% 1. Test von DICOM- und CORRECTED- Daten
% T-Test -> Wenn tTest versagt -> Wilcoxon

if flag_statistics == 1
    if flag_stats_que == 1
var_stat_compare = inputdlg(sprintf('1 = Dicom and Corrected\n2 = Dicom and Gated\n3 = Corrected and Gated\n '),'Please enter option for plots',1,{'Type either 1, 2 or 3'}); 
switch str2double(var_stat_compare{1})
    case 1
    final_output_1 = final_output_dicom;
    final_output_2 = final_output_corr;
    case 2
    final_output_1 = final_output_dicom;
    final_output_2 = final_output_gated;
    case 3
    final_output_1 = final_output_corr;
    final_output_2 = final_output_gated;
end
% T-Test for the two chosen Datasets    
counter = 1; 
h_ttest = zeros(1,42);
p_ttest = zeros(1,42);
for i = 1:42
    [h_ttest(counter),p_ttest(counter)] = ttest(final_output_1(:,i),final_output_2(:,i));
    counter = counter + 1;
end
clearvars i counter
% Wilcoxon- Test (unabhaengig vom TTest der ersten Stufe)    
counter = 1;
h_wilcox = zeros(1,42);
p_wilcox = zeros(1,42);
for i = 1:42
if h_ttest(:,i) == 0
   [p_wilcox(counter),h_wilcox(counter)] = ranksum(final_output_1(:,i),final_output_2(:,i)); 
   counter = counter + 1;
end
end
    end
% Bartlett Test    
clearvars i counter
counter = 1;

mean_dicom = mean(final_output_dicom); % Calc. and safe of means
% save('Mittelwert_DICOM','mean_dicom');
mean_corr = mean(final_output_corr);
% save('Mittelwert_CORRECTED','mean_corr');
mean_gated = mean(final_output_gated);
% save('Mittelwert_GATED','mean_gated');

variance_dicom = var(final_output_dicom); % Calc. and saving of variances
% save('Varianz_DICOM','variance_dicom');
variance_corr = (final_output_corr);
% save('Varianz_CORRECTED','variance_corr');
variance_gated = (final_output_dicom);
% save('Varianz_GATED','variance_gated');

%%%% Hier weiter: Was kann ich machen (Diff. oder Verh. etc. f?r Skedasdiz.)
bartlett_dicom = vartestn(final_output_dicom(:,:));
bartlett_corr = vartestn(final_output_corr(:,:));
bartlett_gated = vartestn(final_output_gated(:,:));
end
%https://de.mathworks.com/help/stats/friedman.html
%https://de.wikipedia.org/wiki/Friedman-Test_(Statistik)
%% Plotting of statistical results
if flag_plot_stats == 1 % Plotting of statistic- finding
%   
bar(p_wilcox) 
set(gca,'XTickLabel',{feature_Names}) 
%
vis_ttest = [h_ttest',p_ttest'];
figure(1)
plot(vis_ttest, 'o');
figure(2)
bar(p_ttest);

end