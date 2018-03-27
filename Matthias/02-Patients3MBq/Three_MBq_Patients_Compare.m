%% Prework
clear all;clc;
load('summarized_data_of_all_patients_V2.mat');

%create the names of the fields in the struct
number_of_patient=[01,03,06,09,10,13,14,17,18,19,20,21,22,24,25,26,27,28,29];
name={};
length_data=19;
% you choose which dose in [MBq]
dose=3;

%for histogramms
for i=1:length_data
    temp_name='pure_data_';
    if i<5
        temp_name=strcat(temp_name,'0');
    end
    name = {strcat(temp_name,int2str(number_of_patient(i)))};
    % here comes your statistic code (example:
    % temp_data=data.(name{1}).Size_of_ROIs;)
    tf_Values_of_one_Dose(:,i)=cell2mat(data.(name{1}).feature_data(:,1,get_zValue_data_table(dose)));
    

end
%using temp for shorter name
temp=tf_Values_of_one_Dose;

%plot basic statistic features
figure
ax1 = subplot(2,1,1);
ax2 = subplot(2,1,2);
grid on;
nbins=10;
h = histogram(ax1,temp(1,:),nbins); 
b = boxplot(ax2,temp(1,:),'Orientation','horizontal');




% % CA1=table2cell(MeasuredvsSimulatedallDosisMaskTK);
% % CountTF=size(CA1,1);
% % countvalue_pairs= ((size(CA1,2)-1)/2);
% 
% %% Calculation of relative procentage difference between mes and sim + plot
% %(TF_x_sim-TF_x_mes)/TF_x_mes
% differ_mes_vs_sim(CountTF,countvalue_pairs)=0;
% diff_is_getting_greater(CountTF,1)=0;
% for i=1:countvalue_pairs
%     for k=1:CountTF
%         differ_mes_vs_sim(k,i)=(CA1{k,i+6}-CA1{k,i+1})/CA1{k,i+1};
%     end
% end
% 
% % First Try to sort the differences
% for k=1:CountTF
%     [diff_max_v,diff_max_i] = max(abs(differ_mes_vs_sim(k,:)));
%     if diff_max_i==5
%         [diff_max_v,diff_max_i] = max(abs(differ_mes_vs_sim(k,1:4)));
%         if diff_max_i==4
%             [diff_max_v,diff_max_i] = max(abs(differ_mes_vs_sim(k,1:3)));
%             if diff_max_i==3
%                 diff_is_getting_greater(k,1)=true;
%             end
%         end
%     end
% end
% 
% %% ingroup-Test
% for i=1:4
%     for k=1:CountTF
%         diff_ingroup_mes(k,i)=(CA1{k,i+2}-CA1{k,2})/CA1{k,2};
%         diff_ingroup_sim(k,i)=(CA1{k,i+7}-CA1{k,7})/CA1{k,7};
%     end
% end
% 
% for k=1:CountTF
%     if isempty(find(abs(diff_ingroup_mes(k,:))>0.25, 1))
%         status=0; %'not significant';
%     else
%         status=1; %'significant';
%     end
%     diff_ingroup_mes(k,5)=status;
%     
%     if isempty(find(abs(diff_ingroup_sim(k,:))>0.25, 1))
%         status=0; %'not significant';
%     else
%         status=1; %'significant';
%     end
%     diff_ingroup_sim(k,5)=status;
% end
% 
% 
% %% Statistcal-Tests on the differences
% 
% %% Plot of the differences
% figure(1)
% hold on;
% ylim([-1 1])
% for i=1:CountTF
%     plot(linspace(1,countvalue_pairs,countvalue_pairs),differ_mes_vs_sim(i,:));
% end
% grid on;
% hold off;
% 
% 
% %% Statistcal-Tests on the origin data
% %Paired T-Test
% for k=1:CountTF
%     %Create Compare Matrix
%     for i=1:((size(CA1,2)-1)/2)-1
%             x(i,1)=CA1{k,i+2};
%             y(i,1)=CA1{k,i+7};
%             x_friedman(i,1)=x(i,1);
%             x_friedman(i,2)=y(i,1);
%     end
%     %T-Test
%         [h_t_test(k,1),p_t_test(k,1)] = ttest(x,y);
%     %Wilcoxon https://stats.stackexchange.com/questions/91034/difference-between-the-wilcoxon-rank-sum-test-and-the-wilcoxon-signed-rank-test
%         [p_wilcoxon(k,1), h_wilcoxon(k,1)] = signrank(x,y);
%     %Friedman
%         [p_friedman(k,1),tbl{k,1}] = friedman(x_friedman,2,'off');
%     %Pearson Correlation (just linear Correlation)
%         % r = .10 entspricht einem schwachen Effekt
%         % r = .30 entspricht einem mittleren Effekt
%         % r = .50 entspricht einem starken Effekt
%         [R_Pearson(k,1),p_Pearson(k,1)] = corr(x,y,'Type','Pearson');
%         R_Pearson_strong_relevant(CountTF,1)=0;R_Pearson_relevant(CountTF,1)=0;R_Pearson_unrelevant(CountTF,1)=0;
%         if(abs(R_Pearson(k,1))>0.5)
%             R_Pearson_relevant(k,1) = R_Pearson(k,1);
%             if (p_Pearson(k,1)<=0.05)
%                 R_Pearson_strong_relevant(k,1)=R_Pearson(k,1);
%             end
%         else
%             R_Pearson_unrelevant(k,1) = p_Pearson(k,1);
%         end
%     %Spearman Correlation (linear or Ranks - Correlation)
%         [R_Spearman(k,1),p_Spearman(k,1)] = corr(x,y,'Type','Spearman');
% end




%% Graphical Output
% 
% for k=1:CountTF
%      for i=1:((size(CA1,2)-1)/2)-1
%             x_plot(i,1)=CA1{k,i+2};
%             y_plot(i,1)=CA1{k,i+7};
%      end
%     h = figure;
%     plot(x_plot(:,1),y_plot(:,1),'bo');
%     filename_plot=char(CA1{k,1}(1,1));
%     title(filename_plot);
%     refline(1);
%     grid on;
%     set(h,'Units','Inches');
%     pos = get(h,'Position');
%     set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
%     text_legend='measured';
%     text_legend=strcat(text_legend,'\n','t-Test P Wert = ',num2str(p_t_test(k,1)));
%     text_legend=strcat(text_legend,'\n','Wilcoxon signrank P Wert = ',num2str(p_wilcoxon(k,1)));
%     text_legend=strcat(text_legend,'\n','Friedman P Wert = ',num2str(p_friedman(k,1)));
%     text_legend=strcat(text_legend,'\n','Pearson R Wert = ',num2str(R_Pearson(k,1)));   
%     text_legend=strcat(text_legend,'\n','Pearson P Wert = ',num2str(p_Pearson(k,1))); 
%     text_legend=strcat(text_legend,'\n','Spearman R Wert = ',num2str(R_Spearman(k,1)));
%     text_legend=sprintf(strcat(text_legend,'\n','Spearman P Wert = ',num2str(p_Spearman(k,1))));
%     xlabel(text_legend);ylabel('simulated');
%     print(h,filename_plot,'-dpdf','-r0')
% end

