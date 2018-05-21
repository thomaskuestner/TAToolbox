%% Prework
clear all;
clc;

load('Measured_vs_Simulated_allDosis_Mask_TK.mat');
CA1=table2cell(MeasuredvsSimulatedallDosisMaskTK);
CountTF=size(CA1,1);
countvalue_pairs= ((size(CA1,2)-1)/2);

%% Calculation of relative procentage difference between mes and sim + plot
%(TF_x_sim-TF_x_mes)/TF_x_mes
differ_mes_vs_sim(CountTF,countvalue_pairs)=0;
diff_is_getting_greater(CountTF,1)=0;
for i=1:countvalue_pairs
    for k=1:CountTF
        absolut_differ_mes_vs_sim(k,i)=(CA1{k,i+6}-CA1{k,i+1});
        differ_mes_vs_sim(k,i)=absolut_differ_mes_vs_sim(k,i)/CA1{k,i+1};
    end
end

% First Try to sort the differences
for k=1:CountTF
    [diff_max_v,diff_max_i] = max(abs(differ_mes_vs_sim(k,:)));
    if diff_max_i==5
        [diff_max_v,diff_max_i] = max(abs(differ_mes_vs_sim(k,1:4)));
        if diff_max_i==4
            [diff_max_v,diff_max_i] = max(abs(differ_mes_vs_sim(k,1:3)));
            if diff_max_i==3
                diff_is_getting_greater(k,1)=true;
            end
        end
    end
end

%% ingroup-Test
for i=1:4
    for k=1:CountTF
        diff_ingroup_mes(k,i)=(CA1{k,i+2}-CA1{k,2})/CA1{k,2};
        diff_ingroup_sim(k,i)=(CA1{k,i+7}-CA1{k,7})/CA1{k,7};
    end
end

for k=1:CountTF
    if isempty(find(abs(diff_ingroup_mes(k,:))>0.25, 1))
        status=0; %'not significant';
    else
        status=1; %'significant';
    end
    diff_ingroup_mes(k,5)=status;
    
    if isempty(find(abs(diff_ingroup_sim(k,:))>0.25, 1))
        status=0; %'not significant';
    else
        status=1; %'significant';
    end
    diff_ingroup_sim(k,5)=status;
end


%% Statistcal-Tests on the differences

%% Plot of the differences
figure(1)
hold on;
ylim([-1 1])
for i=1:CountTF
    plot(linspace(1,countvalue_pairs,countvalue_pairs),differ_mes_vs_sim(i,:));
end
grid on;
hold off;

