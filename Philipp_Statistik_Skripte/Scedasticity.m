function [p_value,failed_null_hypothesis] = Scedasticity(dicom,corrected,gated,type,all_data)
% This function calculates the scedasticty-tests after Bartlett and Levene
% depending on the users input. In addition one can chose to have the (rather meaningless)
% plot from all TFs compared in a test. Both options can be saved, if the
% user wishes this and also is asked to select a path on his machine.
load('feature_Names');
% Chose The directory of where you want to save the data (if you want to save at all...)
ans_for_saving = questdlg('Would you like the scedasticity-plots being saved?','Query for saving plots',...
    'Yes','No','Yes');
switch ans_for_saving
    case 'Yes' % You save the plots of the comparisons
        var_for_saveing = 1;
    case 'No' % If no is klicked, the plots pop up and get closed without being saved
        var_for_saveing = 0;
end
% chose path to save test results (boxplots)
path = uigetdir();
oldpath = cd(path);
folderName = fullfile(path,'Scedasticity_Test',type);
if ~exist(folderName, 'dir')
    mkdir(folderName);
end
p_value = zeros(1,42);
% Bartlett Test being applied
if strcmp(type,'Bartlett') == 1
    counter = 1;
    failed_null_hypothesis = zeros(1,42);
    for n = 1:42
        var_safe_temporary = [dicom(:,n),corrected(:,n),gated(:,n)];
        p_value(counter) = vartestn(var_safe_temporary);
        var_names = feature_Names{n,1};
        title(var_names);
        xlabel({p_value(counter)});
        if var_for_saveing == 1
            saveas(gcf,fullfile(folderName,var_names),'png');
        end
        if p_value(counter) < 0.05
            failed_null_hypothesis(n) = p_value(counter);
        end
        close all;
        counter = counter + 1;
    end
    failed_null_hypothesis = failed_null_hypothesis';
    % Plot of all the TF-values of the test
    % They are saved if the saving-option at the beginning is selected
    plot(p_value,'bo');
    ylabel('P-Wert');
    xlabel('Nummer des Textur Features');
    if var_for_saveing == 1
        saveas(gcf,fullfile(folderName,'All_P-Values_of_all_TFs'),'png');
    end
    close all;
    % Levene Quadratic Test being applied if one types in the right string
elseif type == 'Levene_quad'
    counter = 1;
    failed_null_hypothesis = zeros(1,42);
    for n = 1:42
        var_safe_temporary = [dicom(:,n),corrected(:,n),gated(:,n)];
        p_value(counter) = vartestn(var_safe_temporary,'TestType','LeveneQuadratic');
        var_names = feature_Names{n,1};
        title(var_names);
        xlabel({p_value(counter)});
        if var_for_saveing == 1
            saveas(gcf,fullfile(folderName,var_names),'png');
        end
        if p_value(counter) < 0.05
            failed_null_hypothesis(n) = p_value(counter);
        end
        close all;
        counter = counter + 1;
    end
    % Plot of all the TF-values of the test
    % They are saved if the saving-option at the beginning is selected
    plot(p_value,'bo');
    ylabel('P-Wert');
    xlabel('Nummer des Textur Features');
    if var_for_saveing == 1
        saveas(gcf,fullfile(folderName,'All_P-Values_of_all_TFs'),'png');
    end
    close all;
    % Levene Absolute Test, if one gives the correct string in the function
elseif type == 'Levene_abs'
    counter = 1;
    failed_null_hypothesis = zeros(1,42);
    for n = 1:42
        var_safe_temporary = [dicom(:,n),corrected(:,n),gated(:,n)];
        p_value(counter) = vartestn(var_safe_temporary,'TestType','LeveneAbsolute');
        var_names = feature_Names{n,1};
        title(var_names);
        xlabel({p_value(counter)});
        if var_for_saveing == 1
            saveas(gcf,fullfile(folderName,var_names),'png');
        end
        if p_value(counter) < 0.05
            failed_null_hypothesis(n) = p_value(counter);
        end
        close all;
        counter = counter + 1;
    end
    % Plot of all the TF-values of the test
    % They are saved if the saving-option at the beginning is selected
    plot(p_value,'bo');
    ylabel('P-Wert');
    xlabel('Nummer des Textur Features');
    if var_for_saveing == 1
        saveas(gcf,fullfile(folderName,'All_P-Values_of_all_TFs'),'png');
    end
    close all;
    % Catching errors regarding wrong inputs
else
    error('You must chose one of the strings which represent the three possible tests!');
end
%% Only saving the plots of all 3 seperate PET-Types
% In order to trigger this sub-section set the last input-variable to 1
if all_data == 1
    path_all = uigetdir();
    oldpath = cd(path_all);
    bartlett_dicom_only = vartestn(dicom(:,:));
    saveas(gcf,fullfile(path_all,'All_Values_from_Bartlett-Test_of_DICOM'),'png');
    close all;
    bartlett_corr_only = vartestn(corrected(:,:));
    saveas(gcf,fullfile(path_all,'All_Values_from_Bartlett-Test_of_CORRECTED'),'png');
    close all;
    bartlett_gated_only = vartestn(gated(:,:));
    saveas(gcf,fullfile(path_all,'All_Values_from_Bartlett-Test_of_GATED'),'png');
    close all;
end
end