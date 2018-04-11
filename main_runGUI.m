function main_runGUI()
% required matlab version: matlab15a or later

tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

%Do we need the following two lines they are hard coded?
addpath(genpath(cd));
addpath(genpath('/net/linse8-sn/home/s1216/doc/matlab_scripts_noetig'));

global comp_strct
comp_strct = struct('No',[],'features',[],'featureNames',[],'idxEndPORTS',[],'ROI',[],'ROINames',[],'data',[],'plots',[]);
comp_strct.featureNames = struct('PORTS',[],'radiomics',[]);

global handles
global bekannteStudien

%Creating First Dialoge Window
textButton_from_scratch='DICOM Rohdaten und zugehörige Masken';textButton_continue_work='Schon mit TFCV berechnete Datensätze';
options.Interpreter = 'tex'; options.Default = textButton_continue_work;
choice = questdlg('Welche Daten möchten Sie verabeiten?','Start TFCV - TexturFeature Calculator and Viewer',textButton_from_scratch,textButton_continue_work,options);
switch choice
    case 'Schon mit TFCV berechnete Datensätze'
        [file,path] = uigetfile('*.mat','Lade alle bekannten Studien','MultiSelect', 'on');
        dir = fullfile(path,file);
        if numel(dir)<4
            return;
        elseif ~iscell(dir) % then only 1 input
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
    case 'DICOM Daten und zugehörige Masken'
        %msgbox('Bitte fügen Sie über .. Button im Windows-Explorer die Datein hinzu');
    case ''
        return;
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