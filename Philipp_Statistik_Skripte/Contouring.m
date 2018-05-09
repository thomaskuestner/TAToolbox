lMask = [];
masks_to_extract = uigetfile_n_dir();
for i = 1:numel(sPathImg)
    [dImg{i},dicominfo{i}] = ReadDICOM(masks_to_extract{i});
end
counter = 1;
for j = 1:length(masks_to_extract)
lMask = main_read_mask(masks_to_extract)
end
% Das hier noch in die Schleife, um das für jede Maske zu machen
% 40% isocontour of SUVmax (with morphological closing)
dSUVMax = max(max(max(dImg(lMask),[],1),[],2),[],3);
lApplicable = lMask & dImg >= 0.4 * dSUVMax;
% morphological closing % Why this?
se = strel('disk',3); % creates a disk-shaped morphological structuring element with radius 3
lApplicable = imerode(imdilate(lApplicable,se),se) & lMask; % imerode = matlab funktion


dSUVMax = max(max(max(dImg(lMask),[],1),[],2),[],3);
[X, Y, Z] = ndgrid(dImg(lMask));
fv = isosurface(X,Y,Z,dImg(lMask),0.4 * dSUVMax);