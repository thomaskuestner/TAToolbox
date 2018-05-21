clear all;clc;
for q=1:42
    filename=strcat('ROI1_lme_TF_',num2str(q),'.mat');
    load(filename)
    tab_of_pValues_all_TFs(q,1)=lme_TFX.Coefficients(2,6).pValue;
    if tab_of_pValues_all_TFs(q,1)<0.05
        significant_tab_of_pValues_all_TFs(q,1)=tab_of_pValues_all_TFs(q,1);
    end
end