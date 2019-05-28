function texture_metric_radiomics = run_radiomics(sPathImg, lMask,category)

% settings for preprocessing
% load volume
isMatFile = strfind(sPathImg,'.mat');
if isempty(isMatFile)
    if exist(fullfile(sPathImg,'VOLUME_IMAGE.mat'))
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

scanType = 'MRscan';
pixelW = 1;
sliceS = 1;
R = 1; % no bandpass filtering
scale = 'pixelW';
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