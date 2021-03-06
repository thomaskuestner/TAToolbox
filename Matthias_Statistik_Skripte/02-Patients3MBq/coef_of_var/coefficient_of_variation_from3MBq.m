clear all;clc; close all;
%% User Interaction
%please fill out!!!! - !!!!
    %which ROI dou you need 1 or 2?
        ROIX=2;
   %do you want outliers? 
        outlier_included=false; % 4 "worst (TF-value-outlier)" datasets will be excluded
   %do you want plots?  
        plots=true;
        aspdf=true;
        %config you plots
        subplot_per_row=8;
    %do you want a save file (matlab-data)?
        savefile=true;
%please fill out!!!! - !!!!

%% Prework
space=' ';
doublespace='  ';

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

%% definitions for 3MBq Patients
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
            d_TFX(w,i)=(cell2mat(file.(name{1}).feature_data(q,1,11))-cell2mat(file.(name{1}).feature_data(q,1,w)));
        end
    end
    for j=1:length_of_diff_DV
       coef_var(j,1)=(std(d_TFX(j,:))/mean(d_TFX(j,:)));
    end
    all_sum_coef_var=sum(abs(coef_var(:,1)));
    
    %save data
    comp_coef_var.rawdata=d_TFX;
    comp_coef_var.coef_var=coef_var;
    struct_subname=strcat('Nr_',num2str(q));
    TF.single_datasets.(struct_subname)=comp_coef_var;
    TF.all_coef_var(:,q)=coef_var;
    TF.all_sum_coef_var(q)=all_sum_coef_var';
    
end
% savefile yes or no?
if savefile==true
    save('ROI2_comp_coef_var_TFX','TF');
end


%% plots
if outlier_included==true
    add2figure_title_name=' with outlier ()';
else
    add2figure_title_name=' without the strongest 4 outlier';
end
if ROIX==1
    rOIname=' ROI1_ ';
else
    rOIname=' ROI2_ ';
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
                boxplot(TF.all_coef_var(:,q));
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
                plot(1:1:10,TF.all_coef_var(:,q),':o');
                set(gca,'xtick',1:10,'xticklabel',names_delt_dos)
                title(name2number.name2number{q+1});
                xlabel(strcat('Sum of absolute values of coefficient of varaiation =',' ',num2str(TF.all_sum_coef_var(q))),'FontWeight','bold','color',[.5 .4 .7]);
                grid on;
                next_figure_count=next_figure_count+1;
            end
        
    else %aspdf PDF is generated
         %for every TF -> coef Boxplots - PDF
        for q=1:length_of_TFV
            waaaitbar=waitbar(q/length_of_TFV);
            boxplot(TF.all_coef_var(:,q));
            title(name2number.name2number{q+1});
            xlabel(tof_boxplots);
            grid on;
            print((name2number.name2number{q+1}),'-dpdf','-fillpage');
        end
        close(waaaitbar);
        close all;
        %for every TF -> Dose-coef diagramm -PDF
            next_figure_count=1;
            next_figure_add=1;
            figure('Name',strcat(tof_coef_var_dose,'_fig_',num2str(next_figure_add)));set(gcf,'NumberTitle','off');
            names_delt_dos = {'d(3,00-0,5)';'d(3,00-0,75)';'d(3,00-1,00)';'d(3,00-1,25)';'d(3,00-1,50)';'d(3,00-1,75)';'d(3,00-2,00)';'d(3,00-2,25)';'d(3,00-2,50)';'d(3,00-2,75)'};
            for q=1:length_of_TFV
                waaaitbar=waitbar(q/length_of_TFV);
                if next_figure_count==5
                    next_figure_count=1;
                    next_figure_add=next_figure_add+1;
                    figure('Name',strcat(tof_coef_var_dose,'_fig_',num2str(next_figure_add)));set(gcf,'NumberTitle','off');
                end
                subplot(4,1,next_figure_count)
                plot(1:1:10,TF.all_coef_var(:,q),':o');
                set(gca,'xtick',1:10,'xticklabel',names_delt_dos,'FontSize',7)
                temptitle=({name2number.name2number{q+1},tof_coef_var_dose});
                title(temptitle,'FontSize',9);
                tempxlabel=['Sum of absolute values of coefficients of variation =', space, num2str(TF.all_sum_coef_var(q))];
                xlabel(tempxlabel,'FontWeight','bold','color',[0.6392    0.0784    0.1804]);
                grid on;
                next_figure_count=next_figure_count+1;
                
                %plot as pdf
                if next_figure_count==5
                    print(strcat(num2str(q),'_',tof_coef_var_dose),'-dpdf','-fillpage');
                end
            end
        close all;
        close(waaaitbar);

    end
    
end



