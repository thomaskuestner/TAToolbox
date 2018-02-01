function handles = run_GUI()
global strct
global bekannteStudien

strct = struct('data',[],'ROI',[],'features',[]);
strct.features = struct('PORTS',[],'radiomics',[],'feature_list',[]);
strct.ROI = struct('directories',[],'names',[],'lMask',[],'sameROIs',0,'info',[]);
strct.ROI.info = 'Fuer jede selektierte Aufnahme gibt es eine extra Zelle (Ebene 1), in der wiederum pro selektiertem Muskel/ROI eine Zelle (Ebene 2) mit der jeweiligen Maske abgelegt ist.';
load('feature_list.mat');
strct.features.feature_list = features;
clear features;

% -----------------------------
% ----- create GUI ------------
% -----------------------------
handles.f = figure('Visible','Off','units','pixel','Position',[0 50 1300 570]);
handles.f.Name = 'MainGUI';
handles.f.CloseRequestFcn = @saveclosereq;
% create the three main tabs %%% Here we can insert our augmentations
handles.tgroup = uitabgroup('Parent', handles.f);
handles.tab1 = uitab('Parent',handles.tgroup, 'Title', 'Settings');
handles.tab2 = uitab('Parent',handles.tgroup, 'Title', 'Subsets');
handles.tab3 = uitab('Parent',handles.tgroup, 'Title', 'Analyse + Visualisierung');

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
% = = tab 1
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

% --- Aufnahmen (tab 1)
% ------------------------------------------------------------------------------------------------------------------
handles.txt_data = uicontrol('Parent',handles.tab1,'Style','text','Position',[0 525 100 15],'HorizontalAlignment','left','String','Aufnahmen','FontSize',11); %#ok<*NASGU>
handles.tgroup_data = uitabgroup('Parent', handles.tab1,'units','pixel','Position',[0 0 420 520],'Tag','DataTab','SelectionChangedFcn',@selectedDataTab);
handles.tab_SpezData = uitab('Parent',handles.tgroup_data, 'Title', 'bekannte Studien');
handles.tab_Alldata = uitab('Parent',handles.tgroup_data, 'Title', '+');
handles.txt_info = uicontrol('Parent',handles.tab1,'Style','text','Position',[150 525 300 15],'HorizontalAlignment','left','ForegroundColor','red','String','Items abwaehlen mit Strg','FontSize',10);
handles.p_loadStudies = uicontrol('Parent',handles.tab_SpezData,'Style','pushbutton','units','normalized','String','<html>Lade weitere<br>schon berechnete<br>Studien ein','Position',[0.01 0.05 0.3 0.1],'Callback',@loadStudy);
try
    handles.popup_studies = uicontrol('Parent',handles.tab_SpezData,'Style','popupmenu','units','normalized','Position',[0.01 0.9 0.3 0.07],'String',{bekannteStudien.name},'Callback', @set_StudyData);
catch
    handles.popup_studies = uicontrol('Parent',handles.tab_SpezData,'Style','popupmenu','units','normalized','Position',[0.01 0.9 0.3 0.07],'String',{},'Callback', @set_StudyData);     %handles.popup_studies = []; % error with that there is no gui-popup
end
handles.bg_dataMS = uibuttongroup('Parent',handles.tab_SpezData,'Position',[0 0.4 0.3 0.4]);    
handles.r_dataAll = uicontrol('Parent',handles.bg_dataMS,'Style','radiobutton','units','normalized','String','alle','Position',[0 0.8 1 0.2],'Callback' , @select_allData);
handles.r_dataSpez = uicontrol('Parent',handles.bg_dataMS,'Style','radiobutton','units','normalized','String','Spezifische','Position',[0 0.6 1 0.2],'Callback' , @select_spezData);
handles.bg_dataSpez = uibuttongroup('Parent',handles.bg_dataMS,'Title','Sequenzen','Position',[0.1 0 0.9 0.6],'SelectionChangedFcn',@set_sequenz); 
handles.r_T1mprage = uicontrol('Parent',handles.bg_dataSpez,'Style','radiobutton','units','normalized','String','T1 MPRAGE','Position',[0 0.75 1 0.2],'Enable','Off','Tag','Sequenz1');
handles.r_PDspace = uicontrol('Parent',handles.bg_dataSpez,'Style','radiobutton','units','normalized','String','PD SPACE','Position',[0 0.45 1 0.2],'Enable','Off','Tag','Sequenz2');
handles.r_T1space = uicontrol('Parent',handles.bg_dataSpez,'Style','radiobutton','units','normalized','String','T1 SPACE','Position',[0 0.15 1 0.2],'Enable','Off','Tag','Sequenz3');
handles.r_T1mprage.Value = 0;

handles.list_data1 = uicontrol('Parent',handles.tab_SpezData,'Style','listbox','units','normalized','Position',[0.32 0 0.67 0.99],'Min',0,'Max',50,'Tag','list_data1','Callback',@get_listboxSelection);
try
    handles.list_data1.String = bekannteStudien(1).directories;
    handles.list_data1.Value =  []; % 1:numel(handles.list_data1.String);
    handles.list_data1.UserData = bekannteStudien(1).directories;
catch
    handles.list_data1.String = [];                                         %try to catch the error
    handles.list_data1.Value =  []; % 1:numel(handles.list_data1.String);   %try to catch the error
    handles.list_data1.UserData = [];                                       %try to catch the error
end
handles.p_data = uicontrol('Parent',handles.tab_Alldata,'Style','pushbutton','units','normalized','String','Wähle die gewünschten Datensaetze aus','Position',[0.1 0.88 0.8 0.1],'Callback',@getfolder);
handles.list_data2 = uicontrol('Parent',handles.tab_Alldata,'Style','listbox','units','normalized','Position',[0.1 0.15 0.8 0.69],'String',[],'Value', [], 'Min',0,'Max',50,'Tag','list_data2','Callback',@get_listboxSelection);
handles.p_clearlist = uicontrol('Parent',handles.tab_Alldata,'Style','pushbutton','units','normalized','String','Listbox leeren','Position',[0.1 0.1 0.8 0.05],'Callback',{@clearlist,handles.list_data2});
% ------------------------------------------------------------------------------------------------------------------

% --- ROI/Muskeln (tab 1)
% ------------------------------------------------------------------------------------------------------------------
handles.txt_ROI = uicontrol('Parent',handles.tab1,'Style','text','Position',[430 525 100 15],'HorizontalAlignment','left','String','ROI','FontSize',11);
handles.tgroup_ROI = uitabgroup('Parent', handles.tab1,'units','pixel','Position',[430 170 330 350],'Tag','TabMuscle');
handles.tab_muscle = uitab('Parent',handles.tgroup_ROI, 'Title', 'bekannte ROIs','Tag','tab_muscle');
handles.tab_ROI = uitab('Parent',handles.tgroup_ROI, 'Title', 'ROI laden');
 
handles.p_MuscleAll = uicontrol('Parent',handles.tab_muscle,'Style','pushbutton','units','normalized','String','alle','Position',[0.01 0.8 0.3 0.075],'Callback' , @select_allMuscle);
handles.list_ROI1 = uicontrol('Parent',handles.tab_muscle,'Style','listbox','units','normalized','Position',[0.32 0.6 0.67 0.39],'Min',0,'Max',6,'Tag','list_ROI1','Callback',@get_listboxSelection);
try
    handles.list_ROI1.String = unique( vertcat(bekannteStudien(1).ROInames{:}));
catch
    handles.list_ROI1.String = []; %try to catch the error
end

handles.list_ROI1.UserData = handles.list_ROI1.String;
handles.txt_Muscleinfo = uicontrol('Parent',handles.tab_muscle,'Style','text','units','normalized','Position',[0.01 0.35 1 0.15],'HorizontalAlignment','left',...
    'String','Fuer die Daten der bekannten Studien sind die Textur-Features bereits berechnet. Sie muessen nur extrahiert werden.','FontSize',10);
handles.list_ROI1.Value = []; % 1:numel(handles.list_ROI1.String);
handles.text_muscleWarning = uicontrol('Parent',handles.tab_muscle,'Style','text','units','normalized','Position',[0.01 0.45 1 0.15],'ForegroundColor','red','HorizontalAlignment','left',...
    'String','Diesr Tab kann nur bei bekannten Studien genutzt werden. Wechseln Sie den Tab.','Tag','text_warningMuscle','FontSize',10,'Visible','Off');
% handles.p_get3Dmask = uicontrol('Parent',handles.tab_muscle,'Style','pushbutton','units','normalized','String','Extrahiere die Masken','Position',[0.01 0.35 0.9 0.1],'Callback' , @get_MS_3Dmask);

handles.txt_ROIinfo = uicontrol('Parent',handles.tab_ROI,'Style','text','units','normalized','Position',[0.01 0.75 1 0.25],'HorizontalAlignment','left',...
    'String','Laden Sie die Maske(n) ein. Z.B. die exportierten Masken dem Programm MITK.','FontSize',10);
handles.list_ROI2 = uicontrol('Parent',handles.tab_ROI,'Style','listbox','units','normalized','Position',[0.01 0.4 0.98 0.35],'Min',0,'Max',6,'Tag','list_ROI2','Callback',@get_listboxSelection);
handles.p_loadExternMask = uicontrol('Parent',handles.tab_ROI,'Style','pushbutton','units','normalized','String','Lade Maske(n) ein','Position',[0.05 0.8 0.9 0.1],'Callback' , @load_Extern3Dmask);
handles.p_clearlist_ROI = uicontrol('Parent',handles.tab_ROI,'Style','pushbutton','units','normalized','String','Listbox leeren','Position',[0.2 0.35 0.6 0.05],'Callback',{@clearlist,handles.list_ROI2});

% ------------------------------------------------------------------------------------------------------------------

% --- Features (tab 1)
% ------------------------------------------------------------------------------------------------------------------
handles.txt_feature = uicontrol('Parent',handles.tab1,'Style','text','Position',[770 525 200 15],'HorizontalAlignment','left','String','Textur Features','FontSize',11);

handles.panel_feature = uipanel('Parent', handles.tab1,'unit','pixel','Position',[770 0 530 520]);
handles.p_alleFeatures = uicontrol('Parent',handles.panel_feature,'Style','pushbutton','units','normalized','String','alle von Toolbox','Position',[0.01 0.85 0.3 0.075],'Tag','alleFeatures','Callback',@select_Feature);
handles.p_deselectFeatures = uicontrol('Parent',handles.panel_feature,'Style','pushbutton','units','normalized','String','deselektiere Toolbox','Position',[0.01 0.75 0.3 0.075],'Tag','keineFeatures','Callback',@select_Feature);
handles.p_selectDoubleFeatures = uicontrol('Parent',handles.panel_feature,'Style','pushbutton','units','normalized','HorizontalAlignment','left','String','<html>Features in beiden<br>Toolboxen','Position',[0.01 0.65 0.3 0.075],'Tag','doppelteFeatures','Callback',@select_Feature);

