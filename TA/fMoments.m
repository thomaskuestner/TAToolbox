function [metric_names, texture_metrics] = fMoments( dImg, lMask )
% moment features

metric_names = {'Max', 'Min', 'Mean', 'STD'};
texture_metrics = [];
if(nargout < 2)
    return;
end

maskedImg = dImg(lMask);
texture_metrics = [max(maskedImg(:)), ...
                   min(maskedImg(:)), ...
                   mean(maskedImg(:)), ...
                   std(maskedImg(:))];

end

