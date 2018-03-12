%Try to load .nii - Data
clc; clear all;
%%Prework
filePath='Maske 100.nii';
mask_100_nii = load_nii(filePath);
allROI_mask=mask_100_nii.img;
[row,col,v]=find(allROI_mask);
v_max=max(v); %v_max = number of different ROIs

%% better coding, has a fixed size
ROI_indices(v_max)=0;
mask_Size=size(allROI_mask);
single_ROIsmask={};
temp=0;

%% Create single ROIs from a mask
for i=1:v_max
    ROI_indices=find(allROI_mask==i);
    length_ROI_indices=length(ROI_indices);
    if length_ROI_indices>temp
        biggest_ROI=i;
        temp=length_ROI_indices;
    end
    
    single_ROIsmask{i}=zeros(mask_Size);
    for j=1:length_ROI_indices
        single_ROIsmask{1,i}(ROI_indices(j))=1;
    end
    single_ROIsmask{1,i}=logical(single_ROIsmask{1,i});
    
end
all_single_ROIs=single_ROIsmask;

%% create mha-template 
load('template_mha_mask.mat');
output_mha_mask= template_mha_mask;
%clear template_mha_mask;
output_mha_mask.mask = all_single_ROIs{1,1};
%prepare meshing
    qoffset_sc(1,2)= mask_100_nii.hdr.hist.qoffset_x;
    qoffset_sc(1,3)= mask_100_nii.hdr.hist.qoffset_y;
    qoffset_sc(1,4)= mask_100_nii.hdr.hist.qoffset_z;
% meshing
for i=1:3
    output_mha_mask.info.Dimensions(1,i) = mask_100_nii.hdr.dime.dim(1,1+i); %mesh global dimensions
    output_mha_mask.info.Offset(1,i) = qoffset_sc(1,i+1); %mesh Offset
    output_mha_mask.info.PixelDimensions(1,i) = mask_100_nii.hdr.dime.pixdim(1,1+i); %mesh pixel dimensions
end


%% save ROIs as single Masks
%Control Masks - Dr. Seith

%Real Masks

%% what is a mha Mask