handles.tgroup_feature = uitabgroup('Parent', handles.panel_feature,'Position',[0.32 0 0.68 1],'Tag','FeatureTab');
handles.tab_PORTS = uitab('Parent',handles.tgroup_feature, 'Title', 'PORTS','Tag','tab_PORTS');
handles.tab_radiomics = uitab('Parent',handles.tgroup_feature, 'Title', 'radiomics','Tag','tab_radiomics');
handles.list_PORTS = uicontrol('Parent',handles.tab_PORTS,'Style','listbox','units','normalized','Position',[0 0 0.99 0.999],'Min',0,'Max',90,'Tag','list_PORTS','Callback',@get_listboxSelection);
handles.list_radiomics = uicontrol('Parent',handles.tab_radiomics,'Style','listbox','units','normalized','Position',[0 0 0.99 0.999],'Min',0,'Max',90,'Tag','list_radiomics','Callback',@get_listboxSelection);
handles.list_PORTS.String = strct.features.feature_list.feature_list_PORTS; handles.list_PORTS.Value = [];
handles.list_radiomics.String = strct.features.feature_list.feature_list_radiomics; handles.list_radiomics.Value = []; 
handles.tgroup_feature.SelectedTab = handles.tab_radiomics;

[ind2_PORTS,ind2_radiomics] = strcmp_toolboxes(strct.features.feature_list);
handles.p_selectDoubleFeatures.UserData = {ind2_PORTS ind2_radiomics};

handles.p_calculate = uicontrol('Parent',handles.tab1,'Style','pushbutton','String','Berechnen','Position',[430 110 330 60],'BackgroundColor',[0.84 0.84 1],'Tag','calculate','Callback',@calculateFeature);
handles.p_saveNewStudy = uicontrol('Parent',handles.tab1,'Style','pushbutton','String','Speichere diese Studie','Position',[430 5 330 40],'BackgroundColor',[1 0.84 1],'Callback',@save_newStudy);
handles.c_saveStudyAuomatically = uicontrol('Parent',handles.tab1,'Style','checkbox','String','<html>Speichere Studie automatisch ab <br>in struct "bekannteStudien"','Position',[430 70 330 30],'FontSize',10);

% ------------------------------------------------------------------------------------------------------------------

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
% = = tab 2
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
handles.c_compData = uicontrol('Parent',handles.tab2,'Style','checkbox','String','Vergleiche Aufnahmen','Position',[280 520 200 20],'BackgroundColor',[0.84 0.84 1],'FontSize',10,'Tag','comp_data','Callback',@enable_Subset2list);
handles.c_compROI = uicontrol('Parent',handles.tab2,'Style','checkbox','String','Vergleiche ROIs','Position',[280 500 200 20],'BackgroundColor',[0.84 0.84 1],'FontSize',10,'Tag','comp_ROI','Callback',@enable_Subset2list);
handles.c_compFeature = uicontrol('Parent',handles.tab2,'Style','checkbox','String','Vergleiche Features','Position',[280 480 200 20],'BackgroundColor',[0.84 0.84 1],'FontSize',10,'Tag','comp_feature','Callback',@enable_Subset2list);
handles.p_resetSubsetLists = uicontrol('Parent',handles.tab2,'Style','pushbutton','String','Reset - zeige alle Daten','Position',[0 480 265 30],'FontSize',10,'Tag','resetSubsetLists','Callback',@set_SubsetLists); 
handles.c_activateROIassignment = uicontrol('Parent',handles.tab2,'Style','checkbox','String','Aktiviere ROI Zuordnung','Position',[1080 520 200 20],'BackgroundColor',[0.84 0.84 1],'FontSize',10,'Tag','enable_ROIassignment');

% ------------------------------------------------------------------------------------------------------------------

% --- subset 2 (tab 2)
% ------------------------------------------------------------------------------------------------------------------
handles.panel_set2 = uipanel('Parent',handles.tab2,'unit','pixel','Position',[655 150 645 330],'Title','Set 2');   
handles.set2_txt_data = uicontrol('Parent',handles.panel_set2,'Style','text','units','normalized','Position',[0 0.95 0.2 0.05],'HorizontalAlignment','left','String','Aufnahmen','Tag','set2_txt_data');
handles.set2_list_data = uicontrol('Parent',handles.panel_set2,'Style','listbox','units','normalized','Position',[0 0 0.38 0.94],'Min',0,'Max',50,'Tag','set2_list_data');

handles.set2_txt_ROI = uicontrol('Parent',handles.panel_set2,'Style','text','units','normalized','Position',[0.39 0.95 0.2 0.05],'HorizontalAlignment','left','String','ROI','Tag','set2_txt_ROI');
handles.set2_list_ROI = uicontrol('Parent',handles.panel_set2,'Style','listbox','units','normalized','Position',[0.381 0 0.22 0.94],'Min',0,'Max',6,'Tag','set2_list_ROI');

handles.set2_txt_feature = uicontrol('Parent',handles.panel_set2,'Style','text','units','normalized','Position',[0.61 0.95 0.2 0.05],'HorizontalAlignment','left','String','Textur Features','Tag','set2_txt_feature');
handles.set2_txt_feature1 = uicontrol('Parent',handles.panel_set2,'Style','text','units','normalized','Position',[0.61 0.9 0.2 0.05],'HorizontalAlignment','left','String','PORTS');
handles.set2_txt_feature2 = uicontrol('Parent',handles.panel_set2,'Style','text','units','normalized','Position',[0.805 0.9 0.2 0.05],'HorizontalAlignment','left','String','radiomics');
handles.set2_list_PORTS = uicontrol('Parent',handles.panel_set2,'Style','listbox','units','normalized','Position',[0.61 0 0.195 0.9],'Min',0,'Max',90,'Tag','set2_list_PORTS');
handles.set2_list_radiomics = uicontrol('Parent',handles.panel_set2,'Style','listbox','units','normalized','Position',[0.805 0 0.195 0.9],'Min',0,'Max',90,'Tag','set2_list_radiomics');
set(findall(handles.panel_set2,'-property','enable'),'enable','off')

% ------------------------------------------------------------------------------------------------------------------

% --- subset 1 (tab 2)
% ------------------------------------------------------------------------------------------------------------------
handles.panel_set1 = uipanel('Parent',handles.tab2,'unit','pixel','Position',[0 150 645 330],'Title','Set 1');    
handles.txt_data = uicontrol('Parent',handles.panel_set1,'Style','text','units','normalized','Position',[0 0.95 0.2 0.05],'HorizontalAlignment','left','String','Aufnahmen');
handles.set1_list_data = uicontrol('Parent',handles.panel_set1,'Style','listbox','units','normalized','Position',[0 0 0.38 0.94],'Min',0,'Max',50,'Tag','set1_list_data','Callback',{@copy_SelectionToSet2,handles.set2_list_data,handles.c_compData});

handles.txt_ROI = uicontrol('Parent',handles.panel_set1,'Style','text','units','normalized','Position',[0.39 0.95 0.2 0.05],'HorizontalAlignment','left','String','ROI');
handles.set1_list_ROI = uicontrol('Parent',handles.panel_set1,'Style','listbox','units','normalized','Position',[0.381 0 0.22 0.94],'Min',0,'Max',6,'Tag','set1_list_ROI','Callback',{@copy_SelectionToSet2,handles.set2_list_ROI,handles.c_compROI});

handles.txt_feature = uicontrol('Parent',handles.panel_set1,'Style','text','units','normalized','Position',[0.61 0.95 0.2 0.05],'HorizontalAlignment','left','String','Textur Features');
handles.set1_txt_feature = uicontrol('Parent',handles.panel_set1,'Style','text','units','normalized','Position',[0.61 0.9 0.2 0.05],'HorizontalAlignment','left','String','PORTS');
handles.set1_txt_feature = uicontrol('Parent',handles.panel_set1,'Style','text','units','normalized','Position',[0.805 0.9 0.2 0.05],'HorizontalAlignment','left','String','radiomics');
handles.set1_list_PORTS = uicontrol('Parent',handles.panel_set1,'Style','listbox','units','normalized','Position',[0.61 0 0.195 0.9],'Min',0,'Max',90,'Tag','set1_list_PORTS','Callback',{@copy_SelectionToSet2,handles.set2_list_PORTS,handles.c_compFeature});
handles.set1_list_radiomics = uicontrol('Parent',handles.panel_set1,'Style','listbox','units','normalized','Position',[0.805 0 0.195 0.9],'Min',0,'Max',90,'Tag','set1_list_radiomics','Callback',{@copy_SelectionToSet2,handles.set2_list_radiomics,handles.c_compFeature});

% ------------------------------------------------------------------------------------------------------------------

% --- listbox Vergleiche (tab 2)
% ------------------------------------------------------------------------------------------------------------------
handles.panel_comps = uipanel('Parent',handles.tab2,'unit','pixel','Position',[0 0 1300 150],'Title','Vergleiche');   
handles.p_setSubsets = uicontrol('Parent',handles.panel_comps,'Style','pushbutton','String','Fertig','Position',[575 55 150 40],'BackgroundColor',[0.84 0.84 1],'FontSize',11,'Tag','setSubsets','Callback',@store_SubsetLists);
handles.list_comps1 = uicontrol('Parent',handles.panel_comps,'Style','listbox','units','normalized','Position',[0.194 0 0.2 1],'Min',0,'Max',1,'Tag','list_comps1','Callback',@show_CompSelection);
handles.list_comps2 = uicontrol('Parent',handles.panel_comps,'Style','listbox','units','normalized','Position',[0.6 0 0.2 1],'Min',0,'Max',1,'Tag','list_comps2','Callback',@show_CompSelection);
handles.p_deleteComps = uicontrol('Parent',handles.panel_comps,'Style','pushbutton','String','Loesche Vergleiche','Position',[1130 10 150 40],'Tag','deleteComps','Callback',@delete_Comps);
handles.txt_ROI_list_comps1 = uicontrol('Parent',handles.panel_comps,'Style','text','units','normalized','Position',[0.395 0.9 0.17 0.1],'HorizontalAlignment','left','Visible','off','ForegroundColor','red','String','*ROI: unterschiedliche Auswahl');
handles.txt_ROI_list_comps2 = uicontrol('Parent',handles.panel_comps,'Style','text','units','normalized','Position',[0.801 0.9 0.17 0.1],'HorizontalAlignment','left','Visible','off','ForegroundColor','red','String','*ROI: unterschiedliche Auswahl');

% ------------------------------------------------------------------------------------------------------------------

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
% = = tab 3
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

% --- Analyse (tab 3)
% ------------------------------------------------------------------------------------------------------------------

handles.panel_analyse = uipanel('Parent',handles.tab3,'unit','pixel','Position',[0 150 510 390],'Title','Analyse');    
handles.c_varcoeff = uicontrol('Parent',handles.panel_analyse,'Style','checkbox','String','Variationskoeffizient','Value',1,'Tag','c_varcoeff','Position',[10 350 200 15]);
handles.c_ttest = uicontrol('Parent',handles.panel_analyse,'Style','checkbox','String','T-Test','Value',1,'Position',[10 330 200 15],'Tag','c_ttest');
handles.c_corr = uicontrol('Parent',handles.panel_analyse,'Style','checkbox','String','Korrelationskoeffizient','Value',1,'Tag','c_corr','Position',[10 310 160 15]);
handles.bg_corrNaN = uibuttongroup('Parent',handles.panel_analyse,'unit','pixel','SelectedObject',[],'Position',[180 290 300 40],'BorderType','none');    
handles.r_corrNaN_complete = uicontrol('Parent',handles.bg_corrNaN,'Style','radiobutton','units','normalized','String','verwende nur Zeilen ohne NaNs','Position',[0 0.6 1 0.45]);
handles.r_corrNaN_sort = uicontrol('Parent',handles.bg_corrNaN,'Style','radiobutton','units','normalized','String','verwende alle Zeilen, auch mit NaNs','Position',[0 0.2 1 0.45]);
handles.analysisTable = uitable('Parent',handles.panel_analyse,'Position',[0 0 510 260],'Tag','AnalysisTable','ColumnName',{'cv set1' 'cv set2' 'ttest.h' 'ttest.p' 'corrcoef'},'ColumnWidth',{90 90 60 95 80});
handles.p_analyse = uicontrol('Parent',handles.panel_analyse,'Style','pushbutton','String','Berechne Werte: Set 1 vs. Set 2','Position',[50 260 345 40],'Tag','analyse','Callback',@analysisFeature);
handles.p_featureNames = uicontrol('Parent',handles.panel_analyse,'Style','pushbutton','String','Zeige Feature Namen','Position',[335 350 170 25],'Tag','featureNames','Callback',@show_FeatureNames);
handles.panel_comps = uipanel('Parent',handles.tab3,'unit','pixel','Position',[0 0 515 150],'Title','Vergleiche');   
handles.list_comps3 = uicontrol('Parent',handles.tab3,'Style','listbox','Position',[252 2 260 132],'Min',0,'Max',2,'Tag','list_comps');    

