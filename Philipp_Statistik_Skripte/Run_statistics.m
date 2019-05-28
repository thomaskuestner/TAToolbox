%% Skript to run all the different statistical analysis functions for the PET-data-statastical-analysis
% Load and pre-process the data. Path of data has to be a certain format

cell = load('C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\05_Code\Philipp_Statistik_Skripte\MoCo_final_Cell');
[dicom,corrected,gated] = PreProcessing(cell);

% Fundamental central tendency tests
[p_value_ttest2,p_value_wilcox,p_value_friedman,var_comp_takeover] = CentralTendencyTests(dicom,corrected,gated);
%% Ploten von vorverarbeiteten Daten 
% Plotten der in CentralTendencyTests berechneten Daten (wenn vom user gewuenscht)

Save_Preprossed_DataAndPlots(dicom,corrected,gated,var_comp_takeover,p_value_ttest2,p_value_wilcox,p_value_friedman)
%% Auslesen der jeweiligen ROI- Groessen
% Auswahl per Dialog mit der Ordnerauswahl von allen ROIs von Interesse

[size_dicom_masks,size_corrected_masks,size_gated_masks,sum_all_sizes] = ReadOutROISize();

%% Überpruefung der Ausreisser in den jeweiligen Datentypen 
% -> To-Do: Das Skript so abändern, dass es gleich die "kritischen Patienten" ausgibt

[outliers_mean_dicom, outliers_quartiles_dicom] = FindOutliers(dicom);
[outliers_mean_corrected, outliers_quartiles_corrected] = FindOutliers(corrected);
[outliers_mean_gated, outliers_quartiles_gated] = FindOutliers(gated);

%% Kruskal Wallis Test um unabhängige Stichproben der gleichen Population entstammen
% Testet jedes TF. Gibt signifikant hohe P-Werte aus und der Grenz-P-Wert ist das 4. Funktionsargument!

[p_KW_test,significant_p_KW_test] = KruskalWallisTest(dicom,corrected,gated,0.75);

%% Berechnung der Skedastizitäten (Verteilung der Varianzen) der PET-Daten
% One can chose if and were the plots of these are being saved
% Different test-types for "Scedasticity": 'bartlett','levene_abs' and 'levene_quad' 
% Set the input-var to '1' to save the plots that compare all TFs with one another

[p_values_scedasticity,num_failed_null_hypotheses] = Scedasticity(dicom,corrected,gated,'Bartlett',0);
%[p_values_scedasticity,num_failed_null_hypotheses] = Scedasticity(dicom,corrected,gated,'Levene_quad',0);
%[p_values_scedasticity,num_failed_null_hypotheses] = Scedasticity(dicom,corrected,gated,'Levene_abs',0);

%% Auswahlfunktionen, um relevante TFs zu identifizieren
