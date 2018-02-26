% Skript for statistical analysis with the Radiomics Toolbox features from PET MoCo- Data

%% Preprocessing 

flag_plot = 1;

struct = load('C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\05_Code\Philipp_Statistik_Skripte\MoCo_Corrected_Cell');
current_Data= struct.features(:,:,:);
counter = 1;
counter_1 = 1;
counter_2 = 1;
datatype = inputdlg(sprintf('1 = all Tfs from the all 3 different types of data\n 2 = DICOM and CORRECTED\n 3 = Only GATED'),'Please enter one of the below discribed numbers'); 

switch str2num(datatype{1})
    case 1 % Loop for all TFs of all measurements, sorted in final_output
       for k = 1:42
        for i = 1:42
            feature_value_0(counter) = current_Data{k,i,i};
            counter = counter + 1;
            var_feature_0 = feature_value_0;
        end
        k = k + 1;
       end
    final_output = reshape(feature_value_0,14,42);
    
% Loops for TF pre- analysis
    case 2 % Loop for same TFs of all 'Corrected Files' and for same TFs of all 'DICOM files'
            for l = 1:42
                for i = 1:3:42
                feature_value_1(counter_1) = current_Data{l,i,i};
                counter_1 = counter_1 + 1;
                end
            l = l + 1;
            end
            
        var_temp_corr = feature_value_1;
        final_output_corr = reshape(feature_value_1,14,42);
        for o = 1:42
        for j = 2:3:42
            feature_value_2(counter_2) = current_Data{var_number_feature,j,j};
            counter_2 = counter_2 + 1;
            var_feature_2 = feature_value_2;
        end
            o = o + 1;
        end
        
        var_temp_corr = feature_value_1;
        final_output_corr = reshape(feature_value_1,14,42);
        
    case 3 % Loop for same TFs of all 'Gated files'
        for i = 3:3:42
            feature_value_3(counter) = current_Data{var_number_feature,i,i};
            counter = counter + 1;
            var_feature_3 = feature_value_3;
        end
    otherwise
        error('Wrong Input!');
end

clearvars i k j l o
%% Statistical Methods
% 1. Dependant Variables Loop for running through all 42 TFs and safe them,
% for plotting reasons

if  (exist('var_feature_1')&& exist('var_feature_2'))
    
        if flag_plot == 1
        Plot = [var_feature_1',var_feature_2'];
        figure
    	plot(Plot, 'o');
        
    % T-Test -> Wenn tTest versagt -> Wilcoxon
    [h_ttest,p_ttest] = ttest(var_feature_1,var_feature_2); 
    
        if h_ttest == 0
        % Wilcoxon- Test bei nicht-normalverteilten Stichproben
        [p_wilcox,h_wilcox] = ranksum(var_feature_1,var_feature_2); % Reihenfolge der Variablen evtl. abändern
        end
        
    end
end
%% All Features of one datatype -> implement up
for i = 1:3:42
            feature_value_0(count) = current_Data{var_number_feature,i,i};
            count = count + 1;
            var_feature_0 = feature_value_0;
end