load('count_number_of_outliers_per_tf_and_id.mat');

for roi=1:2
    for p=1:19
        idranking(roi,p)=sum(count_number_of_outlier{1,roi}(:,p));
    end
end