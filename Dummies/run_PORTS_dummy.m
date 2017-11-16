function texture_metric_PORTS = run_PORTS_dummy(dImg,lMask,category)


iBinSize = 64;
moment_metrics = []; texture_metrics = [];

if (category.Histogram==1 || category.GTSDM==1 || category.NGTDM==1 || category.GLZSM==1 || category.GLRLM==1)
    [~, texture_metrics] = fTexture(dImg,lMask,iBinSize,category);
end
if category.Moments == 1
    [moment_metrics] = fMoments(dImg,lMask);
end
dVolume = [];
% dVolume = nnz(lMask) .* prod(sCoord.dAP) ./ 1000; % [cm^3]
% [X,Y,Z] = ndgrid(0:size(dImg,1)-1, 0:size(dImg,2)-1, 0:size(dImg,3)-1);
% X = X .* sCoord.dAP(1); Y = Y .* sCoord.dAP(2); Z = Z .* sCoord.dAP(3);
% X = X(lMask); Y = Y(lMask); Z = Z(lMask); Nm = [X(:) Y(:) Z(:)];
% dDist = squareform(pdist(Nm)); dDist = max(dDist(:));
dDist=2;
texture_metric_PORTS = [{'Diameter [mm]', dDist}; moment_metrics; texture_metrics]; 