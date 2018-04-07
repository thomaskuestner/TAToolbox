clear all;clc;
%please fill out!!!! - !!!!
    %which ROI dou you need 1 or 2?
        ROIX=2;
   %do you want outliers? 
        outlier_included=false;
   %do you want plots?  
        plots=true;
        aspdf=false;
        %config you plots
        subplot_per_row=8;
%please fill out!!!! - !!!!


%%Prework
if ROIX == 1
    filename_to_extract='summarized_data_of_all_Patients_ROI1.mat';
    if outlier_included==true
        number_of_patient=[01,03,06,09,10,13,14,17,18,19,20,21,22,24,25,26,27,28,29]; %complete dataset 3MBqpatients
        smallerthen10=4; %to be improved
    else
        number_of_patient=[01,03,06,10,13,14,17,18,19,20,22,24,25,26,27,28,29];
        smallerthen10=3; %to be improved
    end
    
else %ROIX=2
    filename_to_extract='summarized_data_of_all_Patients_ROI2.mat';
    if outlier_included==true
        number_of_patient=[01,03,06,09,10,13,14,17,18,19,20,21,22,24,25,26,27,28,29]; %complete dataset 3MBqpatients
        smallerthen10=4; %to be improved
    else
        number_of_patient=[01,03,06,09,10,14,17,18,19,20,21,24,25,26,27,28,29];
        smallerthen10=4; %to be improved
    end
end

%definitions for 3MBq Patients
file_to_extract=load(filename_to_extract);
file=file_to_extract.data;
name2number=load('Zuordnung_TFs_to_Number.mat');
length_of_patientnumbers=length(number_of_patient);
tF_Values=1:1:42; %all possible TF-Values in radiomics
length_of_TFV=length(tF_Values);
doses_Values=(0.5:0.25:3); %based on 3MBq Patients
length_of_DV=length(doses_Values);
length_of_diff_DV=length_of_DV-1; %pairs of doses for deltas

%% Calculation
%for every TF
for q=1:length_of_TFV  
    %for every patient
    for i=1:length_of_patientnumbers

        temp_name='pure_data_';
        if i<=smallerthen10
            temp_name=strcat(temp_name,'0');
        end
        name = {strcat(temp_name,int2str(number_of_patient(i)))};

        %for every diff-Dose-value of the TF - d_TFX
        for w=1:length_of_diff_DV
            d_TFX(w,i)=(cell2mat(file.(name{1}).feature_data(q,1,w))-cell2mat(file.(name{1}).feature_data(q,1,w+1)));
        end
    end
    for j=1:length_of_diff_DV
       coef_var(j,1)=(std(d_TFX(j,:))/mean(d_TFX(j,:)));
    end
    comp_coef_var.rawdata=d_TFX;
    comp_coef_var.coef_var=coef_var;
    struct_subname=strcat('Nr_',num2str(q));
    TF.single_datasets.(struct_subname)=comp_coef_var;
    TF.overview(q,:)=coef_var;
end
save('ROI1_comp_coef_var_TFX','TF');

%% plots
if outlier_included==true
    add2figure_title_name=' with outlier (ROI-Size)';
else
    add2figure_title_name=' without outlier (ROI-Size)';
end
if ROIX==1
    rOIname=' ROI1: ';
else
    rOIname=' ROI2: ';
end
%title off igures (tof) - name of figures
tof_boxplots=strcat('distribution coefficients of variation - deltas of TFs in ',rOIname,add2figure_title_name);
tof_coef_var_dose=strcat('distribution coefficients of variation - deltas of TFs in ',rOIname,add2figure_title_name);

if plots==true
    if aspdf == false
        %how many rows are needed?
        maxrow_4_subplot=ceil(length_of_TFV/subplot_per_row);
        %for every TF -> coef Boxplots
            figure('Name',tof_boxplots);set(gcf,'NumberTitle','off');
            for q=1:length_of_TFV
                subplot(maxrow_4_subplot,subplot_per_row,q)
                boxplot(TF.overview(q,:));
                title(name2number.name2number{q+1});
                grid on;
            end
        %for every TF -> Dose-coef diagramm
            figure('Name',strcat(tof_coef_var_dose,'_fig_',num2str(1)));set(gcf,'NumberTitle','off');
            names_delt_dos = {'d(0,50-0,75)';'d(0,75-1,00)';'d(1,00-1,25)';'d(1,25-1,50)';'d(1,50-1,75)';'d(1,75-2,00)';'d(2,00-2,25)';'d(2,00-2,25)';'d(2,25-2,50)';'d(2,50-2,75)';'d(2,75-3,00)'};
            next_figure_count=1; next_figure_add=1;
            for q=1:length_of_TFV
                if next_figure_count==5
                    next_figure_count=1;
                    next_figure_add=next_figure_add+1;
                    figure('Name',strcat(tof_coef_var_dose,'_fig_',num2str(next_figure_add)));set(gcf,'NumberTitle','off');
                end
                subplot(4,1,next_figure_count)
                plot(1:1:10,TF.overview(q,:));
                set(gca,'xtick',1:10,'xticklabel',names_delt_dos)
                %boxplot(TF.overview(q,:));
                title(name2number.name2number{q+1});
                grid on;
                next_figure_count=next_figure_count+1;
            end
        
    else %aspdf PDF is generated
        for q=1:length_of_TFV
            waaaitbar=waitbar(q/length_of_TFV);
            boxplot(TF.overview(q,:));
            title(name2number.name2number{q+1});
            xlabel(tof_boxplots);
            grid on;
%             set(h,'Units','Inches');
%             pos = get(h,'Position');
%             set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
            print((name2number.name2number{q+1}),'-dpdf','-fillpage');
        end
        close(waaaitbar);
    end
    
end