% ------------------------------------------------------------------------------------------------------------------

% --- Visualisierung (tab 3)
% ------------------------------------------------------------------------------------------------------------------

handles.panel_vis = uipanel('Parent',handles.tab3,'unit','pixel','Position',[520 150 220 390],'Title','Visualisierung');   
handles.c_maskOverlay = uicontrol('Parent',handles.panel_vis,'Style','checkbox','String','Bild mit Masken-Overlay','Position',[5 350 200 15],'Tag','MaskenOverlay','Callback',@sationSelection);
handles.c_histo = uicontrol('Parent',handles.panel_vis,'Style','checkbox','String','Histogramm','Position',[5 330 200 15],'Tag','Histogramm','Callback',@get_visualisationSelection);
handles.c_boxplot = uicontrol('Parent',handles.panel_vis,'Style','checkbox','String','Boxplot','Position',[5 310 200 15],'Tag','Boxplot','Callback',@get_visualisationSelection);
handles.c_featspace = uicontrol('Parent',handles.panel_vis,'Style','checkbox','String','Feature Space Plot','Position',[5 290 200 15],'Tag','FeatureSpace','Callback',@get_visualisationSelection);
handles.txt_classFeats = uicontrol('Parent',handles.panel_vis,'Style','text','Position',[20 275 200 15],'HorizontalAlignment','left','String','Klassifizieren nach:');
handles.bg_FeatSpace = uibuttongroup('Parent',handles.panel_vis,'unit','pixel','SelectedObject',[],'Position',[20 235 200 40],'BorderType','none');    
handles.r_FeatSpace_ROI = uicontrol('Parent',handles.bg_FeatSpace,'Style','radiobutton','units','normalized','String','ROIs','Position',[0 0.6 1 0.45]);
handles.r_FeatSpace_Data = uicontrol('Parent',handles.bg_FeatSpace,'Style','radiobutton','units','normalized','String','Aufnahmen','Position',[0 0.2 1.1 0.45]);
handles.txt_FeatSpace = uicontrol('Parent',handles.panel_vis,'Style','text','Position',[20 225 100 15],'HorizontalAlignment','left','String','Max. Plots:');
handles.edit_maxFeatPlots = uicontrol('Parent',handles.panel_vis,'Style','edit','units','pixel','String','20','Position',[130 225 45 15],'Callback',@checkNumericInput);
handles.c_kiviat = uicontrol('Parent',handles.panel_vis,'Style','checkbox','String','Kiviat (Radar-)Diagramm','Position',[5 205 200 15],'Tag','Kiviat','Callback',@get_visualisationSelection);
handles.txt_kiviat = uicontrol('Parent',handles.panel_vis,'Style','text','Position',[35 173 150 32],'HorizontalAlignment','left','String','3-10 Features sinnvoll; optimal: 5-7');


handles.list_comps4 = uicontrol('Parent',handles.tab3,'Style','listbox','Position',[740 350 260 132],'Min',0,'Max',2);    
handles.txt_imagine = uicontrol('Parent',handles.tab3,'Style','text','Position',[1010 485 260 35],'HorizontalAlignment','left','String','Liste mit Vergleichen, die schon in Imagine geoeffnet sind:');
handles.list_compsImagine = uicontrol('Parent',handles.tab3,'Style','listbox','Position',[1010 350 260 132],'Min',0,'Max',2,'Tag','ImagineList');    
handles.p_imagine = uicontrol('Parent',handles.tab3,'Style','pushbutton','String','Visualisieren mit Imagine','Position',[740 300 260 40],'Tag','imagine','Callback',@visualizeFeature);
% handles.p_closeFig = uicontrol('Parent',handles.tab3,'Style','pushbutton','String','Schliesse ueberfluessige Fenster','Position',[1040 5 260 40],'Callback',@closeFigureWindows);

% Make figure visble after adding all components
handles.f.Visible = 'on';

end

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% * * 
% * * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% * * tab 1 functions
% * * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% * * 
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% 
function my_closereq(src,callbackdata)
% Close request function 
% to display a question dialog box 
   selection = questdlg('Close This Figure?',...
      'MainGUI',...
      'Yes','No','Yes'); 
   switch selection
      case 'Yes'
         delete(gcf)
      case 'No'
      return 
   end
end

function set_StudyData(hObject,~) %KRITISCH
    global bekannteStudien
    global handles
    global strct
    studyName = hObject.String(hObject.Value);
%     idx = strcmp({bekannteStudien.name},studyName);
    idx = hObject.Value;
    % correct field: bekannteStudien(idx)
    
    % update listboxes with study content
    %   data
    handles.list_data1.String = bekannteStudien(idx).directories;
    handles.list_data1.Value = 1:numel(handles.list_data1.String);
    if strcmp(studyName,'MS-Studie')
        handles.bg_dataMS.Visible = 'on';
    else
        handles.bg_dataMS.Visible = 'off';
    end
    
    %   ROI
    handles.list_ROI1.String = unique( vertcat(bekannteStudien(idx).ROInames{:}));
    handles.list_ROI1.Value = 1:numel(handles.list_ROI1.String);
    
    %   features
    handles.list_PORTS.String = strct.features.feature_list.feature_list_PORTS(bekannteStudien(idx).selectedFeatures{1});
    handles.list_PORTS.Value = 1:numel(handles.list_PORTS.String);
    handles.list_radiomics.String = strct.features.feature_list.feature_list_radiomics(bekannteStudien(idx).selectedFeatures{2});
    handles.list_radiomics.Value = 1:numel(handles.list_radiomics.String);
end

function loadStudy(~,~)
    global handles
    global bekannteStudien
    duplicate = 0;
    a = 1;
    [file,path] = uigetfile('*.mat','Lade alle bekannten Studien','MultiSelect', 'on');
    dir = fullfile(path,file);
    if ~iscell(dir) % then only 1 input
        dir = cellstr(dir); 
    end
    
    hLoad = showWaitbar_loadData([],1,'Lade "bekannteStudien.mat" ...');
    
    for i=1:length(dir)
        temp = load(dir{i});
        bekannteStudien = [bekannteStudien temp.bekannteStudien];
    end
    % find empty elements (should be at least element 1)
    emptyIndex = find(arrayfun(@(x) isempty(x.ROI),bekannteStudien));
    bekannteStudien(emptyIndex) = [];
    showWaitbar_loadData(hLoad,0);
    handles.popup_studies.String = {bekannteStudien.name};
end

function save_newStudy(~,~,manually,answer,save_name)
    global strct
    if nargin < 3, manually = 1; end
    if manually
        choice = questdlg({'Wurden die Features zuvor schon berechnet?', '(nur dann sinnvoll)'},'Studie speichern');
        if ~strcmp(choice,'Yes') 
            warning('Speichern abgebrochen')
            return;
        end
        
         % get new study name
        prompt = {'Name der Studie:'};
        dlg_title = 'Eingabe neue Studie';
        answer = inputdlg(prompt,dlg_title);
        if isempty(answer)
            warning('Speichern der Studie wurde abgebrochen.')
            return;
        end
    end
   
    hLoad = showWaitbar_loadData([],1,'Berechne Daten und lege sie im struct ab ...');
    % value of new elemnt in struct
    bekannteStudien = struct('name',[],'directories',[],'data',[],'dicominfo',[],'ROI',[],'ROInames',[],'ROIdirectories',[],'features',[],'selectedFeatures',[]);
    
    % = = = = = = = = = = = = = = = = = 
    bekannteStudien.name = answer{1};
    bekannteStudien.directories = strct.data;
    bekannteStudien.ROIdirectories = transpose(strct.ROI.directories);
%     if ~ischar(strct.ROI.names{1})
%         bekannteStudien(n).ROInames = cellfun(@(x) char(x),strct.ROI.names,'UniformOutput',false);
%     else 
%         bekannteStudien(n).ROInames = strct.ROI.names;
%     end
    bekannteStudien.features.PORTS = strct.features.PORTS.array;
    bekannteStudien.features.radiomics = strct.features.radiomics.array;
    [~,idx1,~] = intersect(strct.features.feature_list.feature_list_PORTS,strct.features.PORTS.featureNames);
    [~,idx2,~] = intersect(strct.features.feature_list.feature_list_radiomics,strct.features.radiomics.featureNames);
    bekannteStudien.selectedFeatures{1}  = idx1;
    bekannteStudien.selectedFeatures{2} = idx2;
    % = = = = = = = = = = = = = = = = = 

    % get 3D matrices from images and the dicominfo
    sPathImg = bekannteStudien.directories;
    for i=1:numel(sPathImg)
        [dImg{i},dicominfo{i}] = ReadDICOM(sPathImg{i});
    end

    % = = = = = = = = = = = = = = = = = 
    bekannteStudien.data = dImg';
    bekannteStudien.dicominfo = dicominfo';
    % = = = = = = = = = = = = = = = = = 

    splits = cellfun(@(x) regexp(x,'/','split'),strct.ROI.names,'UniformOutput',false);
    try
    for i = 1: numel(splits)
        names{i} = cellfun(@(x) x{end},transpose(splits{i}),'UniformOutput',false);
    end
    catch
        names = splits;
    end
    
    % = = = = = = = = = = = = = = = = = 
%     bekannteStudien(n).ROI = lMask';
    bekannteStudien.ROI = transpose(strct.ROI.lMask);
    bekannteStudien.ROInames = names;
    % = = = = = = = = = = = = = = = = = 

    showWaitbar_loadData(hLoad,0);
    if manually
        openvar('bekannteStudien')
        msg = {'Ueberpruefe, ob die neu eingelesenen Daten korrekt sind.', 'Schaue dazu das struct "bekannte Studien" an.', 'Wenn ja, klicke "OK".'};
        title = 'Werte der neuen Studie sind geladen';
        h = msgbox(msg, title);
        uiwait(h)
    end

    if manually
        choice = questdlg('Soll das neue struct wirklich gespeichert werden?','Struct speichern');
    else
        choice = 'Yes';
    end
    if strcmp(choice,'Yes')
        % get study name for saving struct
        if manually
            validName = 0;
            while validName ==0
                prompt = {'Dateiname der .mat-Datei:'};
                dlg_title = 'Speicher-Eingabe';
                answer = inputdlg(prompt,dlg_title);
                save_name = char(strcat(answer,'.mat'));
                if exist(save_name,'file') ~= 2
                    validName = 1;
                else
                    warning('Dateinname existiert schon. Gib einen anderen ein.')
                end 
            end
        end
        hLoad = showWaitbar_loadData([],1,'Speichere neues struct ...');
        save(save_name,'bekannteStudien','-v7.3')
        
        bekannteStudienNeu = bekannteStudien;
        global bekannteStudien
        bekannteStudien = [bekannteStudien bekannteStudienNeu];
        handles.popup_studies.String = {bekannteStudien.name};
        
        showWaitbar_loadData(hLoad,0);
    end

