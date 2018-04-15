%% Various comparisons and simple tests
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
%% Statistical Methods
% 1. Test von DICOM- und CORRECTED- Daten
% T-Test -> Wenn tTest versagt -> Wilcoxon

% Calculate and safe of means
mean_dicom = mean(final_output_dicom); 
% save('Mittelwert_DICOM','mean_dicom');
mean_corr = mean(final_output_corr);
% save('Mittelwert_CORRECTED','mean_corr');
mean_gated = mean(final_output_gated);
% save('Mittelwert_GATED','mean_gated');

% Calculate and saving of variances
variance_dicom = var(final_output_dicom);
% save('Varianz_DICOM','variance_dicom');
variance_corr = (final_output_corr);
% save('Varianz_CORRECTED','variance_corr');
variance_gated = (final_output_dicom);
% save('Varianz_GATED','variance_gated');

%Bartlett Tests for TF- Skedaszity
% bartlett_dicom = vartestn(final_output_dicom(:,:));
% bartlett_corr = vartestn(final_output_corr(:,:));
% bartlett_gated = vartestn(final_output_gated(:,:));
for n = 1:42
here = [final_output_dicom(:,n),final_output_corrected(:,n),final_output_gated(:,n)];
[a,b] = vartestn(here);
end

%% Hier weiter: Was kann ich machen (Diff. oder Verh. etc. f?r Skedasdiz.)
bartlett_dicom = vartestn(final_output_dicom(:,:));
bartlett_corr = vartestn(final_output_corr(:,:));
bartlett_gated = vartestn(final_output_gated(:,:));

%https://de.mathworks.com/help/stats/friedman.html
%https://de.wikipedia.org/wiki/Friedman-Test_(Statistik)

%% Auseissertests für die Daten

out1 = isoutlier(final_output_dicom,'median');
% out2 = isoutlier(final_output_dicom,'mean');
out3 = isoutlier(final_output_dicom,'quartiles');
outlier_median = zeros(1,14);
outlier_mean = zeros(1,14);
outlier_quartiles = zeros(1,14);
i = 1;
for n = 1:14
outlier_median(i) = length(find(out1(n,:) == 1));
i = i + 1;
end
% o = 0;
% for j = 1:14
% outlier_mean(o) = length(find(out2(j,:) == 1));    
% o = o + 1;
% end
p = 1;
for k = 1:14
outlier_quartiles(p) = length(find(out3(k,:) == 1));
p = p + 1;
end