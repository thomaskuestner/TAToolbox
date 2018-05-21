function V = read_single_nii(filename)
%READ_SINGLE_NII Summary of this function goes here
%   Detailed explanation goes here
temp = load_nii(filename);
mask_nii = temp.img;

V=logical(mask_nii);
end