%% Statistcal-Tests on the origin data - always paired because same simulation was applied on data
%Paired T-Test
for k=1:CountTF
    %Create Compare Matrix
    for i=1:((size(CA1,2)-1)/2)-1
            x(i,1)=CA1{k,i+2}; x_log(i,1)= abs(log(x(i,1))); x_sqrt(i,1)=sqrt(abs(x(i,1)));
            y(i,1)=CA1{k,i+7}; y_log(i,1)= abs(log(y(i,1))); y_sqrt(i,1)=sqrt(abs(y(i,1)));
            x_friedman(i,1)=x(i,1);
            x_friedman(i,2)=y(i,1);
    end
    %Normaldistribution Kolmogorow-Smirnow-Test
    [h_nd_test(k,1),p_nd_test(k,1)]=kstest(absolut_differ_mes_vs_sim(k,:));
    %T-Test
        [h_t_test(k,1),p_t_test(k,1)] = ttest(x,y); % Nullhypthose Gruppe A und Gruppe B sind nicht unterschiedlich -> Beispiel p=0,41 -> sind nicht unterschiedlich |  p=0,01 -> sind unterschiedlich
    %Wilcoxon https://stats.stackexchange.com/questions/91034/difference-between-the-wilcoxon-rank-sum-test-and-the-wilcoxon-signed-rank-test
        [p_wilcoxon(k,1), h_wilcoxon(k,1)] = signrank(x,y); % also Nullhypthose ist Gruppe A - Gruppe B einen Median von Null -> Gruppe A und Gruppe B sind nicht "unterschiedlich" -> Beispiel p=0.33 -> sind nicht unterschiedlich | p=0.04 -> sind unterschiedlich
    %Friedman
        [p_friedman(k,1),tbl{k,1}] = friedman(x_friedman,2,'off'); %Ranktest - Nullhypthose Gruppe A und Gruppe B sind nicht unterschiedlich -> Beispiel p=0,41 -> sind nicht unterschiedlich |  p=0,01 -> sind unterschiedlich
    %Pearson Correlation (just linear Correlation)
        % r = .10 entspricht einem schwachen Effekt
        % r = .30 entspricht einem mittleren Effekt
        % r = .50 entspricht einem starken Effekt
        [R_Pearson(k,1),p_Pearson(k,1)] = corr(x,y,'Type','Pearson'); % (mächtiger als Spearman) linear bei p<0,05 
        R_Pearson_strong_relevant(CountTF,1)=0;R_Pearson_relevant(CountTF,1)=0;R_Pearson_unrelevant(CountTF,1)=0;
        if(abs(R_Pearson(k,1))>0.5)
            R_Pearson_relevant(k,1) = R_Pearson(k,1);
            if (p_Pearson(k,1)<=0.05)
                R_Pearson_strong_relevant(k,1)=R_Pearson(k,1);
            end
        else
            R_Pearson_unrelevant(k,1) = p_Pearson(k,1);
        end
    %Spearman Correlation (linear or Ranks - Correlation) %Rang - linear bei p<0,05
        [R_Spearman(k,1),p_Spearman(k,1)] = corr(x,y,'Type','Spearman');
    
 %log-Data%%%%%%%%%%%%%log-Data %%%%%%%%%%%%% log-Data
    %Pearson Correlation (just linear Correlation)
        [R_Pearson_log(k,1),p_Pearson_log(k,1)] = corr(x_log,y_log,'Type','Pearson'); % (mächtiger als Spearman) linear bei p<0,05 
        R_Pearson_strong_relevant_log(CountTF,1)=0;R_Pearson_relevant_log(CountTF,1)=0;R_Pearson_unrelevant_log(CountTF,1)=0;
        if(abs(R_Pearson_log(k,1))>0.5)
            R_Pearson_relevant_log(k,1) = R_Pearson_log(k,1);
            if (p_Pearson(k,1)<=0.05)
                R_Pearson_strong_relevant_log(k,1)=R_Pearson_log(k,1);
            end
        else
            R_Pearson_unrelevant_log(k,1) = p_Pearson(k,1);
        end
    %Spearman Correlation (linear or Ranks - Correlation) %Rang - linear bei p<0,05
        [R_Spearman_log(k,1),p_Spearman_log(k,1)] = corr(x_log,y_log,'Type','Spearman');
    %log-Data%%%%%%%%%%%%%log-Data %%%%%%%%%%%%% log-Data
    
 %sqrt-Data%%%%%%%%%%%%%sqrt-Data%%%%%%%%%%%%%sqrt-Data
    %Pearson Correlation (just linear Correlation)
        [R_Pearson_sqrt(k,1),p_Pearson_sqrt(k,1)] = corr(x,y_sqrt,'Type','Pearson'); % (mächtiger als Spearman) linear bei p<0,05 
        R_Pearson_strong_relevant_sqrt(CountTF,1)=0;R_Pearson_relevant_sqrt(CountTF,1)=0;R_Pearson_unrelevant_sqrt(CountTF,1)=0;
        if(abs(R_Pearson_sqrt(k,1))>0.5)
            R_Pearson_relevant_sqrt(k,1) = R_Pearson_sqrt(k,1);
            if (p_Pearson(k,1)<=0.05)
                R_Pearson_strong_relevant_sqrt(k,1)=R_Pearson_sqrt(k,1);
            end
        else
            R_Pearson_unrelevant_sqrt(k,1) = p_Pearson(k,1);
        end
    %Spearman Correlation (linear or Ranks - Correlation) %Rang - linear bei p<0,05
        [R_Spearman_sqrt(k,1),p_Spearman_sqrt(k,1)] = corr(x,y_sqrt,'Type','Spearman');
    %sqrt-Data%%%%%%%%%%%%%sqrt-Data%%%%%%%%%%%%%sqrt-Data
end

