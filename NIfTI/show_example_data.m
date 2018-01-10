%Show Exampledata
info_FDG_Mask = dicominfo('Mask_dicom.dcm');    %Drei Aufnahmen, 3 Masken warum mehr?
info_Mask100 = load_nii('Maske 100.nii');       %16 Dosen, 1 Maske wo sind die anderen 15 oder gibt es nur eine?

%handles.tab_SpezData

gustav=['a';'b';'c';'d'];

%     bekStud_length=1; %Feld Matlab initialisiert?
%     while bekStud_length<=size((bekannteStudien),2) && duplicate==0
%         bekStud_length = bekStud_length+1;
%         if bekannteStudien(bekStud_length).directories ==
%     end