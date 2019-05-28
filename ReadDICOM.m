function [ct3d, DICOM_INFO] = ReadDICOM(sFolder)
% ct3d is the mat-file that contains all the DICOM information in one file

if ispc, sS='\'; else sS='/'; end;

SFolder = dir(sFolder);
SFiles = SFolder(~[SFolder.isdir]);
cNames = {SFiles(:).name};
lInd = cellfun(@(x) any(strcmpi(x(end-3:end),{'.ima','.dcm'})), cNames); % skip unwanted files
SFiles = SFiles(lInd);

img = dicomread(fullfile(sFolder, SFiles(1).name));
DICOM_INFO  = dicominfo([sFolder, sS, SFiles(1).name]);

siz_img = size(img);
N = length(SFiles);

% create result matrix:
ct3d = NaN([siz_img N]);  

% load all images and put them in the matrix
for ii=1:N  
    strfile = sprintf(SFiles(ii).name);
    ct3d(:,:,ii)= dicomread(fullfile(sFolder, strfile));
end

end