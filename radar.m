function [sa,sp] = radar(indata, featuredescriptor, objectdescriptor, titlestring,sa,sp)
%example usage:
%   featuredescriptor = {'Apples', 'Pears', 'Bananas', 'Tractor', 'Fertilizer'};
%   objectdescriptor = {'Peasant A', 'Peasant B', 'City-slicker'};
%   titlestring = 'Comparing peasants';
%   indata = (rand(3,5)).*[1 3 2 1 42];
%   radar(indata, featuredescriptor, objectdescriptor, titlestring);[objs, dims] = size(indata);
% assert(all(indata(:)>=0));

%% try to sort from large to small to reduce occlusion
[objs, dims] = size(indata);

% [~, i] = sort(prod(indata,2), 'descend');
% indata = indata(i,:);
% objectdescriptor = {objectdescriptor{i}};

if nargin <5
    sp = max(indata);
    sa = min(indata);
    sa = sa - 0.1*(sp - sa);
    sa = max(sa, 0);
end

indata_norm = (indata - repmat(sa,size(indata,1),1)) ./ repmat((sp - sa),size(indata,1),1);
numtick = 4;%10;
rng = ((1/numtick):(1/numtick):1);

circspan = (0:(2*pi/dims):(2-1/dims)*pi);
[X,Y] = pol2cart(circspan ,1.1*ones(1,dims));
[X2,Y2] = pol2cart(circspan ,1.3*ones(1,dims));
[pdX,pdY] = pol2cart(repmat(circspan,size(indata_norm,1),1), indata_norm);

clf
hold on
map=colormap(parula(objs));
for ob = 1:objs
    h(ob) = patch(pdX(ob,[1:end 1]), pdY(ob,[1:end 1]), map(ob,:), 'FaceAlpha', 0.1, 'EdgeColor', map(ob,:), 'EdgeAlpha', 1, 'LineWidth', 2);
end

for t = 1:dims
    quiver(0, 0, X(t), Y(t), 0);
    [tlocX, tlocY] = pol2cart(circspan(t), rng, 'k');
    plot(tlocX, tlocY, 'k*')
    text_offset_radius = 0.1;
    [offX, offY] = pol2cart(circspan(t)-pi/2, text_offset_radius);
    text(tlocX+offX, tlocY+offY, num2str((rng'* (sp(t)-sa(t))) + sa(t),'%2.2g'))
    text(X2(t), Y2(t), featuredescriptor{t});
end
hold off
axis square
xlim(1.2*[min(X2) max(X2)])
ylim(1.1*[min(Y2) max(Y2)])
title(titlestring)
% legend(h, objectdescriptor)
set(gca, 'XTick', [])
set(gca, 'YTick', [])
