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