end % end function save_newStudy

function [row,col] = strcmp_toolboxes(features)
    ind =cell(numel(features.feature_list_PORTS),numel(features.feature_list_radiomics));
    for i = 1:numel(features.feature_list_PORTS)
        for j=1:numel(features.feature_list_radiomics)
            ind{i,j} = strcmpi(features.feature_list_PORTS{i}, features.feature_list_radiomics{j});
        end
    end
    ind = cell2mat(ind);
    [row,col]=find(ind==1);
end

function selectedDataTab(varargin)
    h = findobj(gcf,'Tag','DataTab');
    seq = h.SelectedTab;
    str = char(seq.Title);
    t = findobj(gcf,'Tag','text_warningMuscle');
    listROI = findobj(gcf,'Tag','list_ROI1');
    if strcmp(str,'+')
        t.Visible = 'On';
        listROI.Value = [];
        listROI.Enable = 'off';
    else
        t.Visible = 'Off';
        listROI.Enable = 'on';
    end
end

function select_allData(varargin)
    h = findobj(gcf,'Tag','list_data1');
    data = h.String;
    h.Value = 1:length(data);
    get_listboxSelection(h,[])
    h = findobj(gcf,'-regexp','Tag','Sequenz');
    for i = 1:numel(h)
        h(i).Enable = 'Off';
    end
end

function select_spezData(varargin)
    h = findobj(gcf,'-regexp','Tag','Sequenz');
    for i = 1:numel(h)
        h(i).Enable = 'On';
        h(i).Value = 0;
    end
end

function set_sequenz(object,~)
    h = findobj(gcf,'Tag','list_data1');
    seq = object.SelectedObject;
    str = char(seq.String);
    if strcmp(str,'T1 MPRAGE')
        h.Value = [1 4 6 8 11 16];
    elseif strcmp(str,'PD SPACE')
        h.Value = [2 7 9 12 14 17];
    elseif strcmp(str,'T1 SPACE')
        h.Value = [3 5 10 13 15 18];
    else
        h.Value = [];
    end
    try
        get_listboxSelection(h,[])
    catch
    end
end

function get_listboxSelection(object,~)
    object.UserData = object.String(object.Value);
end

function getfolder(varargin)
    global handles                  %opens OS interface tool of matlab
    folder_name = uigetdir(mfilename('fullpath'));
    %folder_name = uigetdir(handles.list_data1.String{1});   % opens OS
    %window folder open - JANA
    %Select right OS-PathCode
        if ismac
        msgbox('Operating System is not supported');return;     % toDo!
        elseif isunix
        dirs = regexp(genpath(folder_name),'[^:]*','match');
        elseif ispc
        dirs = regexp(genpath(folder_name),'[^;]*','match');
        else
        msgbox('Operating System is not supported');return;
        end   
    hLoad = showWaitbar_loadData([],1); %shows loadwindow 
    % check if folders contain dicom images - if not: don't display them in listbox
    SFiles = [];    %
    cNames = [];    %contentNames
    for i=1:numel(dirs)
        SFiles{i} = dir(dirs{i});
        cNames{i} = {SFiles{i}(:).name};
        lInd = cellfun(@(x) any(strcmpi(x(end-3:end),{'.ima','.dcm'})), cNames{i}(3:end)); % skip unwanted files
        list_dcm = cNames{i}(lInd);
        if strfind(dirs{i},'localizer')
            dirs{i} = [];
        end
        if isempty(list_dcm)
            dirs{i} = [];
        end
    end
    list = dirs(~cellfun('isempty',dirs))';

    out = list;
    h = findobj(handles.f,'Tag','list_data2');
    h.String = [h.String; out];
    get_listboxSelection(h,[]);
    showWaitbar_loadData(hLoad,0);
end

function clearlist(~,~,listbox)
    global strct
    listbox.String = [];  
    listbox.UserData = [];
end

function select_allMuscle(varargin)
    h = findobj(gcf,'Tag','list_ROI1');
    cont = h.String;
    h.Value = 1:length(cont);
end

function load_Extern3Dmask(varargin)
    global handles
    warning('Achte auf die Masken-Orientierung. Musss sie gedreht/gespiegelt werden?')
    path_img = '/net/linse8-sn/no_backup_00/med_data/Texture/TA_Muscle/MSStudie/'; %hard coded? why?
    [file_mask, pathname] = uigetfile({'*.mha;*.mhd','Meta-Images'; '*.*','All Files'},'Select mask file',path_img,'MultiSelect','on'); %no differnece of different os's
    if isequal(pathname,0)
        return;
    end
    if ischar(file_mask), file_mask = cellstr(file_mask); end
    handles.list_ROI2.String = vertcat(handles.list_ROI2.String, fullfile(pathname,file_mask));
    handles.list_ROI2.Value = 1:length(handles.list_ROI2.String);
end

function [ROI,ROInames,iROIassign] = assign_MaskToData(~,~,input_data, input_ROI, tabSpec)
%     try showWaitbar_loadData(hLoad,0); end
    global handles
    global strct
    
    title = '';
    if numel(input_data)>1, title = '';
    elseif strcmp(input_data.Tag,'set1_list_data'), title = ' - Set 1';
    elseif strcmp(input_data.Tag,'set2_list_data'), title = ' - Set 2'; end
    
    m = figure('units','pixel','Position',[300 300 600 300]);
    m.Name = ['ROIs zuordnen', title];
    list_data = uicontrol('Parent',m,'Style','popupmenu','units','pixel','Position',[5 255 290 20],'Callback',@dataSelection);
    list_ROI = uicontrol('Parent',m,'Style','listbox','units','pixel','Position',[305 5 290 270],'Min',0,'Max',2,'Callback',@getROIassignment);
    txt_dataAll = uicontrol('Parent',m,'Style','text','Position',[5 180 290 70],'HorizontalAlignment','left','FontSize',10);
    p_vor = uicontrol('Parent',m,'Style','pushbutton','units','pixel','Position',[55 150 70 20],'String','zurueck','Callback',@dataSelection); 
    p_back = uicontrol('Parent',m,'Style','pushbutton','units','pixel','Position',[130 150 70 20],'String','vor','Callback',@dataSelection); 
    c_allSelection = uicontrol('Parent',m,'Style','checkbox','units','pixel','Position',[55 100 240 30],'String','<html>Alle verfuegbaren ROIs fuer alle <br>Daten auswaehlen','Callback',@set_allSelection);
    c_sameSelection = uicontrol('Parent',m,'Style','checkbox','units','pixel','Position',[55 60 240 30],'String','<html>Diese Auswahl fuer alle anderen <br>Aufnahmen uebernehmen','Callback',@set_SameROIassignment);
    txt_data = uicontrol('Parent',m,'Style','text','Position',[5 278 100 17],'HorizontalAlignment','left','String','Aufnahmen','FontSize',11);  
    txt_ROI = uicontrol('Parent',m,'Style','text','Position',[305 278 100 17],'HorizontalAlignment','left','String','ROIs','FontSize',11);
    p_confirm = uicontrol('Parent',m,'Style','pushbutton','units','pixel','Position',[55 20 190 30],'String','Bestaetigen','Callback',@close_ROIAssignment);  

    if numel(input_data) > 1
        list_data.String = [input_data(1).String(input_data(1).Value); input_data(2).String(input_data(2).Value)];
    else
        list_data.String = input_data.String(input_data.Value);
    end
    try
        txt_dataAll.String = list_data.String(list_data.Value);
    catch
        error('Keine Aufnahmen ausgewaehlt')
    end
    set_ROIstring(1);
    
    init = cell(1,length(list_data.String));
    ROIassign.val = []; ROIassign.String = []; ROIassign.iROIassign = [];
    ROIassign(length(list_data.String)).val = []; % initialize struct to right size
    ROI = 0; ROInames = 0; iROIassign = [];

    uiwait(m);
    
    function dataSelection(hObject,~) 
        if strcmp(hObject.String,'vor')
            iCnt = 1;
        elseif strcmp(hObject.String,'zurueck')
            iCnt = -1;
        else % dann manuelle Selektion
            iCnt = 0;
        end
        iNewVal = list_data.Value + iCnt;
        iNewVal = max([iNewVal, 1]);
        iNewVal = min([iNewVal, length(list_data.String)]);
        
        list_data.Value = iNewVal;
        txt_dataAll.String = list_data.String(list_data.Value);
        
        if tabSpec == 1
            set_ROIstring(iNewVal)
        elseif tabSpec == 2 || tabSpec == 3
            set_ROIstring(input_data.Value(iNewVal))
        end
        
        list_ROI.Value = ROIassign(iNewVal).val;
    end
    
    function set_ROIstring(dataVal_popup)
        ROItemp = strct.ROI.names;
        if tabSpec == 1
                  ROItemp = [];     
        end
        ROIstring_input =  input_ROI.String(input_ROI.Value);
        try
            ROIstring_stored =  ROItemp{dataVal_popup};
            list_ROI.String = intersect(ROIstring_input,ROIstring_stored);
        catch
            list_ROI.String = ROIstring_input;
        end
        list_ROI.Value = [];
    end

    function getROIassignment(varargin)
        ROIassign(list_data.Value).val = list_ROI.Value;
        ROIassign(list_data.Value).String = list_ROI.String(list_ROI.Value);
        if tabSpec == 2 || tabSpec == 3
%             [~,idxROI_list,~] = intersect(input_ROI.String,list_ROI.String(list_ROI.Value));
            ROIassign(list_data.Value).iROIassign = 1; % idxROI_list;
        end
    end
    
    function set_allSelection(hObject,~)
        if hObject.Value == 0, return; end
        list_val = horzcat(input_data(:).Value);
        for i = 1:length(ROIassign)
            idx = list_val(i);
            if tabSpec == 1
                ROIassign(i).String = input_ROI.String(input_ROI.Value);
            else
                ROIassign(i).String = intersect(input_ROI.String(input_ROI.Value),strct.ROI.names{idx});
            end
            ROIassign(i).val = numel(ROIassign(i).String);
            if tabSpec == 2 || tabSpec == 3
                ROIassign(i).iROIassign = 1;
            end
        list_ROI.Value = 1:ROIassign(i).val;
        end
    end

    function set_SameROIassignment(hObject,~)
        if hObject.Value == 0, return; end
        % check if sameROIs ==1 or ROI assignment in tab 1
        if tabSpec~=1 && strct.ROI.sameROIs == 0
            warning('Diese Option ist nicht verfuegbar, da die ROIs nicht fuer alle Daten gleich sind.')
            hObject.Value = 0;
            return;
        end
        [ROIassign.val] = deal(list_ROI.Value);
        [ROIassign.String] = deal(list_ROI.String(list_ROI.Value));
        if tabSpec == 1
            handles.list_ROI2.Value = list_ROI.Value;
        end
    end

    function close_ROIAssignment(~,~)   
