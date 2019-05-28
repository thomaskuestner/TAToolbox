        category.Moments = 1;   % category of the features imported from where 
        category.Histogram = 1; % and when (in Code)
        category.GTSDM = 1;
        category.NGTDM = 1;
        category.GLZSM = 1;
        category.GLRLM = 1;
        
    % dummy image
    dImg = dummy;
%     dImg = dummy_caro;
    % mask
%     load('dummy_MaskWholeROI.mat')
        
%         temp = run_radiomics_dummy(dImg,dummy_MaskWholeROI,category);

        temp = run_PORTS_dummy(double(dImg),logical(dummy_MaskWholeROI),category);
%  temp = run_radiomics_dummy(double(dImg),logical(dummy_MaskWholeROI),category);

%        feat_radiomics(:,2) = temp;

temp(28:32,2)

% feat_PORTS_p5 = feat_PORTS;

% zuerst p20 dann p10
a=1;
