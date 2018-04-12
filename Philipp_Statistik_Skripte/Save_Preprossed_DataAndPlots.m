function [] = Save_Preprossed_DataAndPlots(dicom,corrected,gated)
load('feature_Names');
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
    label_X_axis = 'PET- MoCo DICOM';
    text_labeling_plot = sprintf(strcat('\n','Absolute Values for Texture Features','\n\n',label_X_axis));
    label_Y_axis = 'PET- MoCo CORRECTED';
    xlabel(text_labeling_plot);
    ylabel(label_Y_axis);
    path_00 = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\Comp_DIC_vs_COR';
    saveas(gcf, fullfile(path_00, filename_plot),'png');
    close(var_plottable);
end
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
    text_labeling_plot = sprintf(strcat('\n','Absolute Values for Texture Features','\n\n',label_X_axis));
    label_X_axis = 'PET- MoCo DICOM';
    label_Y_axis = 'PET- MoCo GATED';
    xlabel(text_labeling_plot);
    ylabel(label_Y_axis);
    path_00 = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\Comp_DIC_vs_GAT';
    saveas(gcf, fullfile(path_00, filename_plot),'png');
    close(var_plottable);
end
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