%         any( structfun(@isempty, ROIassign.val)) % doesn't work
        for i = 1:length(ROIassign)
            isEmpty{i} = ROIassign(i).val;
        end
        isEmpty = cellfun(@(x) isempty(x),isEmpty, 'UniformOutput',false);
        if any(cell2mat(isEmpty))
            isEmpty = cell2mat(isEmpty);
            items = find(isEmpty>0);
            error(['Es wurden nicht jeder Aufnahme ROIs zugeordnet. Fehler in Aufnahme(n): ' num2str(items)])
        end
        
        ROI = []; ROInames = []; iROIassign = [];
        if tabSpec == 1
            str = ROIassign(1).String;
            isSame = 1; % assumption that ROIs are the same
            for i = 1:length(ROIassign)
                ROInames{i} = transpose(ROIassign(i).String);
                for j = 1:numel(str)
                    try
                        if ~strcmp(str{j},ROIassign(i).String{j})
                            isSame = 0;
                        end
                    catch % if cell length is not the same ROI selection can't be equal
                        isSame = 0;
                    end
                end
            end
            strct.data = list_data.String;
            handles.list_ROI2.UserData = ROInames;
            % compare if all ROIs are the same for all datasets
            if isSame
                strct.ROI.sameROIs = 1;
            else
                strct.ROI.sameROIs = 0;
            end
            handles.list_ROI2.Value = unique(horzcat(ROIassign.val));
        elseif tabSpec == 2 || tabSpec == 3
            for i = 1:length(ROIassign)
                ROI{i} = strct.ROI.lMask{input_data.Value(i)}(ROIassign(i).val);
                ROInames{i} = transpose(ROIassign(i).String);
                iROIassign{i} = ROIassign(i).iROIassign;
            end
        end
                
        try %#ok<TRYNC>
            close(m);
        end
    end
end

function select_Feature(object,~)
    h = findobj(gcf,'Tag','FeatureTab');
    toolbox = h.SelectedTab;
    list_name = char(['list_' toolbox.Title]);
    featlist = findobj(gcf,'Tag',list_name);    
    str = char(object.Tag);
    if strcmp(str,'alleFeatures')
        featlist.Value = 1:numel(featlist.String);
    elseif strcmp(str,'keineFeatures')
        featlist.Value = [];
    elseif strcmp(str,'doppelteFeatures')
        hp = findobj(gcf,'Tag','list_PORTS');
        hr = findobj(gcf,'Tag','list_radiomics');
        hp.Value = object.UserData{1};
        hr.Value = object.UserData{2};
    end
    get_listboxSelection(featlist,[])
end

function [feat_names, idx_order] = get_realFeatureNames(category,toolbox_tag)
    global strct
    if strcmp(char(toolbox_tag),'PORTS')
        list = strct.features.feature_list.feature_list_PORTS;
    elseif strcmp(char(toolbox_tag),'radiomics')
        list = strct.features.feature_list.feature_list_radiomics;
    end
    
    feat_names = {};
    idx_order = 0; 
    basisNames = fieldnames(category);
    for i= 1:numel(basisNames)
            val = category.(basisNames{i});
            if val == 1
                temp_names = findCategoriesInList(list,basisNames{i});
                feat_names = [feat_names; temp_names];
                switch basisNames{i}
                    case 'Histogram'
                        idx_new = [1 2 3]'; % normal                    
                    case 'GTSDM'
                        idx_new = [1 2 5 4 6 3 7 8]';
                    case 'NGTDM'
                        idx_new = [1 2 3 4 5]'; % normal
                    case 'GLZSM'
                        idx_new = [1 2 6 7 8 9 10 11 3 4 5 12 13]';
                    case 'GLRLM'
                        idx_new = [1:length(list(30:end))]'; % normal
                end
                try
                idx_order = [idx_order; idx_new + max(idx_order)]; 
                end
            end
    end
    idx_order = idx_order(2:end); % delete zero from intialization   
end

function names = findCategoriesInList(list,tag)
    names ={};
    if strcmp(char(tag),'Moments')
        names = transpose({list{1:6}});
    end
    for j=1:numel(list)
        ex = regexp(list{j}, tag,'once');
        if ~isempty(ex)
            if isempty(names)
                names = {list{j}};
            else
                names = [names; list{j}];
            end
        end
    end
end

function calculateFeature(varargin)    
    global strct
    global handles
    
    nameNewStudy = [];
    if handles.c_saveStudyAuomatically.Value == 1
        % get new study name
        prompt = {'Name der Studie:'};
        dlg_title = 'Eingabe neue Studie';
        nameNewStudy = inputdlg(prompt,dlg_title);
        if isempty(nameNewStudy)
            warning('Abgebrochen. Kein Name eingegeben.')
            return;
        end
        
        validName = 0;
        while validName ==0
            prompt = {'Dateiname der .mat-Datei:'};
            dlg_title = 'Speicher-Eingabe';
            answer = inputdlg(prompt,dlg_title);
            save_name = char(strcat(answer,'.mat'));
            if exist(save_name,'file') ~= 2
                validName = 1;
            else
                warning('Dateinname existiert schon. Gib einen anderen ein.')
            end 
        end
    end
    
    % get Feature selection
    l1 = handles.list_PORTS;
    feature_PORTS = l1.String(l1.Value);
    l2 = handles.list_radiomics;
    feature_radiomics = l2.String(l2.Value);
    if isempty(feature_PORTS) && isempty(feature_radiomics)
        error('Keine Features ausgewaehlt - keine Berechnung moeglich.');
    end
    
    % get data selection
    data_tab = handles.tgroup_data.SelectedTab;         
    str_data = char(data_tab.Title);
    data = findobj(data_tab,'Style','listbox');
    data_array = [handles.list_data1.UserData; handles.list_data2.UserData]; %KRITISCH
    if isempty(data_array)
        error('Keine Daten ausgewaehlt - keine Berechnung moeglich.');
    end
    
    % get ROI selection
    ROI_tab = handles.tgroup_ROI.SelectedTab;
    str_ROI = char(ROI_tab.Title);
    ROI = findobj(ROI_tab,'Style','listbox');
    if isempty(ROI.Value)
        error('Keine ROIs ausgewaehlt - keine Berechnung moeglich.');
    end
    
    msg = {'Lade Daten ...';'Ausgewaehlt;';['bekannte Studien: ', num2str(length(handles.list_data1.UserData))]; ['+: ',num2str(length(handles.list_data2.UserData))]; ...
        ['ROIs: ', num2str(length(ROI.Value))]; ['PORTS: ',num2str(length(feature_PORTS))]; ['radiomics: ',num2str(length(feature_radiomics))]};
    hLoad =  showWaitbar_loadData([],1,msg);
    
    % -----------------------------------------------------
    % ---- get correct mask matrices ----------------------
    % -----------------------------------------------------
    
    if strcmp(str_data,'bekannte Studien') && strcmp(str_ROI,'bekannte ROIs')
        % dann sind Masken schon in struct "bekannte Studien gespeichert" -> Extrahieren
        global bekannteStudien
        idx = handles.popup_studies.Value;
        
        % falls Aufnahmen in Tab "+" ausgewaehlt sein sollten, werden diese ignoriert
        strct.data = data.String(data.Value);
        for i = 1:numel(data.Value)
            for j = 1:numel(ROI.Value)
                lMask{i}{j} = bekannteStudien(idx).ROI{data.Value(i)}{ROI.Value(j)};
                names{i}{j} = bekannteStudien(idx).ROInames{data.Value(i)}{ROI.Value(j)};
                dir{i}{j} = bekannteStudien(idx).ROIdirectories{data.Value(i)}{ROI.Value(j)};
            end
        end
        strct.ROI.names = names;
        strct.ROI.lMask = lMask;
        strct.ROI.directories = dir;
        strct.ROI.sameROIs = 1;
        strct.features.PORTS.array = bekannteStudien(idx).features.PORTS(l1.Value,ROI.Value,data.Value);
        strct.features.PORTS.featureNames = strct.features.feature_list.feature_list_PORTS(l1.Value);
        strct.features.radiomics.array = bekannteStudien(idx).features.radiomics(l2.Value,ROI.Value,data.Value); 
        strct.features.radiomics.featureNames = strct.features.feature_list.feature_list_radiomics(l2.Value);        
    else
        % komplexer, Masken muessen erst berechnet werden aus *.mha Files und dann muessen auch die Features berechnet werden
        [default1, default2,~] = assign_MaskToData([],[],[handles.list_data1; handles.list_data2],handles.list_ROI2,1); %
        if isequal(default1,0) && isequal(default2,0), showWaitbar_loadData(hLoad,0); return; end             
            % strct.ROI.sameROIs                already assigned in the function assign_MaskToData
            % strct.data
            
            % -----------------------------------------------------
            % ---- calculate masks -----------------------------
            % -----------------------------------------------------
            hWait = showWaitbar('Extrahiere Masken', 0); count = 0;
                        
            lMask = [];
            maskFile = ROI.UserData;
            for i = 1:numel(data_array)
                for j=1:numel(maskFile{i})
                    [~,~,datatype_of_mask]=fileparts(maskFile{i}{j});
                    which_file_type = strfind(maskFile{i}{j},'.mat'); %isMatFile hat Jana als Variable benutzt
                    switch datatype_of_mask
                        case '.mat'
                            temp = load(maskFile{i}{j});
                            fn = fieldnames(temp);
                            lMask{i}{j} = temp.(fn{1});
                       
                        case '.mha'
                            lMask{i}{j} = main_read_mask(maskFile{i}{j});  
                            lMask{i}{j} = permute(lMask{i}{j},[3 1 2]); % permute matrix to flip matrix along 3rd dimension
                            lMask{i}{j}= flipud(lMask{i}{j});
                            lMask{i}{j} = permute(lMask{i}{j},[3 2 1]); % permute 3rd dimension back and change swap 1st and 2nd dimensions
                            
                        case '.mhd'
                            lMask{i}{j} = main_read_mask(maskFile{i}{j});  
                            lMask{i}{j} = permute(lMask{i}{j},[3 1 2]); % permute matrix to flip matrix along 3rd dimension
                            lMask{i}{j}= flipud(lMask{i}{j});
                            lMask{i}{j} = permute(lMask{i}{j},[3 2 1]); % permute 3rd dimension back and change swap 1st and 2nd dimensions
                           
                        case '.nii'
                            lMask{i}{j} = get_biggest_ROI_from_nii(maskFile{i}{j}); %Caution you get really just the bigges ROI in the nii-File!
                    end
                    
                end
                if strct.ROI.sameROIs
                    for i = 2:numel(data_array)
                        lMask{i} = lMask{1};
                    end
                    break;
                end
                count=count+1;
                hWait = showWaitbar('Extrahiere Masken', count/numel(data_array), hWait);
            end
            showWaitbar('Extrahiere Masken', 'Close', hWait);
            strct.ROI.names = ROI.UserData;
            strct.ROI.directories = ROI.UserData;
            strct.ROI.lMask = lMask;
            ROI.UserData = lMask;
            ROI_array = lMask;
        
        % -----------------------------------------------------
        % ---- calculate features -----------------------------
        % -----------------------------------------------------
        ROI_numel = max(cell2mat(cellfun(@(x) numel(x),strct.ROI.names,'UniformOutput',false)));
        feat_PORTS = cell(numel(feature_PORTS),ROI_numel,length(data_array)) ; feat_names_PORTS =[]; % cell(feature_PORTS,length(ROI.Value),length(data_array))
        feat_radiomics = cell(numel(feature_radiomics),ROI_numel,length(data_array)); feat_names_radiomics =[];    
        % calculate the features new
            category = struct;     
            % check which toolboxes are selected
            if~isempty(feature_PORTS)
                hWait = showWaitbar('Calculating PORTS features', 0); count = 0;
                category = getFeatureCategories(feature_PORTS);
                [feat_names_PORTS,~] = get_realFeatureNames(category,char('PORTS'));
                feat_PORTS = cell(numel(feat_names_PORTS),numel(ROI_array),numel(data_array));
                for i=1:numel(data_array)
                    temp_feat_PORTS = [];
                    [~,idx,~] = intersect(ROI.String(ROI.Value),strct.ROI.names{i});    
                    for j=1:numel(ROI_array{1})
                        temp_feat_PORTS = run_PORTS(char(data_array{i}),ROI_array{i}{j},category);
                        feat_PORTS(:,idx(j),i) = temp_feat_PORTS;
                        count=count+1;
                        hWait = showWaitbar('Calculating PORTS features', count/(numel(data_array)*numel(ROI_array{1,1})), hWait);
                    end
                end
                showWaitbar('Calculating PORTS features', 'Close', hWait);
            end
            if ~isempty(feature_radiomics)
                hWait = showWaitbar('Calculating radiomics features', 0); count = 0;
                category = getFeatureCategories(feature_radiomics);
                [feat_names_radiomics,idx_order] = get_realFeatureNames(category,char('radiomics'));
                feat_radiomics = cell(numel(feat_names_radiomics),numel(ROI_array{1,1}),numel(data_array));
                for i=1:numel(data_array)
                    [~,idx,~] = intersect(ROI.String(ROI.Value),strct.ROI.names{i});  
                    for j=1:numel(ROI_array{i})  
                        feat_radiomics(:,idx(j),i) = run_radiomics(char(data_array{i}),ROI_array{i}{j},category);

                        count=count+1;
                        hWait = showWaitbar('Calculating radiomics features', count/(numel(data_array)*numel(ROI_array{1,1})), hWait);
                    end
                end
                % get "official" names and for radiomics toolbox the correct order of the features
                feat_radiomics = feat_radiomics(idx_order,:,:); % cell2mat??
                showWaitbar('Calculating radiomics features', 'Close', hWait);
            end

            strct.features.PORTS.array = feat_PORTS; strct.features.PORTS.featureNames = feat_names_PORTS;
            strct.features.radiomics.array = feat_radiomics; strct.features.radiomics.featureNames = feat_names_radiomics;
    end
    
    set_SubsetLists();
    disp('Fertig gerechnet')
    showWaitbar_loadData(hLoad,0);
        
    if handles.c_saveStudyAuomatically.Value == 1
        save_newStudy([],[],0,nameNewStudy,save_name)
    end
