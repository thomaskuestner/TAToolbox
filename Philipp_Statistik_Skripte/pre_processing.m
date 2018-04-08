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
dicom_final_output = reshape(feature_value_1,14,42);
for o = 1:42
    for j = 2:3:42
        feature_value_2(counter) = current_Data{o,j,j};
        counter = counter + 1;
    end
    o = o + 1;
end
counter = 1;
%var_temp_corr = feature_value_2;
corrected_final_output = reshape(feature_value_2,14,42);
for s = 1:42
    for d = 3:3:42
        feature_value_3(counter) = current_Data{s,d,d};
        counter = counter + 1;
    end
    s = s + 1;
end
counter = 1;
%var_temp_gated = feature_value_3;
gated_final_output = reshape(feature_value_3,14,42);
clearvars i j l o s d counter struct
