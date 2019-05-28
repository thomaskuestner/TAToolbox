% Statistics for the Radiomics Toolbox features with PET MoCo- Data

% function structSorter()
% function infoGrabber()
% function applyStatistics() % Maybe create a 2nd GUI? 

struct = load('C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\05_Code\MoCo_Corrected_Cell');
current_Data= struct.features(:,:,:);
var_feature = 1;
datatype = 2;
counter = 1;

switch datatype
    case 1 % Loop for same TFs of all measurements
        for i = 1:42
            feature_value(counter) = current_Data{var_feature,i,i};
            counter = counter + 1;
        end
% Loops for same TFs of all measurements of the same kind
    case 2 % Loop for same TFs of all 'Corrected Files'
        for i = 1:3:42
            feature_value(counter) = current_Data{var_feature,i,i};
            counter = counter + 1;
        end
    case 3 % Loop for same TFs of all 'DICOM files'
        for i = 2:3:42
            feature_value(counter) = current_Data{var_feature,i,i};
            counter = counter + 1;
        end
    case 4 % Loop for same TFs of all 'Gated files'
        for i = 3:3:42
            feature_value(counter) = current_Data{var_feature,i,i};
            counter = counter + 1;
        end
    otherwise
        error('Wrong Input!');
end

var_feature = feature_value;

% hist(var_feature);
plot(var_feature,'bo','markersize',5);

% title = 'Enter Statistics of selected data here:';
% discr = 'Functions';
% defaultAns = 'ttest';
% var_select = inputdlg(title, discr, 1, {defaultAns},'on');

% switch char(var_select)
%     case 'ttest'
%         output = ttest(var_feature); % -> How does it work? % for each TF of all 14/42 patients
%     case 'hist'
%         output = histogram(var_feature,10); % for each TF of all 14/42 patients
%     case 'corr'
%         output = corrcoef(var_feature); % for each TF of all 14/42 patients
%         
%   % More cases here:
%         
%     otherwise
%         error(sprintf('Die ausgewaehlte Funktion ist nicht implementiert/ vorhaden!\n\nIst die Schreibweise der Funktion richitg?\n'));
% end

% plot(output); % Output hat den Y- Achsencharakter (bedenken beim Belegen von Plot!)
        
