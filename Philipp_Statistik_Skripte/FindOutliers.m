function [outlier_median,outlier_quartiles] = FindOutliers(input)

out1 = isoutlier(input,'median');
% out2 = isoutlier(final_output_dicom,'mean');
out3 = isoutlier(input,'quartiles');
outlier_median = zeros(1,14);
% outlier_mean = zeros(1,14);
outlier_quartiles = zeros(1,14);
i = 1;
for n = 1:14
outlier_median(i) = length(find(out1(n,:) == 1));
i = i + 1;
end
% o = 0;
% for j = 1:14 % Muss als 3. Ausgangsargument definiert werden, wenn es genutzt werden soll!
% outlier_mean(o) = length(find(out2(j,:) == 1));    
% o = o + 1;
% end
p = 1;
for k = 1:14
outlier_quartiles(p) = length(find(out3(k,:) == 1));
p = p + 1;
end
outlier_median = outlier_median';
outlier_quartiles = outlier_quartiles';
end