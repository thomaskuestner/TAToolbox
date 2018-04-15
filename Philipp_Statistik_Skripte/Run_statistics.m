%% Skript um die verschiedenen statistischen Funktionen laufen zu lassen
% Einladen und Vorverarbeiten der Aufnahmen
cell = load('C:\Users\Philipp\Documents\02_University\Master (Medizintechnik)\Studienarbeit\05_Code\Philipp_Statistik_Skripte\MoCo_final_Cell');
[dicom,corrected,gated] = PreProcessing(cell);
% clearvars struct;

%% Ploten von vorverarbeiteten Daten mit jeweiligen T-Tests
Save_Preprossed_Data_With_TTesting(dicom,corrected,gated);
% %% Gepaarter TTest von 2 Sequenzen -> Jetzt obsolet. Skript existiert weiterhin
% [h_ttest_comp_01,p_ttest_comp_01] = T_Testing(dicom,corrected);
% [h_ttest_comp_02,p_ttest_comp_02]= T_Testing(dicom,gated);
% [h_ttest_comp_03,p_ttest_comp_03]= T_Testing(corrected,gated);

%% Auslesen der jeweiligen ROI- Groessen
% Auswahl per Dialog mit der Ordnerauswahl von allen ROIs von Interesse
[size_dicom_masks,size_corrected_masks,size_gated_masks] = ReadOutROISize();

%% Überpruefung der Ausreisser in den jeweiligen Datentypen 
% -> To-Do: Das Skript so abändern, dass es gleich die "kritischen Patienten" ausgibt
[outliers_mean_dicom, outliers_quartiles_dicom] = FindOutliers(dicom);
[outliers_mean_corrected, outliers_quartiles_corrected] = FindOutliers(corrected);
[outliers_mean_gated, outliers_quartiles_gated] = FindOutliers(gated);

%% Berechnung der Mittelwerte und Varianzen
% Ausgabe der Varianzen per default je nach den Spalten
% mean_dicom = mean(dicom); % -> Einkommentieren, wenn diese wirklich gebraucht werden sollten...
% mean_corrected = mean(corrected);
% mean_gated = mean(gated);
% variance_dicom = var(dicom);
% variance_corrected = var(corrected);
% variance_gated = var(gated);

%% Ueberpruefung von 3 gepaarten Stichproben auf die Gleichheit (zentrale Tendenz des Datensatzes)
p_friedman = FriedmansTest(dicom,corrected,gated);

%% Kruskal Wallis Test um unabhängige Stichproben der gleichen Population entstammen
% Testet jedes TF. Gibt signifikant hohe P-Werte aus und der Grenz-P-Wert ist das 4. Funktionsargument!
[p_KW_test,significant_p_KW_test] = KruskalWallisTest(dicom,corrected,gated,0.75);

%% Berechnung der Skedastizitäten (Verteilung der Varianzen) der PET-Daten
% Beachte die Speicherung der Plots! Alle Plots werden automatisch gespeichert
% Warning: Diese Funktion speichert Figures in Ordner! Diese müssen aber schon existieren!
% Verschiedene Testtypen für "Scedasticity": 'bartlett','levene_abs' und 'levene_quad' 
[p_values_scedasticity] = Scedasticity(dicom,corrected,gated,'bartlett',0); % letzte input-var auf '1' für Speichern der Vergl.-Plots aller TFs in je den 3 Aufnahmesequenzen

%% Auswahlfunktionen, um relevante TFs zu identifizieren
%
 