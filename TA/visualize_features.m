function plots = visualize_features(selection,data,sort,max_FeatPlot)
% check which visualisation methods were chosen in GUI
box = [];
featSpace = [];
kiviat = [];
histo = [];
maskOverlay = [];
if isempty(selection)
    error('Keine Plots ausgewaehlt.')
end
if selection.MaskenOverlay
        hLoad = showWaitbar_loadData([],1,'Erstelle Bilder mit Masken-Oberlay');
    maskOverlay = plot_maskOverlay(data);
        showWaitbar_loadData(hLoad,0);
end
if selection.Histogramm
        hLoad = showWaitbar_loadData([],1,'Erstelle Histogramme ...');
    histo = plot_histo(data);
        showWaitbar_loadData(hLoad,0);
end
if selection.Boxplot
        hLoad = showWaitbar_loadData([],1,'Erstelle Boxplots ...');
    box = plot_boxplot(data);    
        showWaitbar_loadData(hLoad,0);
end
if selection.FeatureSpace
        hLoad = showWaitbar_loadData([],1,'Erstelle Feature Space Plots ...');
    featSpace = plot_featurespace(data,sort,max_FeatPlot);   
        showWaitbar_loadData(hLoad,0);
end
if selection.Kiviat
        hLoad = showWaitbar_loadData([],1,'Erstelle Kiviat Diagramme ...');
    kiviat = plot_kiviat(data);
        showWaitbar_loadData(hLoad,0);
end

plots = struct;
plots.maskOverlay = maskOverlay;
plots.box = box;
plots.histo = histo;
plots.featSpace = featSpace;
plots.kiviat = kiviat;
end

function haxes = plot_boxplot(data)
% matrix: each column is own boxplot
box_matrix = permute(cell2mat(data.features),[3 2 1]);
features = [data.featureNames.PORTS; data.featureNames.radiomics];
% label_list = regexp(data.ROINames,'/','split');
ROInames = unique( vertcat(data.ROINames{:}));
label_list = cellfun(@(x) regexp(x,'/','split'),ROInames,'UniformOutput',false);
for i = 1:length(label_list)
    try
        labels_cut{i} = cellfun(@(x) strrep(x{end},'_','\_'),label_list{i},'UniformOutput',false);
    catch
        labels_cut{i} = label_list{i};
    end
end
    labels_cutUnique = unique(transpose(horzcat(labels_cut{:,:})));
    
    % * * * ---------------------------------------------
    % * * * alle Features in eine Figure plotten
    % * * * ---------------------------------------------
    box_all = reshape(box_matrix,[],size(data.features,1),1);
    if any(any(isnan(box_matrix)))
        box_all(any(isnan(box_all),2),:) = []; % delete rows with NaNs
    end
    f = figure('visible','off');
    boxplot(box_all);
    ax = findobj(f,'Type','Axes');
    str1 = 'Boxplot Feature-Uebersicht';
    str2 = ['n = ' num2str(nnz(all(~isnan(box_all),2))), ' ueber Datasets + ROIs'];
    try 
        if numel(label_list)>1
            str3 = ['(', strjoin(labels_cut,'+') ,')']; 
        else
            str3 = ['(', labels_cut{1}{1},')']; 
        end
    catch
        str3 = '(unterschiedliche)'; 
    end
    axes(ax);
    f.Visible = 'off';
    title({str1, str2, str3})
    feats = regexp(features,' ','split');
    feats=feats';
    xlabel('Features');
    ylabel('Absolute Werte','rotation',90,'HorizontalAlignment','left')
    
    haxes{1,1} = get(f,'CurrentAxes');
    haxes{1,1}.XTickLabel = cellfun(@(x) x{1},feats,'UniformOutput',false);
    
    % * * * ---------------------------------------------
    % * * * alle Features in einzelne Figure plotten
    % * * * ---------------------------------------------
    for i=1:size(box_all,2)
        f = figure('visible','off');
        boxplot(box_all(:,i))
        str1 = 'Boxplot';
        title({str1, str2, str3})
        xlabel({'Feature';features{i}})
        ylabel('Absolute Werte','rotation',90,'HorizontalAlignment','left')
        haxes{1,i+1} = get(f,'CurrentAxes');
        haxes{1,i+1}.XTick = [];
    end
    
    % * * * ---------------------------------------------
    % * * * alle Features in einzelne Figure plotten, aufgespaltet nach Muskeln
    % * * * ---------------------------------------------
    try
        for i=1:size(box_matrix,3)          % dim1: aufnahmen, dim2: ROIs, dim3: features
            f = figure('visible','off');
    %         boxplot(box_matrix(:,:,i))
            boxplot(box_matrix(:,:,i),'Labels',labels_cutUnique)
            str2 = ['n = ' num2str(size(box_matrix,1)), ' ueber Datasets, aufgespaltet nach ROIs'];
            title({str1, str2})
            xlabel({'Feature';features{i}})
            ylabel('Absolute Werte','rotation',90,'HorizontalAlignment','left')
            haxes{2,i+1} = get(f,'CurrentAxes');
        end
        haxes{2,1} = haxes{1,1};
    catch
    end
