%% Prework
clear all;
clc;

load('Measured_vs_Simulated_allDosis_Mask_TK.mat');
CA1=table2cell(MeasuredvsSimulatedallDosisMaskTK);
CountTF=size(CA1,1);
countvalue_pairs= ((size(CA1,2)-1)/2);

%% Calculation of relative procentage difference between mes and sim + plot
%(TF_x_sim-TF_x_mes)/TF_x_mes
for i=1:countvalue_pairs
    for k=1:CountTF
        differ_mes_vs_sim(k,i)=(CA1{k,i+6}-CA1{k,i+1})/CA1{k,i+1};
    end 
end
figure(1)
hold on;
ylim([-1 1])
for i=1:CountTF
    plot(linspace(1,countvalue_pairs,countvalue_pairs),differ_mes_vs_sim(i,:));
end
grid on;
hold off;


%% Statistcal-Tests
%Paired T-Test
for k=1:CountTF
    for i=1:((size(CA1,2)-1)/2)-1
            x(i,1)=CA1{k,i+2};
            y(i,1)=CA1{k,i+7};
    end
    [h(k,1),p_t_test(k,1)] = ttest(x,y);
    R_temp=corrcoef(x,y);
    R(k,1) = R_temp(1,2);
    
    p_wilcoxon(k,1) = ranksum(x,y);

end


%Wilcoxon





