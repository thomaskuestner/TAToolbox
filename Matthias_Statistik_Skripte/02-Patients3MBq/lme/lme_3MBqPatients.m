clear all;clc;
%% choose
ROIX=2;
outlier_included=false; %outlier are the worst four ones in ranking
transformed_by_log=true;
%%%%%%%%%

if ROIX == 1
    filename_to_extract='summarized_data_of_all_Patients_ROI1.mat';
    if outlier_included==true
        number_of_patient=[01,03,06,09,10,13,14,17,18,19,20,21,22,24,25,26,27,28,29]; %complete dataset 3MBqpatients
        smallerthen10=4; %to be improved
    else
        % first
        number_of_patient=[01,03,06,09,10,13,14,17,19,20,25,26,27,28,29]; %
        smallerthen10=4; %to be improved
    end
    
else %ROIX=2
    filename_to_extract='summarized_data_of_all_Patients_ROI2.mat';
    if outlier_included==true
        number_of_patient=[01,03,06,09,10,13,14,17,18,19,20,21,22,24,25,26,27,28,29]; %complete dataset 3MBqpatients
        smallerthen10=4; %to be improved
    else
        number_of_patient=[01,03,06,10,14,17,19,20,21,24,25,26,27,28,29];
        smallerthen10=3; %to be improved
    end
end

%% Prework
load('Zuordnung-TFs-to-Number.mat');
file_to_extract=load(filename_to_extract);
file=file_to_extract.data;

%% working
length_of_patientnumbers=length(number_of_patient);
TF_Values=1:1:42; %all possible TF-Values in radiomics
length_of_TFV=length(TF_Values);
Doses_Values=(0.5:0.25:3); %based on 3MBq Patients
length_of_DV=length(Doses_Values);
for q=1:length_of_TFV
    clear TFX lme_TFX;
    TFX(1,:)={'Identification_ID','Strength of Dose','TF-Value'};
    count=1;
        
    for i=1:length_of_patientnumbers
        temp_name='pure_data_';
            if i<=smallerthen10
            temp_name=strcat(temp_name,'0');
            end
        name = {strcat(temp_name,int2str(number_of_patient(i)))};
        
        if transformed_by_log==true
            for w=1:length_of_DV
                TFX(w+count,:)={(name{1}),Doses_Values(w),abs(log((cell2mat(file.(name{1}).feature_data(q,1,w)))))};
            end
        else
            for w=1:length_of_DV
                TFX(w+count,:)={(name{1}),Doses_Values(w),(cell2mat(file.(name{1}).feature_data(q,1,w)))};
            end
        end

        count=count+length_of_DV;
    end
    %calculate lme and save the result
    TFX=cell2dataset(TFX);
    lme_TFX = fitlme(TFX,'TF_Value ~ 1 + StrengthOfDose + (1|Identification_ID)');
    if ROIX == 1
            outputname=strcat('ROI1_lme_TF_',num2TF_assignment(q));
    else
            outputname=strcat('ROI2_lme_TF_log_',num2TF_assignment(q));
    end

    save(outputname,'lme_TFX');
%     h= figure(q);
%     set(h,'units','normalized','outerposition',[0 0 1 1]);
%     set(h,'Name',num2TF_assignment(q));
%     subplot(2,1,1)
%     plotResiduals(lme_TFX,'fitted')
%     grid on;
%     subplot(2,1,2)
%     plotResiduals(lme_TFX,'probability')
%     grid on;
%     xlabel(sprintf(strcat('\n','pValue:',num2str(lme_TFX.Coefficients(2,:).pValue),'    and','    Estimate:',num2str(lme_TFX.Coefficients(2,:).Estimate),'\n','Lower:',num2str(lme_TFX.Coefficients(2,:).Lower),'    and','    Upper:',num2str(lme_TFX.Coefficients(2,:).Upper))));
%     print(h,char(outputname),'-bestfit','-dpdf','-r0')
end
% close all;
