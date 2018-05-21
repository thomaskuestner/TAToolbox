*********!!!!*********
Please be aware of the fact that this script was just programmed for different personal statistic aims 
and the intending was never a versatile, useable and robust usage.
My advice is to do your own statistical script and just copy some code lines from this files.
*********!!!!*********

With this file you get outlier of TF-Value or ROI-Size of the Patients3MBq-study

You need the prepared .mat files:
'summarized_data_of_all_Patients_ROI1.mat'
'summarized_data_of_all_Patients_ROI2.mat' (the variable all_Patients_ROI_sizes in ROI2 is missing you have to add it manually or change the reading-process)

In the first lines you can choose the attribute you want to analyze:
ROI-Size or
TF-Value

In the middle of the script there is a commented part which calculate the datasets which have the most outliers in tf-values.
It is not stable, but the idear is pretty easy. The Definition of the outlier can be found in the thesis, the rest is just a sum calculation which you will get be better done. 

The both other skripts (outlier_end_calculation.m and outlier_startdosis_vs_tf_outlier.m) are just existing for a nice output, they are unimportant for you.