end

function haxes = plot_featurespace(data,sort,max_FeatPlot)
% change viewing angle:
% view(0,0)=axes x+z;   view(0,90)=axes x+y;   view(90,0)=axes y+z
feat = [data.featureNames.PORTS; data.featureNames.radiomics];

if strcmp(sort,'ROI')
    feat_matrix = cell2mat(data.features);
    feat_matrix(isnan(feat_matrix)) = []; % delete NaNs
    feat_matrix = reshape(feat_matrix,size(data.features,1),[],1); % Zeilen: Features, Spalten: alle Daten mit allen Muskeln + Aufnahmen
    feat_matrix = permute(feat_matrix,[2 1]);
      
    label_list = cellfun(@(x) regexp(x,'/','split'),data.ROINames,'UniformOutput',false);
    for i = 1:length(label_list)
        labels_cut{i} = cellfun(@(x) x{end},label_list{i},'UniformOutput',false);
    end   
    labels = transpose(horzcat(labels_cut{:,:}));
    labels = reshape(labels,[],1);
    str = {'Feature Space','nach ROIs'};
else
    feat_matrix = cell2mat(data.features);
    feat_matrix(isnan(feat_matrix)) = []; % delete NaNs
    feat_matrix = reshape(feat_matrix,size(data.features,1),[],1); % size(data.features,1): is number of features
    feat_matrix = permute(feat_matrix,[2 1]); % Zeilen: Features, Spalten: alle Daten mit allen Muskeln + Aufnahmen
    
    label_list = regexp(data.data,'/','split');
    labels_cut = cellfun(@(x) x{end},label_list,'UniformOutput',false);
    
    factor = transpose(cellfun(@(x) length(x),data.ROINames,'UniformOutput',false));
    for i=1:length(labels_cut)
        labels{i} = cell(factor{i},1);
        [labels{i}{:}] = deal(labels_cut{i});
    end

    labels = vertcat(labels{:,:});
    str = {'Feature Space','nach Aufnahmen'};
end

n = size(data.features,1); % Anzahl der augewählten Features
% comb = n*(n+1)/2; % Anzahl der möglichen Kombinierungen
count = 0;
    for k=1:n-1
        for i=k+1:n
            count=count+1;
            featSpace{count} = figure('visible','off'); 
            gscatter(feat_matrix(:,k),feat_matrix(:,i),labels);
            xlabel(feat{k}); ylabel(feat{i});
            zlabel(unique(labels,'stable'))
            title(str)
            haxes{count} = get(featSpace{count},'CurrentAxes');

            if any(isnan(feat_matrix(:,k))) || any(isnan(feat_matrix(:,i)))
                str = 'Keine Datenpunkte, da z.T. NaN.';
                annotation('textbox','String',str,'FitBoxToText','on')
            end
            if count>=max_FeatPlot  % 20
                msg = 'Anzahl an maximalen FeatureSpace-Plots wird ueberstiegen.';
                warning(msg);
                return;
            end
        end
    end
end

