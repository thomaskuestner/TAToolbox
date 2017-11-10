%This file is for creating dummies to understand the texturefeatures

%%
% Amerikaner
dummy = zeros(40,40,40);
%dummy(1-20,40,40) = ones
for p = 1:M
    for i = 1:M
        for k=1:20
            dummy(k,i,p) = 0.5;
        end
    end
end
save('americaner.mat','own_dummy');

%%

%%



