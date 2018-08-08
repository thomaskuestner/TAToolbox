%% Prework
clear all;
clc;

load('Measured_vs_Simulated_allDosis_Mask_TK.mat');
CA1=table2cell(MeasuredvsSimulatedallDosisMaskTK);
CountTF=size(CA1,1);
countvalue_pairs= ((size(CA1,2)-1)/2);
acitivity_values = [50;25;12.5;6.25;3.125];

for k=1:CountTF
    %Create Compare Matrix
    for i=1:((size(CA1,2)-1)/2)%-1 %mes(i,1)=CA1{k,i+2} %sim(i,1)=CA1{k,i+7}
            mes(i,1)=CA1{k,i+1}; mes_log(i,1)= abs(log(mes(i,1))); mes_sqrt(i,1)=sqrt(abs(mes(i,1)));
            sim(i,1)=CA1{k,i+6}; sim_log(i,1)= abs(log(sim(i,1))); sim_sqrt(i,1)=sqrt(abs(sim(i,1)));
    end

%     %Normaldistribution Kolmogorow-Smirnow-Test
%     [h_nd_test(k,1),p_nd_test(k,1)]=kstest(absolut_differ_mes_vs_sim(k,:));

    %Pearson Correlation (just linear Correlation)
        % r = .10 entspricht einem schwachen Effekt
        % r = .30 entspricht einem mittleren Effekt
        % r = .50 entspricht einem starken Effekt
        [R_Pearson_mes(k,1),p_Pearson_mes(k,1)] = corr(mes,acitivity_values,'Type','Pearson'); % (mächtiger als Spearman) linear bei p<0,05 
        [R_Pearson_sim(k,1),p_Pearson_sim(k,1)] = corr(sim,acitivity_values,'Type','Pearson'); % (mächtiger als Spearman) linear bei p<0,05 
    %Spearman Correlation (linear or Ranks - Correlation) %Rang - linear
    %bei p<0,05 ist nicht sinnvoll bei samplegröße < 5 , da dann niedrigst (bester Linearitätswert) 0.08... ist also nie kleiner als 0.05
        [R_Spearman_mes(k,1),p_Spearman_mes(k,1)] = corr(mes,acitivity_values,'Type','Spearman');
        [R_Spearman_sim(k,1),p_Spearman_sim(k,1)] = corr(sim,acitivity_values,'Type','Spearman');
    
%  %log-Data%%%%%%%%%%%%%log-Data %%%%%%%%%%%%% log-Data
%     %Pearson Correlation (just linear Correlation)
       [R_Pearson_mes_log(k,1),p_Pearson_mes_log(k,1)] = corr(mes_log,acitivity_values,'Type','Pearson'); % (mächtiger als Spearman) linear bei p<0,05
       [R_Pearson_sim_log(k,1),p_Pearson_sim_log(k,1)] = corr(sim_log,acitivity_values,'Type','Pearson'); % (mächtiger als Spearman) linear bei p<0,05 
%Spearman Correlation (linear or Ranks - Correlation) %Rang - linear
%bei p<0,05 ist nicht sinnvoll bei samplegröße < 5 , da dann niedrigst (bester Linearitätswert) 0.08... ist also nie kleiner als 0.05
       [R_Spearman_mes_log(k,1),p_Spearman_mes_log(k,1)] = corr(mes_log,acitivity_values,'Type','Spearman');
       [R_Spearman_sim_log(k,1),p_Spearman_sim_log(k,1)] = corr(sim_log,acitivity_values,'Type','Spearman');
%     %log-Data%%%%%%%%%%%%%log-Data %%%%%%%%%%%%% log-Data
%     
%  %sqrt-Data%%%%%%%%%%%%%sqrt-Data%%%%%%%%%%%%%sqrt-Data
%     %Pearson Correlation (just linear Correlation)
        [R_Pearson_mes_sqrt(k,1),p_Pearson_mes_sqrt(k,1)] = corr(mes_sqrt,acitivity_values,'Type','Pearson'); % (mächtiger als Spearman) linear bei p<0,05 
         [R_Pearson_sim_sqrt(k,1),p_Pearson_sim_sqrt(k,1)] = corr(sim_sqrt,acitivity_values,'Type','Pearson'); % (mächtiger als Spearman) linear bei p<0,05 
%Spearman Correlation (linear or Ranks - Correlation) %Rang - linear
%bei p<0,05 ist nicht sinnvoll bei samplegröße < 5 , da dann niedrigst (bester Linearitätswert) 0.08... ist also nie kleiner als 0.05
       [R_Spearman_mes_sqrt(k,1),p_Spearman_mes_sqrt(k,1)] = corr(mes_log,acitivity_values,'Type','Spearman');
       [R_Spearman_sim_sqrt(k,1),p_Spearman_sim_sqrt(k,1)] = corr(sim_log,acitivity_values,'Type','Spearman');