function haxes = plot_kiviat(data)
    
    feature = [data.featureNames.PORTS; data.featureNames.radiomics];
    feature_list = regexp(feature,' ','split');
    feature_cut = cellfun(@(x) x{1},feature_list,'UniformOutput',false);

    if ispc
        separator = '\';
    else
        separator = '/';
    end
    try
        labelROI_list = cellfun(@(x) regexp(x,'/','split'),data.ROINames,'UniformOutput',false);
        for i = 1:length(labelROI_list)
            labelsROI_cutCell{i} = cellfun(@(x) fullfile(x{end-1},x{end}),labelROI_list{i},'UniformOutput',false);
        end   
    catch
        labelROI_list = cellfun(@(x) regexp(x,' - ','split'),data.ROINames,'UniformOutput',false);
        for i = 1:length(labelROI_list)
            labelsROI_cutCell{i} = cellfun(@(x) x{1},labelROI_list{i},'UniformOutput',false);
        end   
    end
    labelsROI_cut = transpose(horzcat(labelsROI_cutCell{:,:}));
    
    labelData_list = regexp(data.data,'/','split');
    labelsData_cut = cellfun(@(x) fullfile(x{end-1},x{end}),labelData_list,'UniformOutput',false);
    
    matrix = cell2mat(data.features);
    feat_matrix = reshape(matrix,size(matrix,1),[],1);
    feat_matrix(:,any(isnan(feat_matrix),1)) = [];
    kiviat = figure('visible','off');
    [sa,sp] = radar(feat_matrix', feature_cut, num2cell([1:18]), 'Kiviat Plot'); % m.-file from fileExchange
    zlabel(labelsROI_cut)
    haxes{1} = get(kiviat,'CurrentAxes');
    
    for i = 1: size(matrix,3) % ------------- data
        kiviat = figure('visible','off');
        radar(squeeze(matrix(:,:,i))', feature_cut, num2cell([1:18]), {'Kiviat Plot',['von Aufnahme ', num2str(strrep(labelsData_cut{i},'_','\_'))]},sa,sp);
        zlabel(labelsROI_cutCell{i})
        haxes{i+1} = get(kiviat,'CurrentAxes');
    end
    
    matrix_cut = matrix(:,any(any(~isnan(matrix)),3),:);
    for i = 1: size(matrix_cut,2) % ------------- ROI
        kiviat = figure('visible','off');
        feat_matrix = matrix_cut(:,i,:);
        feat_matrix(:,any(isnan(feat_matrix),1)) = [];
        radar(squeeze(feat_matrix)', feature_cut, num2cell([1:18]), {'Kiviat Plot',['von ROI ', num2str(strrep(labelsROI_cut{i},'_','\_'))]},sa,sp);
            temp_zlabel = labelsData_cut;    
            if isequal(size(matrix),size(matrix_cut))
                temp_zlabel(all(isnan(matrix(:,i,:)))) = [];
            else
                temp_zlabel(any(isnan(matrix_cut(:,i,:)))) = [];
            end
        zlabel(temp_zlabel)
        haxes{i+1+size(matrix,3)} = get(kiviat,'CurrentAxes'); 
    end
end

function haxes = plot_histo(data)
labels = [data.featureNames.PORTS; data.featureNames.radiomics];
feat_matrix = reshape(cell2mat(data.features),size(data.features,1),[],1);

    for i=1:size(feat_matrix,1)
        histo{i} = figure('visible','off');
        histogram(feat_matrix(i,:),10)
        title('Histogramm')
        xlabel(labels{i})
        set(get(histo{i},'CurrentAxes'),'ytick',0:1000)
        haxes{i} = get(histo{i},'CurrentAxes'); 
    end
end

function img_maskOverlay = plot_maskOverlay(data)
    global bekannteStudien
    sPathImg =data.data;
    dicominfo = {};
    for i=1:numel(sPathImg)
        onlyDICOM = 0;
        for j = 1:numel(bekannteStudien)
            [~,idx,~] = intersect(bekannteStudien(j).directories,sPathImg{i});
            if ~isempty(idx)
                onlyDICOM = 1;
                break;
            end
        end
        if onlyDICOM
            dImg{i} = bekannteStudien(j).data{idx};
            try
                dicominfo{i} = bekannteStudien(j).dicominfo{idx};
            catch
                dicominfo{i} = [];
            end
            %[~,dicominfo{i}] = ReadDICOM(sPathImg{i},onlyDICOM);
        else
            [dImg{i},dicominfo{i}] = ReadDICOM(sPathImg{i});
        end
    end
    img_maskOverlay.img = dImg;
    img_maskOverlay.lMask = data.ROI;
    img_maskOverlay.dicominfo = dicominfo;
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