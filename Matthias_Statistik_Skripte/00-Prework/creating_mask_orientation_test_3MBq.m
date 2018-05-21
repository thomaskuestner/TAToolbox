temp=0;
for k=1:50
    str1='Dose_3-OP-00';
    if k<10
        str2=strcat('0',int2str(k));
    else
        str2=int2str(k);
    end   
    pathfile=strcat(str1,str2,'.ima');

    klara_data=dicomread(pathfile);
    klara_info=dicominfo(pathfile);
    
    bigness=100-temp;
    temp=temp+2;
    
    for i=1:bigness
        for j=1:bigness
            klara_data(i,j)=20000;
        end
    end

    dicomwrite(klara_data,pathfile, klara_info, 'CreateMode', 'copy');
    
end

