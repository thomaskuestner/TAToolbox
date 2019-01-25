function texture_metric_radiomics = run_radiomics(sPathImg, lMask,category)

%%% Minor code efficiency fix
%%% Fix bugs (feature calculation now takes into account image modality)
%%% Added optional feature (non-isometric volume image to isometric)
% settings for preprocessing
% load volume
if ~contains(sPathImg,'.mat')
    if exist(fullfile(sPathImg,'VOLUME_IMAGE.mat'), 'file')
        volume = load(fullfile(sPathImg,'VOLUME_IMAGE.mat'));
    else
        dicom23D(sPathImg);
        volume = load(fullfile(sPathImg,'VOLUME_IMAGE.mat'));
    end
    volume= volume.volume_image;
else
    temp = load(sPathImg);
    fn = fieldnames(temp);       
    volume = temp.(fn{1});
end

% load mask
% addpath(genpath(['/net/linse8-sn/home/s1216/doc/Code/Masking']));
% mask_temp = main_read_mask(sPathMask);
% mask = rot90(fliplr(mask_temp));

scanType = strcat(slice_data(1).Modality, 'scan');

%%% ========
% Comment/Uncomment if texture feature is to be calculated from volume
% image as is
pixelW = 1;
sliceS = 1;
scale = 'pixelW';

%%% ========
% Comment/Uncomment if texture feature is to be calculated from isometric 
% volume
%
% pixelW = slice_data(1).PixelSpacing(1);
% sliceS = slice_data(1).SliceThickness;
% scale = 1; % scale to isometric volume with 1x1x1 mm spacing
%
% scale = 'pixelW' % scale to isometric volume with spacing matched to pixel
%                  % width dimension
%
% scale = max(pixelW, sliceS) % isometric upsampling to largest dimension
%
% scale = min(pixelW, sliceS) % isometric downsampling to smallest
%                             % dimension

%%% ========
% Old Implementation
%
% scanType = 'MRscan';
% pixelW = 1;
% sliceS = 1;
% scale = 'pixelW';
R = 1; % no bandpass filtering
textType = 'Matrix'; % 'Global'
quantAlgo = 'Equal'; 
%              Either 'Equal' for equal-probability quantization, 'Lloyd'
%              for Lloyd-Max quantization, or 'Uniform' for uniform quantization.
%              Use only if textType is set to 'Matrix'.
Ng = 64;

[ROIonly,levels] = prepareVolume(volume,lMask,scanType,pixelW,sliceS,R,scale,textType,quantAlgo,Ng);
[ROIonly_Global] = prepareVolume(volume,lMask,scanType,pixelW,sliceS,R,scale,'Global');

% texture features
texture_metric_radiomics = fTexture_radiomics(ROIonly,ROIonly_Global,levels,category);
texture_metric_radiomics = texture_metric_radiomics(:,2);