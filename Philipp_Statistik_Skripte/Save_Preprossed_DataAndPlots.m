function [] = Save_Preprossed_Data_With_TTesting(dicom,corrected,gated)
load('feature_Names');
counter = 1;
h_ttest_1 = zeros(1,42); h_ttest_2 = zeros(1,42); h_ttest_3 = zeros(1,42);
p_ttest_1 = zeros(1,42); p_ttest_2 = zeros(1,42); p_ttest_3 = zeros(1,42);
for i = 1:42
    filename_plot = feature_Names{i,1};
    [h_ttest_1(counter),p_ttest_1(counter)] = ttest2(dicom(:,i),corrected(:,i));
    var_plottable = figure;
    plot(dicom(:,i),corrected(:,i),'bo');
    title(filename_plot);
    refline(1); 
    grid on;
    pos = get(var_plottable,'Position');
    set(var_plottable,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    pos = get(var_plottable,'Position');
    text_1 = sprintf('Wert der Nullhypothese des T- Tests: %d',h_ttest_1(counter));
    text_2 = sprintf('P-Wert des T-Tests der beiden Features: %f',p_ttest_1(counter));
    label_X_axis = 'PET- MoCo DICOM';
    text_labeling_plot = sprintf(strcat(label_X_axis,'\n','Absolute Values for Texture Features',... 
    '\n\n',text_1,'\n',text_2));
    label_Y_axis = 'PET- MoCo CORRECTED';
    xlabel(text_labeling_plot);
    ylabel(label_Y_axis);
    path_00 = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\01_Feature_Comparisons\01_DicomVsCorrected';
    saveas(gcf, fullfile(path_00, filename_plot),'png');
    close(var_plottable);
    counter = counter + 1;
end
    % Ausgabe der abgelehnten TFs
disp('Fuer folgende Features wurde die Nullhypothese des TTests abgelehnt: ')
for j = 1:length(h_ttest)
    num = 1;
    if h_ttest(j) ~= 0
        rejected_NHyp_num(num) = j;
        disp(feature_Names{j,1});
        disp(j);
        num = num+ 1;
    end
end
disp('--------------------------------------------------------------------');

for i = 1:42
    filename_plot = feature_Names{i,1};
    [h_ttest_2(counter),p_ttest_2(counter)] = ttest2(dicom(:,i),gated(:,i));
    var_plottable = figure;
    plot(dicom(:,i),gated(:,i),'bo');
    title(filename_plot);
    refline(1); 
    grid on;
    pos = get(var_plottable,'Position');
    set(var_plottable,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    pos = get(var_plottable,'Position');
    text_1 = sprintf('Wert der Nullhypothese des T- Tests: %d',h_ttest_2(counter));
    text_2 = sprintf('P-Wert des T-Tests der beiden Features: %f',p_ttest_2(counter));
    label_X_axis = 'PET- MoCo DICOM';
    text_labeling_plot = sprintf(strcat(label_X_axis,'\n','Absolute Values for Texture Features',... 
    '\n\n',text_1,'\n',text_2));
    label_Y_axis = 'PET- MoCo CORRECTED';
    xlabel(text_labeling_plot);
    ylabel(label_Y_axis);
    path_00 = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\Comp_DIC_vs_COR';
    saveas(gcf, fullfile(path_00, filename_plot),'png');
    close(var_plottable);
    counter = counter + 1;
end
    % Ausgabe der abgelehnten TFs
disp('Fuer folgende Features wurde die Nullhypothese des TTests abgelehnt: ')
for j = 1:length(h_ttest)
    num = 1;
    if h_ttest(j) ~= 0
        rejected_NHyp_num(num) = j;
        disp(feature_Names{j,1});
        disp(j);
        num = num+ 1;
    end
end
disp('--------------------------------------------------------------------');
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
    text_labeling_plot = sprintf(strcat('\n','Absolute Values for Texture Features','\n\n',label_X_axis));
    label_X_axis = 'PET- MoCo CORRECTED';
    label_Y_axis = 'PET- MoCo GATED';
    xlabel(text_labeling_plot);
    ylabel(label_Y_axis);
    path_00 = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\Comp_COR_vs_GAT';
    saveas(gcf, fullfile(path_00, filename_plot),'png');
    close(var_plottable);
end
end