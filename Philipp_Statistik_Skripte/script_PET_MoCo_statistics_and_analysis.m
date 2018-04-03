%% Preprocessing 
% Skript for statistical analysis with the Radiomics Toolbox features from PET MoCo- Data
clear vars
%%% -> Abfrage f�r die Abfrage der flags programmieren
% Preprocessing will be executed regardless the intention running this script (0th section)
flag_print_preprocessed_plots = 0; % Plotting of preprocessed data (1st section)
flag_statistics = 1; % Running statistical methods (2nd Section)
flag_plot_stats = 0; % Plotting of results of statistical analysis (3rd Section)

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

clearvars i k j l o d s counter 

%% Printing the TFs Values
% Section for plotting of a comparison of 2 sets of Data. Usually the same
% Features with each other from 2 different sets of data
if flag_print_preprocessed_plots == 1
    
var_plot_pairing = inputdlg(sprintf('1 = Dicom and Corrected\n2 = Dicom and Gated\n3 = Corrected and Gated\n '),'Please enter option for plots',1,{'Type either 1, 2 or 3'}); 
switch str2double(var_plot_pairing{1})
    case 1
    final_output_1 = final_output_dicom;
    final_output_2 = final_output_corr;
    label_X_axis = 'PET- MoCo DICOM';
    label_Y_axis = 'PET- MoCo CORRECTED';
    case 2
    final_output_1 = final_output_dicom;
    final_output_2 = final_output_gated;
    label_X_axis = 'PET- MoCo DICOM';
    label_Y_axis = 'PET- MoCo GATED';
    case 3
    final_output_1 = final_output_corr;
    final_output_2 = final_output_gated;
    label_X_axis = 'PET- MoCo CORRECTED';
    label_Y_axis = 'PET- MoCo GATED';
end
    
    load('feature_Names');
    counter = 1;
    for i = 1:42 
    var_feature_name(counter) = feature_Names(i,:);
    filename_plot = feature_Names{i,1};
    var_plottable = figure;
    plot(final_output_1(:,i),final_output_2(:,i),'bo');
        title(filename_plot);
        refline(1);
        grid on;
        set(var_plottable,'Units','Inches');
        pos = get(var_plottable,'Position');
        set(var_plottable,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
        pos = get(var_plottable,'Position');
        text_labeling_plot = sprintf(strcat('\n','Absolute Values for Texture Features','\n',label_X_axis));
        xlabel(text_labeling_plot); % x-axis label
        ylabel(label_Y_axis); % y-axis label
        print(var_plottable,filename_plot,'-dpdf','-r0'); % Safe .PDFs of TF-values
    pause(1.0); % Time to look at the plot for the user 
    close(var_plottable);
    counter = counter + 1;
    end
end
%% Statistical Methods
% 1. Test von DICOM- und CORRECTED- Daten
% T-Test -> Wenn tTest versagt -> Wilcoxon

if flag_statistics == 1
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
clearvars i counter

end
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