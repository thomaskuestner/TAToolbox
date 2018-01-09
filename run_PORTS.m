function texture_metric_PORTS = run_PORTS(sPathImg, lMask,category)

addpath(genpath(['/net/linse8-sn/home/s1216/doc/Code/TextureAnalysis/Pipeline/PORTS']));

iBinSize = 64;
% moment_metrics = cell(4,2); texture_metrics = cell(44,2);
moment_metrics = []; texture_metrics = [];

isMatFile = strfind(sPathImg,'.mat');
if isempty(isMatFile)
    [dImg,~,sCoord] = fReadDICOM(sPathImg);
else
    temp = load(sPathImg);
    fn = fieldnames(temp);       
    dImg = temp.(fn{1});
    
    sCoord.dAP = 0;
end

if (category.Histogram==1 || category.GTSDM==1 || category.NGTDM==1 || category.GLZSM==1 || category.GLRLM==1)
    [~, texture_metrics] = fTexture(dImg,lMask,iBinSize,category);
end
if category.Moments == 1
    [~,moment_metrics] = fMoments(dImg,lMask);
end
dVolume = nnz(lMask) .* prod(sCoord.dAP) ./ 1000; % [cm^3]
% [X,Y,Z] = ndgrid(0:size(dImg,1)-1, 0:size(dImg,2)-1, 0:size(dImg,3)-1);
% X = X .* sCoord.dAP(1); Y = Y .* sCoord.dAP(2); Z = Z .* sCoord.dAP(3);
% X = X(lMask); Y = Y(lMask); Z = Z(lMask); Nm = [X(:) Y(:) Z(:)];
% dDist = squareform(pdist(Nm)); dDist = max(dDist(:));
dDist=2;
texture_metric_PORTS = [{dVolume, dDist}, num2cell(moment_metrics), num2cell(texture_metrics)]'; 