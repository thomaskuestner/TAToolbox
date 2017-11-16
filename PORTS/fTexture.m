function [metric_names, texture_metrics] = fTexture(img_vol,mask_vol,num_img_values,category)
%% TA evaluation
% inits
currpath = fileparts(mfilename('fullpath'));
if(isempty(currpath))
    currpath = pwd;
end
addpath(genpath([currpath,filesep,'PORTS']));
% Choose the number of distinct graytone values to use for computing 
% texture metrics:
if(nargin < 3)
    num_img_values = 256;
end


%% precomputations
% Put all of the computed metric names into a single list. There are 42
% texture metrics computed in this script:
metric_names = [compute_histogram_metrics() ; ...
                compute_GTSDM_metrics() ; ...
                compute_NGTDM_metrics() ; ...
                compute_zone_size_metrics() ; ...
                ];
            
% Number the metric names to make it easy on the user:
temp_metric_names = cell(size(metric_names));
for this_metric = 1:size(metric_names,1)
    temp_metric_names{this_metric} = sprintf('(%d) %s',this_metric,metric_names{this_metric});
end

metric_names = temp_metric_names;

% Clear unused variable:
clear temp_metric_names


% Determine connectivity and bounding box of this ROI:
[bounding_box,ROI_conn_3D_6,ROI_conn_3D_26,binary_dir_connectivity] = ...
    determine_ROI_3D_connectivity(mask_vol);
% load('3D_connectivity.mat');

% Take the ROI sub-volume within the bounding box:
mask_vol_subvol = mask_vol(bounding_box(1,1):bounding_box(1,2) , ...
                           bounding_box(2,1):bounding_box(2,2) , ...
                           bounding_box(3,1):bounding_box(3,2) );      
                  
% Now take the image sub-volume that corresponds to this mask:
img_vol_subvol = img_vol(bounding_box(1,1):bounding_box(1,2) , ...
                         bounding_box(2,1):bounding_box(2,2) , ...
                         bounding_box(3,1):bounding_box(3,2) );      
                   
%% Texture Metric Computation Loop
% Create a column-vector placeholder for the 42 texture metrics:
texture_metrics = cell(numel(metric_names),2);
texture_metrics(:,1) = metric_names;

% Determine the number of voxels in the ROI. This is used to compute the
% histogram-based probabilities and also in the Size-Zone metrics
% computations:
num_ROI_voxels = length(find(mask_vol_subvol));

% Find the min and max within only the ROI:
img_min = min(img_vol_subvol(mask_vol_subvol)); 
img_max = max(img_vol_subvol(mask_vol_subvol)); 

% Rescale to image volume to [0,N]:
img_vol_subvol = num_img_values .* (img_vol_subvol - img_min)/(img_max - img_min) ;

% Discretize and add 1 to get values {1,2,...,N+1}:
img_vol_subvol = floor(img_vol_subvol) + 1;

% The max value is currently one higher than it should be (N+1), so put 
% those voxels at the max value:
img_vol_subvol(img_vol_subvol==num_img_values+1) = num_img_values;

%%%%%
%%%%% Histogram-based computations:
%%%%%
if category.Histogram == 1
    % Compute the histogram of the ROI and probability of each voxel value:
    vox_val_hist = zeros(num_img_values,1);
    for this_vox_value = 1:num_img_values
        vox_val_hist(this_vox_value) = length(find((img_vol_subvol == this_vox_value) & (mask_vol_subvol == 1) ));
    end

    % Compute the relative probabilities from the histogram:
    vox_val_probs = vox_val_hist / num_ROI_voxels;

    % Compute the histogram_based metrics:
    texture_metrics(1:6,2) = num2cell(compute_histogram_metrics(vox_val_probs,num_img_values));
end

%%%%%
%%%%% GTDSM (Co-occurance) Matrix calculations:
%%%%%
if category.GTSDM == 1
    % Create the Gray-Tone-Spatial-Dependence-Matrix (GTSDM):
    GTSDM = compute_3D_GTSDM(mask_vol_subvol,img_vol_subvol,binary_dir_connectivity,num_img_values);

    % It is common to compute the mean value over the 13 directions (for
    % distance-1 voxels). The following loop computes the metrics for each
    % direction:
    GTSDM_metrics = zeros(13,20);
    for this_direction = 1:13
        % Compute the metrics for this combination:
        GTSDM_metrics(this_direction,:) = compute_GTSDM_metrics(GTSDM(:,:,this_direction));
    end

    % Now take the mean texture metric value over the all directions:
    texture_metrics(7:26,2) = num2cell(mean(GTSDM_metrics,1));
end

%%%%%
%%%%% NGTDM Matrices and metrics
%%%%%
if category.NGTDM == 1
    % Create the Neighborhood-Gray-Tone-Difference-Matrix(NGTDM):
    [NGTDM,vox_occurances_NGD26] = compute_3D_NGTDM(mask_vol_subvol,img_vol_subvol,binary_dir_connectivity,num_img_values);

    % Compute NGTDM metrics:
    texture_metrics(27:31,2) = num2cell(compute_NGTDM_metrics(NGTDM,num_img_values,vox_occurances_NGD26));
end

%%%%%
%%%%% Zone Size matrix and Metrics:
%%%%%
if category.GLZSM == 1
    % Create the Zone Size Matrix:
    GLZSM = compute_GLZSM(mask_vol_subvol,img_vol_subvol,num_img_values);

    % Compute the Zone Size Metrics:
    texture_metrics(32:42,2) = num2cell(compute_zone_size_metrics(GLZSM,num_ROI_voxels));
end
