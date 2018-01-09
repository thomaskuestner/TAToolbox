function [cv,t_test,corrcoef] = analyse_features(set1, set2,corr_NaN)
global handles 

% of type cell that there is no problem with displaying the data in the table
cv = cell(size(set1,1),2);
t_test.h=cell(size(set1,1),1); t_test.p=cell(size(set1,1),1);
corrcoef = cell(size(set1,1),1);

child = findall(findobj(handles.f,'Title','Analyse'),'Value',1,'-regexp','Tag','c_');
for i=1:numel(child)
    str = char(child(i).Tag);
    % check which analysis methods were chosen in GUI
    if strcmp(str,'c_varcoeff')
        cv = calc_varcoef(set1,set2);    
    end
    if strcmp(str,'c_ttest')
        if ~isequal(size(set1),size(set2))
            warning('Fuer den T-test muessen die Dimensionen von Set1 und Set2 uebereinstimmen (Aufnahmen, ROIs, Feature).')
            continue;
        end
        if size(set1,2)*size(set1,3)<10
            msg = 'Fuer den t-Test stehen pro Stichprobe <10 Werte pro Feature zur Verfuegung. Der Test ist nicht aussagekraeftig.';
            warning(msg);
            continue;
        end
        t_test = calc_ttest(set1,set2);
    end
    if strcmp(str,'c_corr')
        if ~isequal(size(set1),size(set2))
            msg = 'Fuer den Korrelationskoeffizienten muessen die Dimensionen von Set1 und Set2 uebereinstimmen (Aufnahmen, ROIs, Feature).';
            warning(msg);
            continue;
        end
        corrcoef = calc_corrcoef(set1,set2,corr_NaN);
    end

end
end


function cv = calc_varcoef(set1,set2)
%  www.statisticshowto.com/how-to-find-a-coefficient-of-variation/
%  CV = std/mean
% "The standard deviation is x% of the mean."
% Useful when you want to compare results from 2 different tests that have
% different measures/values
% only use on positive data on ratio scale, not interval scale

for f = 1:size(set1,1)
    temp = set1(f,:,:);
    cv{f,1} = std(horzcat(temp(:)),'omitnan')./mean(horzcat(temp(:)),'omitnan');
end
for f = 1:size(set2,1)
    temp = set2(f,:,:);
    cv{f,2} = std(horzcat(temp(:)),'omitnan')./mean(horzcat(temp(:)),'omitnan');
end
end

function t_test = calc_ttest(set1,set2)
% paired-sample t-test
% theory: s. mathworks ttest
% h: test decision for null hypothesis; h=1: hypothesis rejected
% p: p-value; p<0.05 = significant (5% significance level)
t_test.h = []; t_test.p = [];

[h,p] = ttest2(reshape(permute(set1,[2 3 1]),[],1,size(set1,1)),reshape(permute(set2,[2 3 1]),[],1,size(set2,1)));
% x1=permute(set1,[2 3 1])
% x2=permute(set2,[2 3 1])
% xx1 = reshape(x1,[],1,size(set1,1))
% xx2 = reshape(x2,[],1,size(set2,1))
% [h,p] = ttest2(xx1,xx2);



t_test.h = num2cell(squeeze(h));
t_test.p = num2cell(squeeze(p));

% ttest: when calculation of the difference of each pair makes sense
    % Muskeln vergleichen mit gleichen Features
    % Tooolboxen vergleichen
    % t1 space Aufnahmen vers. Probanden vergleichen
        
% ttest2: two-sample t-test/ unpaired t-test
% tests if both populations have the same mean (=hypothesis)
% ttest2() % when measured at two time points
end


function RHO = calc_corrcoef(set1,set2,corr_NaN)
% Es wird für jedes Feature ein Korrelationskoeffizient berechnet. 
% Dazu werden von Set1 und von Set2 alle ausgewählten Muskeln der
% ausgewählten Aufnahmen verwendet.
RHO =[];

if strcmp(corr_NaN,'complete')
    for i=1:size(set1,1)
        [RHO{i}, PVAL{i}] = corr(set1(i,:)',set2(i,:)','rows','complete'); % uses only rows with no missing value
    end
elseif strcmp(corr_NaN,'sort')
    set1_cut = set1(:,all(~isnan(set1)));
    set2_cut = set2(:,all(~isnan(set2)));
    for i=1:size(set1,1)
        [RHO{i}, PVAL{i}] = corr(set1_cut(i,:)',set2_cut(i,:)','rows','all'); %  uses all rows regardless of missing values (NaNs)
    end
end
RHO = RHO';
% PVAL = PVAL';

% corr: pairwise correlation between the columns
% corrcoef: converts matrices first to column vectors and then just computes the correlation coefficient between those 2 vectors
% corr2: single correlation coefficient
% -> liefern alle die gleichen Ergebnisse!
end