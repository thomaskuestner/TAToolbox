function [final_output_corrected,final_output_dicom,final_output_gated] = PreProcessing(cell)
% Preprocessing of the PET MoCo Data
current_data = cell.hier(:,:,:);
counter = 1;
feature_value_1 = zeros(1,42);
feature_value_2 = zeros(1,42);
feature_value_3 = zeros(1,42);
for l = 1:42
    for i = 1:3:42
        feature_value_1(counter) = current_data{l,i,i};
        counter = counter + 1;
    end
    l = l + 1;
end
counter = 1;
%var_temp_dicom = feature_value_1;
final_output_corrected = reshape(feature_value_1,14,42);
for o = 1:42
    for j = 2:3:42
        feature_value_2(counter) = current_data{o,j,j};
        counter = counter + 1;
    end
    o = o + 1;
end
counter = 1;
%var_temp_corr = feature_value_2;
final_output_dicom = reshape(feature_value_2,14,42);
for s = 1:42
    for d = 3:3:42
        feature_value_3(counter) = current_data{s,d,d};
        counter = counter + 1;
    end
    s = s + 1;
end
%var_temp_gated = feature_value_3;
final_output_gated = reshape(feature_value_3,14,42);
end