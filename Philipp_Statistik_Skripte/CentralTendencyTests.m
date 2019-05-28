function [p_value_ttest2,p_value_wilcox,p_value_friedman,var_comp_takeover] = CentralTendencyTests(dicom,corrected,gated)
% Script for chosing a comparison of 2 Datasets
load('feature_Names');
var_carryover = questdlg('Which 2 sets of data would you like to have compared with one another?',...
    'Query for TF-comparison',...
    'Dicom and Corrected','Dicom and Gated','Corrected and Gated','Dicom and Corrected');
switch var_carryover
    case 'Dicom and Corrected'
        var4comp = 1;
    case 'Dicom and Gated'
        var4comp = 2;
    case 'Corrected and Gated'
        var4comp = 3;
end
if var4comp == 1
    counter = 1;
    for i = 1:42
        [h,p_value_ttest2(counter)] = ttest2(dicom(:,i),corrected(:,i));
        p_value_wilcox(counter) = ranksum(dicom(:,i),corrected(:,i));
        counter = counter + 1;
    end
    p_value_friedman = 0;
    var_comp_takeover = 'DicCorr';
end
if var4comp == 2
    counter = 1;
    for i = 1:42
        [h,p_value_ttest2(counter)] = ttest2(dicom(:,i),gated(:,i));
        p_value_wilcox(counter) = ranksum(dicom(:,i),gated(:,i));
        counter = counter + 1;
    end
    p_value_friedman = 0;
    var_comp_takeover = 'DicGat';
end
if var4comp == 3
    counter = 1;
    for i = 1:42
        [h,p_value_ttest2(counter)] = ttest2(corrected(:,i),gated(:,i));
        p_value_wilcox(counter) = ranksum(corrected(:,i),gated(:,i));
        counter = counter + 1;
    end
    p_value_friedman = 0;
    var_comp_takeover = 'CorrGat';
end

option = questdlg('Would you like to also have the Friedman-Test applied?','Friedman-Test nötig?',...
    'Yes','No','No');
switch option
    case 'Yes'
        var_Fr_dspl = 1;
    case 'No'
        var_Fr_dspl = 2;
end
if var_Fr_dspl == 1
    counter = 1;
    for i = 1:42
        temp_p = [dicom(:,i),corrected(:,i),gated(:,i)];
        p_value_friedman(counter) = friedman(temp_p);
        counter = counter + 1;
    end
end
close all;
end