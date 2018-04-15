function [p_value] = Scedasticity(dicom,corrected,gated,type,all_data)
% Speicherverzeichniss(e) auf 'final' erweitern!
load('feature_Names');
p_value = zeros(1,42);
if type == 'bartlett'
    counter = 1;
    for n = 1:42
        var_safe_temporary = [dicom(:,n),corrected(:,n),gated(:,n)];
        p_value(counter) = vartestn(var_safe_temporary);
        var_names = feature_Names{n,1};
        path = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\Bartlett_einzelne_Features_final';
        saveas(gcf,fullfile(path,var_names),'png');
        close all;
        counter = counter + 1;
    end
    plot(p_value,'bo');
    ylabel('P-Wert');
    xlabel('Nummer des Textur Features');
    path = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\Bartlett_einzelne_Features_final';
    saveas(gcf,fullfile(path,'All_P-Values_of_all_TFs'),'png');
elseif type == 'levene_quad'
    counter = 1;
    for n = 1:42
        var_safe_temporary = [dicom(:,n),corrected(:,n),gated(:,n)];
        p_value(counter) = vartestn(var_safe_temporary,'TestType','LeveneQuadratic');
        var_names = feature_Names{n,1};
        path = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\LeveneQuad_einzelne_Features_final';
        saveas(gcf,fullfile(path,var_names),'png');
        close all;
        counter = counter + 1;
    end
    plot(p_value,'bo');
    ylabel('P-Wert');
    xlabel('Nummer des Textur Features');
    path = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\LeveneQuad_einzelne_Features_final';
    saveas(gcf,fullfile(path,'All_P-Values_of_all_TFs'),'png');
elseif type == 'levene_abs'
    counter = 1;
    for n = 1:42
        var_safe_temporary = [dicom(:,n),corrected(:,n),gated(:,n)];
        p_value(counter) = vartestn(var_safe_temporary,'TestType','LeveneAbsolute');
        var_names = feature_Names{n,1};
        path = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\LeveneAbs_einzelne_Features_final';
        saveas(gcf,fullfile(path,var_names),'png');
        close all;
        counter = counter + 1;
    end
    plot(p_value,'bo');
    ylabel('P-Wert');
    xlabel('Nummer des Textur Features');
    path = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\LeveneAbs_einzelne_Features_final';
    saveas(gcf,fullfile(path,'All_P-Values_of_all_TFs'),'png');
    close all;
    %% Only saving the plots of all 3 seperate PET-Types
    % [p_value_brown,stats] = vartestn(grades,'TestType','BrownForsythe','Display','off')
    if all_data == 1
        path = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\Bartlett_alle_Features';
        bartlett_dicom_only = vartestn(dicom(:,:));
        saveas(gcf,fullfile(path,'All_Values_from_Bartlett-Test_of_DICOM'),'png');
        close all;
        bartlett_corr_only = vartestn(corrected(:,:));
        saveas(gcf,fullfile(path,'All_Values_from_Bartlett-Test_of_CORRECTED'),'png');
        close all;
        bartlett_gated_only = vartestn(gated(:,:));
        saveas(gcf,fullfile(path,'All_Values_from_Bartlett-Test_of_GATED'),'png');
        close all;
    end
end