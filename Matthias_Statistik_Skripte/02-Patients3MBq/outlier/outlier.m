%% prework
clear all;clc;
%% UI
which_outlier='TF_Value'; %'TF_Value' or 'ROI_Size'

%% ROI Sizes
switch which_outlier
    case 'ROI_Size'
        filename_plot='Outlier_Boxplots';
        h=figure;
        for i=1:2
        ROI=i;
        if ROI==1
            rawdata = load('summarized_data_of_all_Patients_ROI1.mat');
        else
            rawdata = load('summarized_data_of_all_Patients_ROI2.mat');
        end
        ax1=subplot(1,2,i);
        hold on;
        roi_sizes=rawdata.data.all_Patients_ROI_sizes;
        roi_bp=boxplot(roi_sizes,'Whisker',1,'Labels','-');
        median_ROIX = median(roi_sizes);
        mean_ROIX=mean(roi_sizes);
        std_ROIX = round(std(roi_sizes),0);
        var_coeff_ROIX=round((std_ROIX/mean_ROIX),2);
        
        outlier_ROIX_obj = findobj(roi_bp,'Tag','Outliers');
        outlier_ROIX = get(outlier_ROIX_obj,'YData');
        outlier_ROIX_obj.LineWidth=2;outlier_ROIX_obj.Marker='o'; 
        num_outlier_ROIX=length(outlier_ROIX);
        grid on;
        grid minor;

        if ROI==1
            ylim([1800 7500]);
            set(gca,'YTick',0:500:10000);
            title('ROI 1 - rechter Leberlappen')
        else
            ylim([50 300]);
            set(gca,'YTick',0:20:500);
            title('ROI 2 - linker Leberlappen')
        end
        x_text_label=strcat('Median = ',num2str(median_ROIX), ' Voxel');
        x_text_label=strcat(x_text_label,'\r\n','Standardabweichung = ', num2str(std_ROIX), ' Voxel');
        x_text_label=strcat(x_text_label,'\r\n','Variationskoeffizient = ', num2str(var_coeff_ROIX));
        x_text_label=strcat(x_text_label,'\r\n','Ausreiﬂeranzahl = ', num2str(num_outlier_ROIX));
        x_text_label=sprintf(x_text_label);
        xlabel(x_text_label);
        end 
        print(h,'Outlier_Boxplot_ROI_Sizes','-dpng','-r800')
        %print(h,filename_plot,'-bestfit','-dpdf','-r0') % ,'-bestfit'

        %%%%%% TF-Value outliers%%%%%%
         case 'TF_Value'
            xaxis_ticks={'0.50';'0.75';'1.00';'1.25';'1.50';'1.75';'2.00';'2.25';'2.50';'2.75';'3.00'};
            load('Zuordnung-TFs-to-Number.mat');
            number_of_patient=[01,03,06,09,10,13,14,17,18,19,20,21,22,24,25,26,27,28,29]; %to be improved
            length_of_patientnumbers=length(number_of_patient);
            for i=1:2
                %both ROIs are been watched
                ROI=i;
                if ROI==1
                    rawdata = load('summarized_data_of_all_Patients_ROI1.mat');
                    roioutlier1=4;roioutlier2=12;
                else
                    rawdata = load('summarized_data_of_all_Patients_ROI2.mat');
                    roioutlier1=6;roioutlier2=13;
                end
                %all TFs are been watched
                
                
                for k=1:42
                    tf_data_median(11)=0;
                    filename_plot=num2TF_assignment(k);
                    filename_plot=strcat(filename_plot,' ROI',num2str(i));
                    h=figure;
                    hold on;           
                    for p=1:length_of_patientnumbers
                        temp_name='pure_data_';
                        if p<5
                        temp_name=strcat(temp_name,'0');
                        end
                        name = {strcat(temp_name,int2str(number_of_patient(p)))};
                        tf_data_com=cell2mat(rawdata.data.(name{1}).feature_data(k,1,:));
                        for dose=1:11
                            tf_data(dose)=tf_data_com(1,1,dose);
                            tf_data_median(p,dose)=tf_data_com(1,1,dose);
                        end
                        
                        if p==roioutlier1 | p==roioutlier2
                            plot(tf_data,'-bo','MarkerSize',3,'Color','m')
                        else
                            plot(tf_data,'-bo','MarkerSize',3,'Color','k')
                        end                  
                    end
                    for dose=1:11
                        tf_data_median_r(dose)=median(tf_data_median(:,dose));
                    end
                    tf_data_median_r=median(tf_data_median);
                    plot(tf_data_median_r,'-bo','linewidth',3,'MarkerSize',3,'Color','r')
                    grid on;
                    set(gca,'xtick',1:11,'xticklabel',xaxis_ticks)
                    xtextlabel=sprintf('Dosen');
                    xlabel(xtextlabel);ylabel('TF-Wert');
                    title(char(filename_plot));              
                    print(h,char(filename_plot),'-dpdf','-r0')
                    clear tf_data_mean;
                end
            %list outliers by TF-Value
%             count_your_depts(42,19)=0;
%              for tf=1:42
%                  for dose=1:11
%                     for p=1:length_of_patientnumbers
%                     temp_name='pure_data_';
%                     if p<5
%                         temp_name=strcat(temp_name,'0');
%                     end
%                     name = {strcat(temp_name,int2str(number_of_patient(p)))};
%                     tf_data_com(p)=cell2mat(rawdata.data.(name{1}).feature_data(tf,1,dose));  
%                     end
%                     tf_bp=boxplot(tf_data_com,'Whisker',1,'Labels','-');
%                     outlier_tfx_d_obj = findobj(tf_bp,'Tag','Outliers');
%                     outlier_tfx_d = get(outlier_tfx_d_obj,'YData');
%                     for findid=1:length(outlier_tfx_d)
%                         outlierid=find(tf_data_com==outlier_tfx_d(findid));
%                         count_your_depts(tf,outlierid)=count_your_depts(tf,outlierid)+1;                     
%                     end
%                  end
%              end
%              count_number_of_outlier{i}=count_your_depts;
%              clear count_your_depts;
            end   
             
    otherwise
           msgbox('Eingabewert!')
             
end



