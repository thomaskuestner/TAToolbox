function [] = Save_Preprossed_DataAndPlots(dicom,corrected,gated,var_comp_takeover,p_value_ttest2,p_value_wilcox,p_value_friedman)
% This function allows the user to save the previously calculated central tendency tests along
% with the acutal TF- values in a plot of the previously selected comparisons

% There are 2 options: 1) If available: Plot of all 3 data types and the value of the Friedman-test
% 2) the resuls of the Wilcoxon- and T-Test along with the 2 data types applied against each other,
% which were previously selectted

load('feature_Names');
% Option to save Friedman-Test results (if available -> beforehand selection) 
% @ the path that the user gets to select on a prompt
if p_value_friedman ~= 0
    path1 = uigetdir();
    oldpath = cd(path1);
    folderName = 'All_Features';
    if ~exist(folderName, 'dir')
        mkdir(folderName);
    end
    var_fiedman_save = questdlg('Would you like to save your previously selected calculated Friedman-Tests and all 3 comparisons',...
        'Chose a path to save data','Yes','No','Yes');
    switch var_fiedman_save
        case 'Yes'
            counter = 1;
            for i = 1:42
                filename_plot = feature_Names{i,1};
                plot(1:14,dicom(:,i),'b',1:14,corrected(:,i),'r',1:14,gated(:,i),'g');
                title(filename_plot);
                text = sprintf('P-Wert des Friedman-Tests aller Datentypen: %f',p_value_friedman(counter));
                x_entry = sprintf(strcat('\n','All Features of Dicom, Corrected and Gated of all the volunteers','\n\n',text));
                xlabel(x_entry);
                ylabel('Value of the Texture Feature');
                legend('blue = Dicom','red = Corrected','green = Gated','Location','southeast')
                saveas(gcf,fullfile(path1,folderName,filename_plot),'png');
                close(figure);
                counter = counter + 1;
            end
    end
    close all;
end
counter = 1;
path = uigetdir();
second_path = cd(path);
% Saving the data of the beforehand selected comparisons of the two TF-comparisons
if strcmp(var_comp_takeover,'DicCorr') == 1
    for i = 1:42
        filename_plot = feature_Names{i,1};
        var_plottable = figure;
        plot(dicom(:,i),corrected(:,i),'bo');
        title(filename_plot);
        refline(1);
        grid on;
        pos = get(var_plottable,'Position');
        set(var_plottable,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
        pos = get(var_plottable,'Position');
        text_1 = sprintf('P-Wert des Wilcoxon-Tests der beiden Features: %f',p_value_wilcox(counter));
        text_2 = sprintf('P-Wert des T-Tests der beiden Features: %f',p_value_ttest2(counter));
        label_X_axis = 'PET- MoCo DICOM ';
        text_labeling_plot = sprintf(strcat(label_X_axis,'\n','Absolute Values for Texture Features of','\n',...
            '\n\n',text_2,'\n',text_1));
        label_Y_axis = 'PET- MoCo CORRECTED';
        xlabel(text_labeling_plot);
        ylabel(label_Y_axis);
        folderName = 'Dicom_and_Corrected';
        if ~exist(folderName, 'dir')
            mkdir(folderName);
        end
        saveas(gcf, fullfile(path,folderName,filename_plot),'png');
        close(var_plottable);
        counter = counter + 1;
    end
end
if strcmp(var_comp_takeover,'DicGat') == 1
    for i = 1:42
        filename_plot = feature_Names{i,1};
        var_plottable = figure;
        plot(dicom(:,i),gated(:,i),'bo');
        title(filename_plot);
        refline(1);
        grid on;
        pos = get(var_plottable,'Position');
        set(var_plottable,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
        pos = get(var_plottable,'Position');
        text_1 = sprintf('P-Wert des Wilcoxon-Tests der beiden Features: %f',p_value_wilcox(counter));
        text_2 = sprintf('P-Wert des T-Tests der beiden Features: %f',p_value_ttest2(counter));
        label_X_axis = 'PET- MoCo DICOM ';
        text_labeling_plot = sprintf(strcat(label_X_axis,'\n','Absolute Values for Texture Features of','\n',...
            '\n\n',text_2,'\n',text_1));
        label_Y_axis = 'PET- MoCo GATED';
        xlabel(text_labeling_plot);
        ylabel(label_Y_axis);
        folderName = 'Dicom_and_Gated';
        if ~exist(folderName, 'dir')
            mkdir(folderName);
        end
        saveas(gcf, fullfile(path,folderName,filename_plot),'png');
        close(var_plottable);
        counter = counter + 1;
    end
end
if strcmp(var_comp_takeover,'CorrGat') == 1
    for i = 1:42
        filename_plot = feature_Names{i,1};
        var_plottable = figure;
        plot(corrected(:,i),gated(:,i),'bo');
        title(filename_plot);
        refline(1);
        grid on;
        pos = get(var_plottable,'Position');
        set(var_plottable,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
        pos = get(var_plottable,'Position');
        text_1 = sprintf('P-Wert des Wilcoxon-Tests der beiden Features: %f',p_value_wilcox(counter));
        text_2 = sprintf('P-Wert des T-Tests der beiden Features: %f',p_value_ttest2(counter));
        label_X_axis = 'PET- MoCo CORRECTED';
        text_labeling_plot = sprintf(strcat(label_X_axis,'\n','Absolute Values for Texture Features of','\n',...
            '\n\n',text_2,'\n',text_1));
        label_Y_axis = 'PET- MoCo GATED';
        xlabel(text_labeling_plot);
        ylabel(label_Y_axis);
        
        folderName = 'Corrected_and_Gated';
        if ~exist(folderName, 'dir')
            mkdir(folderName);
        end
        saveas(gcf, fullfile(path,folderName,filename_plot),'png');
        close(var_plottable);
        counter = counter + 1;
    end
end
close all;
end