end

function categories = getFeatureCategories(list)
    categories = struct('Moments',0,'Histogram',0,'GTSDM',0,'NGTDM',0,'GLZSM',0,'GLRLM',0);
%     categories = [0 0 0 0 0 0]
for i=1:numel(list)
    if strfind(list{i},'Histogram')
        categories.Histogram = 1;
    elseif strfind(list{i},'GTSDM')
        categories.GTSDM = 1;
    elseif strfind(list{i},'NGTDM')
        categories.NGTDM = 1;
    elseif strfind(list{i},'GLZSM')
        categories.GLZSM = 1;
    elseif strfind(list{i},'GLRLM')
        categories.GLRLM = 1;
    else
        categories.Moments = 1;
    end
end
end

function hWait = showWaitbar(sMessage, dValue, hWait)
    if(exist('multiWaitbar','file'))
        multiWaitbar(sMessage, dValue);
        hWait = 0;
    else
        if(nargin < 3)
            hWait = waitbar(dValue, sMessage);
        else
                if(isnumeric(dValue))
                    try % try: might already be closed manually
                        waitbar(dValue, hWait);
                    end
                else % close waitbar
                    try % try: might already be closed manually
                        close(hWait);
                    end
                end
        end
    end
end

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% * * 
% * * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% * * tab 2 functions
% * * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% * * 
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

function set_SubsetLists(~,~)
    global strct
    global handles
    % set strings
    handles.set1_list_data.String = strct.data;
    handles.set2_list_data.String = strct.data;
    handles.set1_list_ROI.String = unique(vertcat(strct.ROI.names{:}));
    handles.set2_list_ROI.String = unique(vertcat(strct.ROI.names{:}));
    handles.set1_list_PORTS.String = strct.features.PORTS.featureNames;
    handles.set2_list_PORTS.String = strct.features.PORTS.featureNames;
    handles.set1_list_radiomics.String = strct.features.radiomics.featureNames;
    handles.set2_list_radiomics.String = strct.features.radiomics.featureNames;
    % set values
    handles.set1_list_data.Value = 1:numel(handles.set1_list_data.String);
    handles.set2_list_data.Value = 1:numel(handles.set2_list_data.String);
    handles.set1_list_ROI.Value = 1:numel(handles.set1_list_ROI.String);
    handles.set2_list_ROI.Value = 1:numel(handles.set2_list_ROI.String);
    handles.set1_list_PORTS.Value = 1:numel(handles.set1_list_PORTS.String);
    handles.set2_list_PORTS.Value = 1:numel(handles.set2_list_PORTS.String);
    handles.set1_list_radiomics.Value = 1:numel(handles.set1_list_radiomics.String);
    handles.set2_list_radiomics.Value = 1:numel(handles.set2_list_radiomics.String);
    
%     % deselect listbox comp selections % only works if multi-selection is on    
%     handles.list_comps1.Value = [];
%     handles.list_comps2.Value = [];

    % make red ROI text next to listbox invisible
    handles.txt_ROI_list_comps1.Visible = 'off'; 
    handles.txt_ROI_list_comps2.Visible = 'off';
end

function enable_Subset2list(object,~)
    global handles
    switch object.Tag
        case 'comp_data'
            handlesArray = [handles.set2_list_data, handles.set2_txt_data];
            val = handles.set1_list_data.Value;
            toCopy = handles.set2_list_data;
        case 'comp_ROI'
            handlesArray = [handles.set2_list_ROI, handles.set2_txt_ROI];
            val = handles.set1_list_ROI.Value;
            toCopy = handles.set2_list_ROI;
        case 'comp_feature'
            handlesArray = [handles.set2_list_PORTS, handles.set2_list_radiomics, handles.set2_txt_feature, handles.set2_txt_feature1, handles.set2_txt_feature2];
            val = {handles.set1_list_PORTS.Value handles.set1_list_radiomics.Value};
            toCopy = {handles.set2_list_PORTS handles.set2_list_radiomics};    
    end
    if object.Value ==1
        set(handlesArray,'Enable','On')
    else
        set(handlesArray,'Enable','Off')
        if iscell(toCopy) % dann 'comp_features' mit zwei listboxen
            toCopy{1}.Value = val{1};
            toCopy{2}.Value = val{2}; 
        else
            toCopy.Value = val;
        end
    end
end

function copy_SelectionToSet2(hObject,~,listbox_set2,isEnabled)
    if ~isEnabled.Value
        listbox_set2.Value = hObject. Value;
    end
end

% function reset_SubsetLists(object,~)
%     global strct
%     parent = object.Parent;
%     set(findall(parent,'Tag','set2_list_ROI'),'Value',get(findall(parent,'Tag','set1_list_ROI'),'Value'))
%     set(findall(parent,'Tag','set2_list_data'),'Value',get(findall(parent,'Tag','set1_list_data'),'Value'))
%     set(findall(parent,'Tag','set2_list_PORTS'),'Value',get(findall(parent,'Tag','set1_list_PORTS'),'Value'))
%     set(findall(parent,'Tag','set2_list_radiomics'),'Value',get(findall(parent,'Tag','set1_list_radiomics'),'Value'))
% end

