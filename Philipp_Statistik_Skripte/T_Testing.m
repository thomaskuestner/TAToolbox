function [h_ttest,p_ttest] = T_Testing(input_01,input_02)
% T-Test for the two chosen Datasets
load('feature_Names');
counter = 1;
h_ttest = zeros(1,42);
p_ttest = zeros(1,42);
for i = 1:42
    [h_ttest(counter),p_ttest(counter)] = ttest2(input_01(:,i),input_02(:,i));
    counter = counter + 1;
end
% Ausgabe der abgelehnten TFs
disp('Fuer folgende Features wurde die Nullhypothese des TTests abgelehnt: ')
for j = 1:length(h_ttest)
    num = 1;
    if h_ttest(j) ~= 0
        rejected_NHyp_num(num) = j;
        disp(feature_Names{j,1});
        disp(j);
        num = num+ 1;
    end
end
disp('--------------------------------------------------------------------');
end