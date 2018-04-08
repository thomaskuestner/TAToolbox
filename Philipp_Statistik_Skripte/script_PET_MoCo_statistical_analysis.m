% Preprocessing of the PET MoCo Data
struct = load('C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\05_Code\Philipp_Statistik_Skripte\MoCo_Corrected_Cell');
current_Data= struct.features(:,:,:);
counter = 1;
for l = 1:42
    for i = 1:3:42
        feature_value_1(counter) = current_Data{l,i,i};
        counter = counter + 1;
    end
    l = l + 1;
end
counter = 1;
%var_temp_dicom = feature_value_1;
final_output_dicom = reshape(feature_value_1,14,42);
for o = 1:42
    for j = 2:3:42
        feature_value_2(counter) = current_Data{o,j,j};
        counter = counter + 1;
    end
    o = o + 1;
end
counter = 1;
%var_temp_corr = feature_value_2;
final_output_corrected = reshape(feature_value_2,14,42);
for s = 1:42
    for d = 3:3:42
        feature_value_3(counter) = current_Data{s,d,d};
        counter = counter + 1;
    end
    s = s + 1;
end
%var_temp_gated = feature_value_3;
final_output_gated = reshape(feature_value_3,14,42);
clearvars i j l o s d counter struct

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