function store_SubsetLists(varargin)
    global strct
    if isempty(strct.features.PORTS)
        warning('Es wurden noch keine Textur-Features berechnet. Zunaechst in Tab 1 (Settings) auf "Berechnen" klicken..');
        return;
    end
    global handles
    global comp_strct
    
    correctStrings = check_correctDisplayedStrings();
    if ~correctStrings
        set_SubsetLists([],[])
        error('Hinterlegte Strings waren nicht gleich zu angezeigten. Speichern wurde abgebrochen und die Strings geupdatet.')
    end
    
    n= size(comp_strct,2)+1;
    if isempty(handles.list_comps1.String)
        n = 1;
    end
    comp_strct(n).No = n;  
    comp_strct(n).data = strct.data(handles.set1_list_data.Value);
    [ROI, ROInames,iROIassign] = get_ROIselection(handles.set1_list_data,handles.set1_list_ROI,2);
    if isequal(ROI,0) && isequal(ROInames,0)
        comp_strct(n) = [];
        return;
    end
    comp_strct(n).ROI = ROI;
    comp_strct(n).ROINames = ROInames;
    % features
    if isempty(iROIassign) % no ROI assignment
        try P_featCut = strct.features.PORTS.array(handles.set1_list_PORTS.Value,handles.set1_list_ROI.Value,handles.set1_list_data.Value); catch, P_featCut = []; end
        try r_featCut = strct.features.radiomics.array(handles.set1_list_radiomics.Value,handles.set1_list_ROI.Value, handles.set1_list_data.Value); catch, r_featCut = []; end
    else  % ROI assignment was executed  
        [~,idx,~] = cellfun(@(x) intersect(handles.set1_list_ROI.String(handles.set1_list_ROI.Value),x),transpose(ROInames),'UniformOutput',false);
        try 
            P_feat = strct.features.PORTS.array(handles.set1_list_PORTS.Value,handles.set1_list_ROI.Value,handles.set1_list_data.Value); 
            P_featCut = cell(size(P_feat));
            for p = 1:size(P_feat,3)
                 P_featCut(:,idx{p},p) = P_feat(:,idx{p},p); 
            end
        catch
            P_featCut = [];
        end
        try 
            r_feat = strct.features.radiomics.array(handles.set1_list_radiomics.Value,handles.set1_list_ROI.Value, handles.set1_list_data.Value); 
            r_featCut = cell(size(r_feat));
            for p = 1:size(r_feat,3)
                r_featCut(:,idx{p},p) = r_feat(:,idx{p},p);
            end
        catch
            r_featCut = [];
        end
    end
    try P_featCut(cellfun(@isempty,P_featCut)) = {NaN}; catch, P_featCut = []; end
    try r_featCut(cellfun(@isempty,r_featCut)) = {NaN}; catch, r_featCut = []; end
    comp_strct(n).features = vertcat(P_featCut,r_featCut);
    comp_strct(n).idxEndPORTS = length(handles.set1_list_PORTS.Value);
    comp_strct(n).featureNames.PORTS = handles.set1_list_PORTS.String(handles.set1_list_PORTS.Value);
    comp_strct(n).featureNames.radiomics = handles.set1_list_radiomics.String(handles.set1_list_radiomics.Value);
    
    comp_strct(n+1).No = n+1;
    comp_strct(n+1).data = handles.set2_list_data.String(handles.set2_list_data.Value);
    [ROI, ROInames] = get_ROIselection(handles.set2_list_data,handles.set2_list_ROI,3);
    if isequal(ROI,0) && isequal(ROInames,0)
        comp_strct(n) = [];
        comp_strct(n+1) = [];
        return;
    end
    comp_strct(n+1).ROI = ROI;
    comp_strct(n+1).ROINames = ROInames;
    % features
    if isempty(iROIassign)
        try P_featCut = strct.features.PORTS.array(handles.set2_list_PORTS.Value,handles.set2_list_ROI.Value,handles.set2_list_data.Value); catch, P_featCut = []; end
        try r_featCut = strct.features.radiomics.array(handles.set2_list_radiomics.Value,handles.set2_list_ROI.Value, handles.set2_list_data.Value); catch, r_featCut = []; end
    else  % ROI assignment was executed  
        [~,idx,~] = cellfun(@(x) intersect(handles.set2_list_ROI.String(handles.set2_list_ROI.Value),x),transpose(ROInames),'UniformOutput',false);
        try 
            P_feat = strct.features.PORTS.array(handles.set2_list_PORTS.Value,handles.set2_list_ROI.Value,handles.set2_list_data.Value); 
            P_featCut = cell(size(P_feat));
            for p = 1:size(P_feat,3)
                 P_featCut(:,idx{p},p) = P_feat(:,idx{p},p); 
            end
        catch
            P_featCut = [];
        end
        try 
            r_feat = strct.features.radiomics.array(handles.set2_list_radiomics.Value,handles.set2_list_ROI.Value, handles.set2_list_data.Value); 
            r_featCut = cell(size(r_feat));
            for p = 1:size(r_feat,3)
                r_featCut(:,idx{p},p) = r_feat(:,idx{p},p);
            end
        catch
            r_featCut = [];
        end
    end
    try P_featCut(cellfun(@isempty,P_featCut)) = {NaN}; catch, P_featCut = []; end
    try r_featCut(cellfun(@isempty,r_featCut)) = {NaN}; catch, r_featCut = []; end
    comp_strct(n+1).features = vertcat(P_featCut,r_featCut);
    comp_strct(n+1).idxEndPORTS = length(handles.set2_list_PORTS.Value);
    comp_strct(n+1).featureNames.PORTS = handles.set2_list_PORTS.String(handles.set2_list_PORTS.Value);
    comp_strct(n+1).featureNames.radiomics = handles.set2_list_radiomics.String(handles.set2_list_radiomics.Value);

    type = [];
    if handles.c_compData.Value == 1,type = ' data'; end
    if handles.c_compROI.Value ==1, type = [type ' ROI']; end
    if handles.c_compFeature.Value == 1, type = [type ' feature']; end 
    if isempty(handles.list_comps1.String)
        handles.list_comps1.String = {['Vergleich ' num2str(n) ' -' num2str(type)]; ['Vergleich ' num2str(n+1) ' -' num2str(type)]};
        handles.list_comps2.String = {['Vergleich ' num2str(n) ' -' num2str(type)]; ['Vergleich ' num2str(n+1) ' -' num2str(type)]};
        handles.list_comps3.String = {['Vergleich ' num2str(n) ' -' num2str(type)]; ['Vergleich ' num2str(n+1) ' -' num2str(type)]};
        handles.list_comps4.String = {['Vergleich ' num2str(n) ' -' num2str(type)]; ['Vergleich ' num2str(n+1) ' -' num2str(type)]};
        handles.list_comps1.Value = n; handles.list_comps2.Value = n+1;
    else
        handles.list_comps1.String = [handles.list_comps1.String; {['Vergleich ' num2str(n) ' -' num2str(type)]}; {['Vergleich ' num2str(n+1) ' -' num2str(type)]}];
        handles.list_comps2.String = [handles.list_comps2.String; {['Vergleich ' num2str(n) ' -' num2str(type)]}; {['Vergleich ' num2str(n+1) ' -' num2str(type)]}];
        handles.list_comps3.String = [handles.list_comps3.String; {['Vergleich ' num2str(n) ' -' num2str(type)]}; {['Vergleich ' num2str(n+1) ' -' num2str(type)]}];
        handles.list_comps4.String = [handles.list_comps4.String; {['Vergleich ' num2str(n) ' -' num2str(type)]}; {['Vergleich ' num2str(n+1) ' -' num2str(type)]}];
        handles.list_comps1.Value = n; handles.list_comps2.Value = n+1;
    end
    
    function [ROI,ROInames,ROIassign] = get_ROIselection(list_data,list_ROI,tabSpec)
        if strct.ROI.sameROIs ==0 || handles.c_activateROIassignment.Value == 1 
           [ROI,ROInames,ROIassign] = assign_MaskToData([],[],list_data, list_ROI, tabSpec);
        else            % no ROI assignment
           for k=1:numel(list_data.Value)
                d = list_data.Value(k);
                for j=1:numel(list_ROI.Value)
                    r = list_ROI.Value(j);
                    temp_ROI1{k}{j} = strct.ROI.lMask{d}{r};
                end
            end
            ROI = temp_ROI1;
            
            for i = 1:numel(list_data.Value)
                ROInames{i} = cut_nameDisplayed(strct.ROI.names{list_data.Value(i)}(list_ROI.Value));
            end
            ROIassign = [];
        end
    end

    function correctStrings = check_correctDisplayedStrings()
        [~, list{1},saved{1}] = intersect(handles.set1_list_data.String,strct.data);
        [~, list{2},saved{2}] = intersect(handles.set2_list_data.String,strct.data);
        [~, list{3},saved{3}] = intersect(handles.set1_list_ROI.String,unique(vertcat(strct.ROI.names{:})));
        [~, list{4},saved{4}] = intersect(handles.set2_list_ROI.String,unique(vertcat(strct.ROI.names{:})));
        [~, list{5},saved{5}] = intersect(handles.set1_list_PORTS.String,strct.features.PORTS.featureNames);
        [~, list{6},saved{6}] = intersect(handles.set2_list_PORTS.String,strct.features.PORTS.featureNames);
        [~, list{7},saved{7}] = intersect(handles.set1_list_radiomics.String,strct.features.radiomics.featureNames);
        [~, list{8},saved{8}] = intersect(handles.set2_list_radiomics.String,strct.features.radiomics.featureNames);
        
        correctStrings = 1;
        for i = 1:numel(list)
            true = isequal(list{i},saved{i});
            if ~true || (isempty(list{i}) && i<=4)
                correctStrings = 0;
                return;
            end
        end
    end
end

function out = cut_nameDisplayed(names)
    if ispc
        separator = '\';
    else
        separator = '/';
    end
    names = regexp(names,separator,'split'); 
    try
        out = cellfun(@(x) fullfile(x{end-1},x{end}),names,'UniformOutput',false);
    catch
        out = cellfun(@(x) x,names,'UniformOutput',false); % x{end}
    end
    out = cellfun(@(x) vertcat(x),out,'UniformOutput',false);
end

function show_CompSelection(object,~)
    global comp_strct
    global handles
    dat = comp_strct(object.Value);
    if strcmp(char(object.Tag),'list_comps1')
        list_data = handles.set1_list_data;
        list_ROI = handles.set1_list_ROI;
        list_PORTS = handles.set1_list_PORTS;
        list_radiomics = handles.set1_list_radiomics;
    else
        list_data = handles.set2_list_data;
        list_ROI = handles.set2_list_ROI;
        list_PORTS = handles.set2_list_PORTS;
        list_radiomics = handles.set2_list_radiomics;
    end
    
    % ---------------------------------------------------------------
    % --------------- check if settings are still the same ----------
    % ---------------------------------------------------------------
    % --- data ---
    c1 = cellfun(@(x) strcmp(x,list_data.String),dat.data,'UniformOutput',false);
    c_1 = reshape(cell2mat(c1),size(list_data.String,1),[])';
    
    % --- ROI ---    
    ROINames_stored = unique(transpose(horzcat(dat.ROINames{:,:})));
    isNoAssignment = ~any(diff(cell2mat(cellfun(@(x) numel(x),dat.ROINames, 'UniformOutput',false))));
    if isNoAssignment % then number of chosen ROIs is the same for all data
        % check if ROINames are all the same
        for i = 1:numel(dat.ROINames)-1
            for j = i+1:numel(dat.ROINames)
                [~,ia,ib] = intersect(dat.ROINames{i},dat.ROINames{j});
                if ~isequal(ia,ib) || isempty(ia) || isempty(ib)
                    isNoAssignment = 0;
                    break;
                end
            end
        end
    end
    if isNoAssignment
        % make red text visible next to listbox ("*ROI: unterschiedliche Auswahl")
        if strcmp(char(object.Tag),'list_comps1')
            handles.txt_ROI_list_comps1.Visible = 'off';
        else
            handles.txt_ROI_list_comps2.Visible = 'off';
        end
    else
        if strcmp(char(object.Tag),'list_comps1')
            handles.txt_ROI_list_comps1.Visible = 'on';
        else
            handles.txt_ROI_list_comps2.Visible = 'on';
        end
    end
    c2 = cellfun(@(x) strcmp(x,list_ROI.String),ROINames_stored,'UniformOutput',false);
    c_2 = reshape(cell2mat(c2),size(list_ROI.String,1),[])';
    
    % --- feature ---
    c3 = cellfun(@(x) strcmp(x,list_PORTS.String),dat.featureNames.PORTS,'UniformOutput',false);
    c4 = cellfun(@(x) strcmp(x,list_radiomics.String),dat.featureNames.radiomics,'UniformOutput',false);
    
    if ~isempty(list_PORTS.String)
        c_3 = reshape(cell2mat(c3),size(list_PORTS.String,1),[])'; 
    else
        c_3 = 0;
    end
    if ~isempty(list_radiomics.String)
        c_4 = reshape(cell2mat(c4),size(list_radiomics.String,1),[])';
    else
        c_4 = 0;
    end
    
    % ---------------------------------------------------------------
    % --------------- update listbox conten and/or selection --------
    % ---------------------------------------------------------------
    % option1 (if):   settings are the same, just highlight the right ones
    % option2 (else): settings are not the same, override listbox

    % --- data ---
    if all(any(c_1,2))
        isData = cellfun(@(x) strfind(list_data.String,x),dat.data,'UniformOutput',false);
        isData = [isData{:,:}]; isData( cellfun(@isempty, isData) ) = {0}; isData = logical(cell2mat(isData));
        value_array = [1:numel(list_data.String)]';
        list_data.Value = value_array(any(isData,2));
    else
        list_data.String = [dat.data]; list_data.Value = 1:numel(list_data.String);
    end

    % --- ROI ---
    if all(any(c_2,2))
        isROI = cellfun(@(x) strfind(list_ROI.String,x),ROINames_stored,'UniformOutput',false);
        isROI = [isROI{:,:}]; isROI( cellfun(@isempty, isROI) ) = {0}; isROI = logical(cell2mat(isROI));
        value_array = [1:numel(list_ROI.String)]';
        list_ROI.Value = value_array(any(isROI,2));
    else
        list_ROI.String = [ROINames_stored]; list_ROI.Value = 1:numel(list_ROI.String);
    end

    % --- PORTS ---
    if all(any(c_3,2)) || isempty(c_3)
        isPORTS = cellfun(@(x) strfind(list_PORTS.String,x),dat.featureNames.PORTS,'UniformOutput',false);
        if isempty(isPORTS)
            list_PORTS.Value = [];
        else
            isPORTS = [isPORTS{:,:}]; isPORTS( cellfun(@isempty, isPORTS) ) = {0}; isPORTS = logical(cell2mat(isPORTS));
            value_array = [1:numel(list_PORTS.String)]';
            list_PORTS.Value = value_array(any(isPORTS,2));
        end
    else
        list_PORTS.String = [dat.featureNames.PORTS]; list_PORTS.Value = 1:numel(list_PORTS.String);
    end

    % --- radiomics ---
    if all(any(c_4,2)) || isempty(c_4)
        isRad = cellfun(@(x) strfind(list_radiomics.String,x),dat.featureNames.radiomics,'UniformOutput',false);
        if isempty(isRad)
            list_radiomics.Value = [];
        else
            isRad = [isRad{:,:}]; isRad( cellfun(@isempty, isRad) ) = {0}; isRad = logical(cell2mat(isRad));
            value_array = [1:numel(list_radiomics.String)]';
            list_radiomics.Value = value_array(any(isRad,2));
        end
    else
        list_radiomics.String = [dat.featureNames.radiomics]; list_radiomics.Value = 1:numel(list_radiomics.String);
    end
