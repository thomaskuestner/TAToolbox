function [dicom_ROI_sizes,corr_ROI_sizes,gated_ROI_sizes] = ReadOutROISize()
files_to_extract = uigetfile_n_dir();
number_of_files_to_extract = length(files_to_extract);
name={};
counter = 1;
for p=1:number_of_files_to_extract
    name=files_to_extract{1,p};
    filepath_dicom = strcat(name,'\mask_dicom.mha');
    dicom_used = main_read_mask(filepath_dicom);
    pos_dicom_indices = find(dicom_used == 1);
    dicom_ROI_sizes(counter) = length(pos_dicom_indices); % = Matrix/Vektor mit ROI-Voxal-Anzahl
    filepath_corr = strcat(name,'\mask_corr.mha');
    corrected_used = main_read_mask(filepath_corr);
    pos_corr_indices = find(corrected_used == 1);
    corr_ROI_sizes(counter) = length(pos_corr_indices); % = Matrix/Vektor mit ROI-Voxal-Anzahl
    filepath_gated = strcat(name,'\mask_gated.mha');
    gated_used = main_read_mask(filepath_gated);
    pos_gated_indices = find(gated_used == 1);
    gated_ROI_sizes(counter) = length(pos_gated_indices); % = Matrix/Vektor mit ROI-Voxal-Anzahl
    counter = counter + 1;
end
end