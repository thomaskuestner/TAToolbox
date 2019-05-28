function [texture_metrics] = fTexture_radiomics(ROIonly,ROIonly_Global,levels,category)
texture_metrics = [];

%%% Fixes sorting of texture feature values
%%% Fixes bin size of histogram to match that defined by levels argument
% Global
if category.Histogram == 1
    iBinSize = length(levels);
    textures_Global = getGlobalTextures(ROIonly_Global,iBinSize);
    texture_metrics = [fieldnames(textures_Global), struct2cell(textures_Global)];
end

% GLCM: Gray-Level Co-occurence Matrix
if category.GTSDM == 1
    GLCM = getGLCM(ROIonly,levels);
    textures_GLCM = getGLCMtextures(GLCM);
    texture_metrics = [texture_metrics; fieldnames(textures_GLCM), struct2cell(textures_GLCM)];
end

% Neighborhood Gray-Tone Difference Matrix (NGTDM)
if category.NGTDM == 1
    [NGTDM,countValid] = getNGTDM(ROIonly,levels);
    textures_NGTDM = getNGTDMtextures(NGTDM, countValid);
    texture_metrics = [texture_metrics; fieldnames(textures_NGTDM), struct2cell(textures_NGTDM)];
end

% Gray-Level Size Zone Matrix (GLSZM)
if category.GLZSM == 1
    GLSZM = getGLSZM(ROIonly,levels);
    textures_GLSZM = getGLSZMtextures(GLSZM);
    texture_metrics = [texture_metrics; fieldnames(textures_GLSZM), struct2cell(textures_GLSZM)];
end

% Gray-Level Run-Length Matrix (GLRLM)
if category.GLRLM == 1
    GLRLM = getGLRLM(ROIonly,levels);
    textures_GLRLM = getGLRLMtextures(GLRLM);
    texture_metrics = [texture_metrics; fieldnames(textures_GLRLM), struct2cell(textures_GLRLM)];
end