function main_runGUI()
% required matlab version: matlab15a or later

tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));


addpath(genpath(cd));
addpath(genpath('/net/linse8-sn/home/s1216/doc/matlab_scripts'));

global comp_strct
comp_strct = struct('No',[],'features',[],'featureNames',[],'idxEndPORTS',[],'ROI',[],'ROINames',[],'data',[],'plots',[]);
comp_strct.featureNames = struct('PORTS',[],'radiomics',[]);

global handles
global bekannteStudien


choice = questdlg('Sollen bekannte Studien eingeladen werden?','bekannteStudien laden','Ja','Nein, ist schon im Workspace','Exit');
switch choice
    case 'Ja'
        [file,path] = uigetfile('*.mat','Lade alle bekannten Studien','MultiSelect', 'on');
        dir = fullfile(path,file);
        if ~iscell(dir) % then only 1 input
            dir = cellstr(dir);
        end
        hLoad = showWaitbar_loadData([],1,'Lade "bekannteStudien.mat" ...');
        bekannteStudien = struct('name',[],'directories',[],'data',[],'dicominfo',[],'ROI',[],'ROInames',[],'ROIdirectories',[],'features',[],'selectedFeatures',[]);
        for i=1:length(dir)
            temp = load(dir{i});
            bekannteStudien = [bekannteStudien temp.bekannteStudien];
        end
        % find empty elements (should be at least element 1)
        emptyIndex = find(arrayfun(@(x) isempty(x.ROI),bekannteStudien));
        bekannteStudien(emptyIndex) = [];
        showWaitbar_loadData(hLoad,0);
    otherwise
end

clear tmp choice hLoad

handles = run_GUI();

% % to get global variables, type:
% who global
end

function hLoad = showWaitbar_loadData(hLoad,startEnd,msg)
if nargin<3, msg = 'Lade Daten ...'; end
if startEnd == 1
    % start of calculation
    hLoad = waitbar(0,msg);
    
elseif startEnd == 0
    % end of calculation
    try
        close(hLoad);
    end
end
end