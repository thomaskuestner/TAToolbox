function [p_val,signi] = KruskalWallisTest(dicom,corrected,gated,p_value)
% Caluculates and saves all the resultzs of the Kruskal Wallis Test
load('feature_Names');
path = 'C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\06_Plots\03_KruskalWallis_final';
counter = 1;
second = 1;
% Schleife um einzelne Kruskal Wallis Tests durchzuführen und zu speichern
% Ausgabe der hohen P-Werte (Wert ist Funktionsinput)
for n = 1:42
    plug_in = [dicom(:,n),corrected(:,n),gated(:,n)];
    [p_val(counter),tbl,stats] = kruskalwallis(plug_in);
    saveas(gcf,fullfile(path,feature_Names{n,1}),'png');
    close all;
    counter = counter + 1;
    if p_val(n) >= p_value
        disp(feature_Names{n,1}); disp(n);
        signi(n,second) = p_val(n);
        second = second + 1;
    end
end
plot(p_val,'bo');
pees = 'p-values_KruskalWallis';
saveas(gcf,fullfile(path,pees),'png');
close all;
end