%% Graphical Output
fontsizelegend = 12;
mark_size = 8;
colorstring = 'kbmr';
for k=1:CountTF
     for i=1:((size(CA1,2)-1)/2)-1
            x_plot(i,1)=CA1{k,i+2}; x_plot_log(i,1)=abs(log(x_plot(i,1))); x_plot_sqrt(i,1)=sqrt(x_plot(i,1));
            y_plot(i,1)=CA1{k,i+7}; y_plot_log(i,1)=abs(log(y_plot(i,1))); y_plot_sqrt(i,1)=sqrt(y_plot(i,1));
     end
    h = figure;
    % unchanged data
    %ax1=subplot(3,1,1);
    hold on;
    plot(x_plot(1,1),y_plot(1,1),'bo','MarkerSize',mark_size,'Color', colorstring(1));
    plot(x_plot(2,1),y_plot(2,1),'bo','MarkerSize',mark_size,'Color', colorstring(2));
    plot(x_plot(3,1),y_plot(3,1),'bo','MarkerSize',mark_size,'Color', colorstring(3));
    plot(x_plot(4,1),y_plot(4,1),'bo','MarkerSize',mark_size,'Color', colorstring(4));
    hold off;
    filename_plot=char(CA1{k,1}(1,1));
    title(filename_plot);
    refline(1);
    grid on;   
    text_legend='measured';
    text_legend=strcat(text_legend,'\n \n','K-Smirnov-Test p-Wert = ',num2str(p_nd_test(k,1)));
    text_legend=strcat(text_legend,'   K-Smirnov-Test H-Wert = ',num2str(h_nd_test(k,1)));
    text_legend=strcat(text_legend,'\n \n','t-Test p-Wert = ',num2str(p_t_test(k,1)));
    text_legend=strcat(text_legend,'     Wilcoxon signrank p-Wert = ',num2str(p_wilcoxon(k,1)));
    text_legend=strcat(text_legend,'     Friedman p-Wert = ',num2str(p_friedman(k,1)));
    text_legend=strcat(text_legend,'\n \n','Pearson R Wert = ',num2str(R_Pearson(k,1)));   
    text_legend=strcat(text_legend,'   Pearson p-Wert = ',num2str(p_Pearson(k,1))); 
    text_legend=strcat(text_legend,'\n','Spearman R Wert = ',num2str(R_Spearman(k,1)));
    %real legend of dots
    real_fig_legend=legend('25.0% A','12.5% A','6.25% A','3.13% A','y=x','Location','best');
    %end of text_legend
    text_legend=sprintf(strcat(text_legend,'   Spearman p-Wert = ',num2str(p_Spearman(k,1))));
    own_xlabel=xlabel(text_legend);ylabel('simulated');
    set(own_xlabel, 'FontSize', fontsizelegend) 
%     %Log data -------------- %%%%%%%%%%%%%%%%%
%     ax2=subplot(3,1,2);
%     plot(x_plot_log(:,1),y_plot_log(:,1),'bo');
%     filename_plot=char(CA1{k,1}(1,1));
%     title(strcat(filename_plot,' Log'));
%     %refline(1);
%     grid on;
%     text_legend='measured';
%     text_legend=strcat(text_legend,'\n \n','Log Pearson R Wert = ',num2str(R_Pearson_log(k,1)));   
%     text_legend=strcat(text_legend,'   Log Pearson p-Wert = ',num2str(p_Pearson_log(k,1))); 
%     text_legend=strcat(text_legend,'\n','Log Spearman R Wert = ',num2str(R_Spearman_log(k,1)));
%     text_legend=sprintf(strcat(text_legend,'   Log Spearman p-Wert = ',num2str(p_Spearman_log(k,1))));
%     own_xlabel=xlabel(text_legend);ylabel('simulated');
%     set(own_xlabel, 'FontSize', fontsizelegend) 
%     %sqrt data -------------- %%%%%%%%%%%%%%%%%
%     ax2=subplot(3,1,3);
%     plot(x_plot(:,1),y_plot_sqrt(:,1),'bo');
%     filename_plot=char(CA1{k,1}(1,1));
%     title(strcat(filename_plot,' Sqrt'));
%     %refline(1);
%     grid on;
%     text_legend='measured';
%     text_legend=strcat(text_legend,'\n \n','Sqrt Pearson R Wert = ',num2str(R_Pearson_sqrt(k,1)));   
%     text_legend=strcat(text_legend,'   Sqrt Pearson p-Wert = ',num2str(p_Pearson_sqrt(k,1))); 
%     text_legend=strcat(text_legend,'\n','Sqrt Spearman R Wert = ',num2str(R_Spearman_sqrt(k,1)));
%     text_legend=sprintf(strcat(text_legend,'   Sqrt Spearman p-Wert = ',num2str(p_Spearman_sqrt(k,1))));
%     own_xlabel=xlabel(text_legend);ylabel('simulated');
%     set(own_xlabel, 'FontSize', fontsizelegend) 
    %pdf-setttings
    set(h,'Units','Inches');
    pos = get(h,'Position');
    %set(h,'position',[pos(1:2)/4 pos(3:4)*5])
    set(h, 'Units', 'normalized', 'Position', [0.3, 0.2, 0.5, 0.5]);
    %set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h,filename_plot,'-bestfit','-dpdf','-r0') %,'-bestfit'
end