end

function delete_Comps(varargin)
global handles
    global comp_strct
    handles.list_comps1.String = [];
    handles.list_comps2.String = [];
    handles.list_comps3.String = [];
    handles.list_comps4.String = [];
    handles.list_comps4.Value = [];
    comp_strct = [];
end

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% * * 
% * * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% * * tab 3 functions
% * * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% * * 
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

function get_visualisationSelection(varargin)
    global handles
    h = findobj(handles.f,'Title','Visualisierung');
    plots = findobj(h.Children,'Style','checkbox');
    visSelection = struct;
    for i=1:numel(plots)
        str = char(plots(i).Tag);
        visSelection = setfield(visSelection,str,plots(i).Value); 
    end
    if visSelection.FeatureSpace == 1
        handles.bg_FeatSpace.SelectedObject = handles.r_FeatSpace_ROI;
    elseif visSelection.FeatureSpace == 0
        handles.bg_FeatSpace.SelectedObject = [];
    end
    h.UserData = visSelection;
end

function analysisFeature(varargin)
    hLoad =  showWaitbar_loadData([],1);    
    global comp_strct
    global handles
%     if length(handles.list_comps3.Value)~=2
%         warning('Fuer die Analyse muessen (genau) 2 Vergleiche ausgewaehlt werden.');
%         showWaitbar_loadData(hLoad,0)
%         return;
%     end
    
    if handles.r_corrNaN_sort.Value == 1
        corr_NaN = 'sort';
    else % then it's other radiobutton (complete) or selection doesn't matter because correlation was not chosen
        corr_NaN = 'complete';
    end
    n_set1 = handles.list_comps3.Value(1);
    n_set2 = handles.list_comps3.Value(2);
    set1 = cell2mat(comp_strct(n_set1).features);
    set2 = cell2mat(comp_strct(n_set2).features);   
    [cv,ttest,corrcoef] = analyse_features(set1,set2,corr_NaN);
    
    table = findall(handles.tab3,'Tag','AnalysisTable');
    table.RowName = {}; table.Data = [];
    table.Data = [cv,ttest.h,ttest.p,corrcoef];
    
    featNames1 = [comp_strct(n_set1).featureNames.PORTS;comp_strct(n_set1).featureNames.radiomics];
    featNames2 = [comp_strct(n_set2).featureNames.PORTS;comp_strct(n_set2).featureNames.radiomics];    
    if isequal(featNames1,featNames2)
        % table.RowName = name_features
        try 
            rowName_P = cellfun(@(x) x(1:4),comp_strct(n_set1).featureNames.PORTS,'UniformOutput',false); 
        catch
            rowName_P = '';
        end
        try 
            rowName_r = cellfun(@(x) x(1:4),comp_strct(n_set1).featureNames.radiomics,'UniformOutput',false); 
        catch
            rowName_r = ''; 
        end
        
        if isequal(comp_strct(n_set1).featureNames.PORTS,comp_strct(n_set2).featureNames.PORTS)
            table.RowName = vertcat('PORTS',rowName_P, 'rad.',rowName_r);
            % add empty rows to toolbox descriptions
            idxEndPORTS = comp_strct(n_set1).idxEndPORTS;
            table.Data(2:end+1,:) = table.Data(:,:); 
            table.Data(1,:) = {[]}; 
            table.Data(idxEndPORTS+2:end+1,:) = table.Data(idxEndPORTS+1:end,:); 
            table.Data(idxEndPORTS+2,:) = {[]}; 
        else
            table.RowName = vertcat(rowName_P,rowName_r);
        end
    else
        table.RowName = 1:size(table.Data,1);
    end
    showWaitbar_loadData(hLoad,0);
end

function show_FeatureNames(varargin)
    global strct
    f_table = figure('Position',[0 0 700 1000]);
    t = uitable(f_table,'units','normalized','Position',[0 0 1 1],'ColumnWidth',{330 370});
    t.ColumnName = {'PORTS','radiomics'};
    t.Data = [strct.features.feature_list.feature_list_PORTS vertcat(strct.features.feature_list.feature_list_radiomics, cell(6,1))];         
end

function checkNumericInput(hObject,~) % input in editable textbox (max. plots for feature space plots)
    str=get(hObject,'String');
    if isempty(str2num(str))
        set(hObject,'string','20');
        warndlg('Input must be numerical');
    end
end

function a = addNewPanelData(a,dStrctAdd)
    dim = size(a,2)+1;
    a(dim) = a(dim-1);
    a(dim).iGroupIndex = dim;
    a(dim).sName = sprintf('Vergleich_%02d', dStrctAdd.No);
    allFields = fieldnames(dStrctAdd.plots);
    emptyFields = allFields(structfun(@isempty,dStrctAdd.plots));
    fullFields = allFields(~ismember(allFields,emptyFields));
    dStrctAdd.plots = rmfield(dStrctAdd.plots, emptyFields);
    a(dim).dImg = [];
    a(dim).dImg = dStrctAdd.plots;
    if any(strcmp(fullFields,'maskOverlay'))
        dMin = min(min(min(dStrctAdd.plots.maskOverlay.img{1})));
        dMax = max(max(max(dStrctAdd.plots.maskOverlay.img{1})));
        % rotate image + mask to axial view
        iPermutation = [3 2 1];                         
        iFlipdim = 1;
        a(dim).dImg.maskOverlay.img =  cellfun(@(x) flipdim(permute(x,iPermutation), iFlipdim),a(dim).dImg.maskOverlay.img,'UniformOutput',false);
        for k=1:numel(a(dim).dImg.maskOverlay.lMask)
            a(dim).dImg.maskOverlay.lMask{k} = cellfun(@(x) flipdim(permute(x, iPermutation), iFlipdim),a(dim).dImg.maskOverlay.lMask{k},'UniformOutput',false);
        end
        a(dim).iActiveSlice = 120;
    else
        dMin=0; dMax = 1;
        a(dim).iActiveSlice = 1;
    end
    a(dim).dDynamicRange = [dMin, dMax];
    a(dim).dWindowCenter = (dMax + dMin)./2;
    a(dim).dWindowWidth  = dMax - dMin;
    a(dim).lActive = false;
    a(dim).iActiveData = 1;
    a(dim).iActiveROI = 1;
end

function visualizeFeature(varargin)
    hLoad =  showWaitbar_loadData([],1);    
    global handles
    global comp_strct
    global f_imagine
    
    % ----------- error catching --------------------
    if isempty(comp_strct)
        warning('Es wurden noch keine Vergleiche berechnet. Visualisierung nicht moeglich.');
        showWaitbar_loadData(hLoad,0); 
        return;
    end
    if isempty(handles.list_comps4.Value)
        warning('Es wurden keine Vergleiche ausgewaehlt. Visualisierung nicht moeglich.');
        showWaitbar_loadData(hLoad,0); 
        return;
    end
    % ----------------------------------------------

    % get number of selected comparisons
    list_length = [1:numel(handles.list_comps4.String) handles.list_comps4.Value];
    
    % get additional plot information for FeatureSpace plots
    visualization = findobj(handles.f,'Title','Visualisierung'); 
    max_FeatPlot = get(handles.edit_maxFeatPlots,'String');
    sort = [];
    if handles.bg_FeatSpace.SelectedObject == handles.r_FeatSpace_ROI
        sort = 'ROI';
    elseif handles.bg_FeatSpace.SelectedObject == handles.r_FeatSpace_Data
        sort = 'data';
    end
    
    for i=1:length(handles.list_comps4.Value)
        plots{i} = visualize_features(visualization.UserData,comp_strct(handles.list_comps4.Value(i)),sort,str2num(max_FeatPlot));
        comp_strct(handles.list_comps4.Value(i)).plots = plots{i};
    end

    % manche Masken haben nicht Dimension von zugehÃ¶rigen Bildern (MS-Studie)
    warn = 0;
    for i=1:numel(handles.list_comps4.Value)
        val = handles.list_comps4.Value(i);
        if ~isempty(comp_strct(handles.list_comps4.Value(i)).plots.maskOverlay)
            for j=1:numel(comp_strct(val).plots.maskOverlay.lMask)
                for k=1:numel(comp_strct(val).plots.maskOverlay.lMask{j})
                    sizeImg = size(comp_strct(val).plots.maskOverlay.img{j});
                    if ~isequal(size(comp_strct(val).plots.maskOverlay.lMask{j}{k}),sizeImg)
                        size3 = size(comp_strct(val).plots.maskOverlay.lMask{j}{k},3);
    %                     comp_strct(val).plots.maskOverlay.lMask{j}{k}(:,:,size3+1:128) = zeros(size(comp_strct(val).plots.maskOverlay.lMask{j}{k},1), size(comp_strct(val).plots.maskOverlay.lMask{j}{k},1), 128-size3);
                        comp_strct(val).plots.maskOverlay.lMask{j}{k}(:,:,(sizeImg(3)-size3+1):sizeImg(3))  =  comp_strct(val).plots.maskOverlay.lMask{j}{k};
                        comp_strct(val).plots.maskOverlay.lMask{j}{k}(:,:,1:(sizeImg(3)-size3)) = zeros(size(comp_strct(val).plots.maskOverlay.lMask{j}{k},1), size(comp_strct(val).plots.maskOverlay.lMask{j}{k},1), sizeImg(3)-size3);
                        warn=warn+1;
                        if warn==1
                            warning('Mask-Dimension wurde veraendert!')
                        end
                    end
                end
            end
        end
    end

    if isempty(f_imagine) % imagine is opened for the first time
        f_imagine = imagine_TA(comp_strct(handles.list_comps4.Value));
    elseif ~isvalid(f_imagine) % imagine was closed again
        f_imagine = imagine_TA(comp_strct(handles.list_comps4.Value));
    else
        %     addPanel in f_imagine
        set(0,'currentfigure',f_imagine);
        a=f_imagine.UserData();
        a_new = a;
        % modify a and add new Input from MainGUI
        for i= 1:numel(handles.list_comps4.Value)
            a_new = addNewPanelData(a_new,comp_strct(handles.list_comps4.Value(i)));
        end

        save('a_new.mat','a_new');
        f_imagine.UserData();   
        delete('a_new.mat');
    end

    % update table list in GUI
    nums = {comp_strct(handles.list_comps4.Value).No}; 
    list = cellfun(@(x) {['Vergleich ' num2str(x) ]},nums);
    handles.list_compsImagine.String = [handles.list_compsImagine.String; list'];
    showWaitbar_loadData(hLoad,0);
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

% -----------------------------
% MOD from Phi and Math ©
% -----------------------------
function saveclosereq(varargin)
    % Close request function 
% to display a question dialog box 
   selection = questdlg('Soll TFCV geschlossen werden',...
      'MainGUI',...
      'Ja (Daten werden aus Workspace gelöscht)','Nein','Ja (Daten werden aus Workspace gelöscht)'); 
   switch selection
      case 'Ja (Daten werden aus Workspace gelöscht)'
         delete(gcf), clear all; clc; clearvars; %Toggle Point %KRITISCH nur Daten von dem Framework
      case 'Nein'
      return 
   end
end
