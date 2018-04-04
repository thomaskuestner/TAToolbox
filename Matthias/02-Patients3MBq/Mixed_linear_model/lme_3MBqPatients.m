%%Prework
%filename_to_extract=uigetfile;
clear all;clc;
filename_to_extract='summarized_data_of_all_Patients_ROI1.mat';
file_to_extract=load(filename_to_extract);
file=file_to_extract.data;

number_of_patient=[01,03,06,09,10,13,14,17,18,19,20,21,22,24,25,26,27,28,29]; %to be improved
length_of_patientnumbers=length(number_of_patient);
TF_Values=1:1:42; %all possible TF-Values in radiomics
length_of_TFV=length(TF_Values);
Doses_Values=(0.5:0.25:3); %based on 3MBq Patients
length_of_DV=length(Doses_Values);
count=1;
TFX(1,:)={'Identification_ID','Strength of Dose','TF-Value'};
%for q=1:length_of_TFV
    for i=1:length_of_patientnumbers
        temp_name='pure_data_';
            if i<5
            temp_name=strcat(temp_name,'0');
            end
        name = {strcat(temp_name,int2str(number_of_patient(i)))};

        for w=1:length_of_DV
            TFX(w+count,:)={(name{1}),num2str(Doses_Values(w)),num2str(cell2mat(file.(name{1}).feature_data(1,1,w)))};
        end
        count=count+length_of_DV;
    end
    TFX=cell2dataset(TFX);
%end

%mat2dataset()