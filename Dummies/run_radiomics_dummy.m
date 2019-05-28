function texture_metric_radiomics = run_radiomics_dummy(volume, lMask,category)



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