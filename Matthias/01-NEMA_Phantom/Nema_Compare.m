load('Measured_vs_Simulated_allDosis_Mask_TK.mat');
CA1=table2cell(MeasuredvsSimulatedallDosisMaskTK);
CountTF=size(CA1,1);
differ=0;

for i=1:((size(CA1,2)-1)/2)
    for k=1:CountTF
        differ(k,i)=1-(CA1{k,i+6}/CA1{k,i+1});
    end
end

for i=1:CountTF
    figure(i);
    hist(differ(i,:));
end