%     %sqrt-Data%%%%%%%%%%%%%sqrt-Data%%%%%%%%%%%%%sqrt-Data
end
%Pearson relevante p-Werte
p_Pearson_mes_rel=find(p_Pearson_mes<0.05); p_Pearson_sim_rel=find(p_Pearson_sim<0.05);
p_Pearson_mes_rel_log=find(p_Pearson_mes_log<0.05); p_Pearson_sim_rel_log=find(p_Pearson_sim_log<0.05);
p_Pearson_mes_rel_sqrt=find(p_Pearson_mes_sqrt<0.05); p_Pearson_sim_rel_sqrt=find(p_Pearson_sim_sqrt<0.05);

%Spearman relevante p-Werte
p_Spearman_mes_rel=find(p_Spearman_mes<0.05); p_Spearman_sim_rel=find(p_Spearman_sim<0.05);
p_Spearman_mes_rel_log=find(p_Spearman_mes_log<0.05); p_Spearman_sim_rel_log=find(p_Spearman_sim_log<0.05);
p_Spearman_mes_rel_sqrt=find(p_Spearman_mes_sqrt<0.05); p_Spearman_sim_rel_sqrt=find(p_Spearman_sim_sqrt<0.05);

% Gliederung von relevanten Linearitäten
% R_Pearson_strong_relevant(CountTF,1)=0;R_Pearson_relevant(CountTF,1)=0;R_Pearson_unrelevant(CountTF,1)=0;
%         if(abs(R_Pearson(k,1))>0.5)
%             R_Pearson_relevant(k,1) = R_Pearson(k,1);
%             if (p_Pearson(k,1)<=0.05)
%                 R_Pearson_strong_relevant(k,1)=R_Pearson(k,1);
%             end
%         else
%             R_Pearson_unrelevant(k,1) = p_Pearson(k,1);
%         end

%% % Graphical Output Korrektur
%plot of all exact linearity values
% close all;
% hold on;
% tf_numbers=1:1:42;
% plot(tf_numbers,p_Spearman_sim_log,'bo');
% text(tf_numbers-0.3, p_Spearman_sim_log+0.015, strcat(' ',num2str(round(R_Spearman_sim_log,2))), 'Fontsize', 9,'Color','m');
% xticks(1:1:42);
% yticks(0:0.05:1);
% help_line=[0,42];
% decision_value=[0.05,0.05];
% plot(help_line,decision_value,'k--')
% grid on;
% %real_fig_legend=legend('Pearson-p-Value','Location','best');
% string_for_x_label=sprintf('TFs substituted by numbers \n log simulated group');
% xlabel(string_for_x_label,'FontSize', 15);
% ylabel('Spearman-p-Value', 'FontSize',15);

% %% Graphical Output - single plot
% fontsizelegend = 12;
% mark_size = 8;
% colorstring = 'kbmr';
% glcm_entropy_id=9;
%     h = figure;
%     % unchanged data
%     ax1=subplot(2,1,1);
%     hold on;
%     plot(mes(1,1),y_plot(1,1),'bo','MarkerSize',mark_size,'Color', colorstring(1));
%     plot(mes(2,1),y_plot(2,1),'bo','MarkerSize',mark_size,'Color', colorstring(2));
%     plot(mes(3,1),y_plot(3,1),'bo','MarkerSize',mark_size,'Color', colorstring(3));
%     plot(mes(4,1),y_plot(4,1),'bo','MarkerSize',mark_size,'Color', colorstring(4));
%     hold off;
%     filename_plot=char(CA1{9,1}(1,1));
%     title(filename_plot);
%     refline(1);
%     grid on;   
%     text_legend='measured';
%     text_legend=strcat(text_legend,'\n \n','K-Smirnov-Test p-Wert = ',num2str(p_nd_test(k,1)));
%     text_legend=strcat(text_legend,'   K-Smirnov-Test H-Wert = ',num2str(h_nd_test(k,1)));
%     text_legend=strcat(text_legend,'\n \n','t-Test p-Wert = ',num2str(p_t_test(k,1)));
%     text_legend=strcat(text_legend,'     Wilcoxon signrank p-Wert = ',num2str(p_wilcoxon(k,1)));
%     text_legend=strcat(text_legend,'     Friedman p-Wert = ',num2str(p_friedman(k,1)));
%     text_legend=strcat(text_legend,'\n \n','Pearson R Wert = ',num2str(R_Pearson(k,1)));   
%     text_legend=strcat(text_legend,'   Pearson p-Wert = ',num2str(p_Pearson(k,1))); 
%     text_legend=strcat(text_legend,'\n','Spearman R Wert = ',num2str(R_Spearman(k,1)));
%     %real legend of dots
%     real_fig_legend=legend('25.0% A','12.5% A','6.25% A','3.13% A','y=x','Location','best');
%     %end of text_legend
%     text_legend=sprintf(strcat(text_legend,'   Spearman p-Wert = ',num2str(p_Spearman(k,1))));
%     own_xlabel=xlabel(text_legend);ylabel('simulated');
%     set(own_xlabel, 'FontSize', fontsizelegend) 