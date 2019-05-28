function [p_val,signi] = KruskalWallisTest(dicom,corrected,gated,p_value)
% Caluculates and saves all the results of the Kruskal-Wallis-Test
load('feature_Names');
ans_for_saving = questdlg('Would you like the Kruskal-Wallis-Test plots being saved?','Query for saving plots',...
    'Yes','No','Yes');
switch ans_for_saving
    case 'Yes' % You save the plots of the comparisons
        var_for_saveing = 1;
    case 'No' % If no is klicked, the plots pop up and get closed without being saved
        var_for_saveing = 0;
end
path = uigetdir();
oldpath = cd(path);
folderName = fullfile(path,'Kruskal-Wallis-Test_Test');
if ~exist(folderName, 'dir')
    mkdir(folderName);
end
% Schleife um einzelne Kruskal Wallis Tests durchzuführen und zu speichern
% Ausgabe der hohen P-Werte (Wert ist Funktionsinput)
counter = 1;
% second = 1;
for n = 1:42
    plug_in = [dicom(:,n),corrected(:,n),gated(:,n)];
    [p_val(counter),tbl,stats] = kruskalwallis(plug_in);
    if var_for_saveing == 1
        saveas(gcf,fullfile(folderName,feature_Names{n,1}),'png');
    end
    close all;
    counter = counter + 1;
    %     if p_val(n) >= p_value
    %         disp(feature_Names{n,1}); disp(n);
    %         signi(n,second) = p_val(n);
    %         second = second + 1;
    %     end
end
plot(p_val,'bo');
pees = 'p-values_KruskalWallis';
saveas(gcf,fullfile(folderName,pees),'png');
close all;
end