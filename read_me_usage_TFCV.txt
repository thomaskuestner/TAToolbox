1. Start main_runGUI()
2. Select already existing data (Button "Schon mit TFCV berechnete Datensätze") or new data to calculate (DICOM Rohdaten und zugehörige Masken) - This is usually the case
3. Leftmost of the GUI - Right of the Tab "bekannte Studien" click Button "+"
4. Click Button "Wähle die gewünschten Datensaetze aus"
5. Choose your datasets
6. In the middle of the GUI - Right of the Tab "bekannte ROIs" click "ROI laden"
7. Click Button "Lade Maske(n)" ein
8. Choose your ROI/mask file
9. Rightmost of the GUI - Choose !nothing! from PORTS! Choose all TFs from radiomics with the button "alle von Toolbox"!
10. Click Button "Berechnen"
11. Here you have to consider which dataset should be calculated with which mask? One way is just to load datasets and rois which are all compatible then you cross "Alle verfuegbaren ROIS fuer alle Daten auswaehlen"
12. Click Bestaetigen
13. Wait until "Fertig gerechnet" appears in the command window
14. Click Button "Speichere diese Studie"
15. Click Button "Yes"
16. Give a name to your calculated dataset and click ok
17. Click "yes" give a name to the .mat file in which the dataset is stored
(18. Sometimes the TFCV is buggy and you have to do the step 16. and 17. more than once)
19. you should do the statistics with your own scripts, therefore it is recommendable to extract the relevant data from the struct (thesis lindner) and save it in a own small file
