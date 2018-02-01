%Try to load .nii - Data
%%Prework
function [biggest_ROI] = get_biggest_ROI_from_nii(filePath)
mask_100_nii = load_nii(filePath);
allROI_mask=mask_100_nii.img;
[row,col,v]=find(allROI_mask);
v_max=max(v);

%% %better coding, has a fixed size
ROI_indices(v_max)=0;
mask_Size=size(allROI_mask);
single_ROIsmask={};
temp=0;

%%Create single ROIs from a mask
for i=1:v_max
    ROI_indices=find(allROI_mask==i);
    length_ROI_indices=length(ROI_indices);
    if length_ROI_indices>temp
        number_of_biggest_ROI=i;
        temp=length_ROI_indices;
    end
    
    single_ROIsmask{i}=zeros(mask_Size);
    for j=1:length_ROI_indices
        single_ROIsmask{1,i}(ROI_indices(j))=1;
    end
    single_ROIsmask{1,1}=logical(single_ROIsmask{1,1});
end
biggest_ROI=single_ROIsmask{1,number_of_biggest_ROI};
end
