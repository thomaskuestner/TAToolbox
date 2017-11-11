%%
% "Amerikaner" This Dummie is split in half between the Grey Values 1 and 0 
% the geometric arrangement and algebraic characteristics are designed to
% create a minimal entropy over the ROI (hyp.: entropy = 0)
% Amerikaner is created as a default confirmation of 'entropy' in respecitve toolboxes 
dummy = zeros(40,40);
M = 40;     

for i = 1:M         % creation of the 2d- "Amerikaner"- structure
    for k=1:20
        dummy(k,i) = 1;
    end
end

% imshow(dummy);    % if you want to see the image before 3d- stacking 
                    % (all layers in z- direction are exact copies of this image)
dummy = repmat(dummy,1,1,M);
own_dummy = dummy;
save('amerikaner.mat','own_dummy');

% %%
% "Schachbrett" Copie of Jana L.'s realisation of the checkersboard for freely selectable
% periods
% This is the opposite sample/ dummy - probe if one will - for maximal entropy (entropie = 1)
n = 40;
period = 40; % Note that certain values don't work to create symmetrical compartments of the checkersboard
f = 1 / period;
Nx = n;
Ny = Nx;
Nz = Nx;
[xi, yi] = ndgrid(1 : Nx, 1 : Ny);
own_dummy_caro = sin(2 * pi * f * xi) .* sin(2 * pi * f * yi) > 0;

imshow(own_dummy_caro);    % if you want to see the image before 3d- stacking

own_dummy_caro = repmat(own_dummy_caro,1,1,period/2);
own_dummy_caro(:,:,period/2+1:period) = ~own_dummy_caro;
own_dummy_caro = repmat(own_dummy_caro,1,1,Nx/period);

save('dummy_checkersboard.mat','own_dummy_caro');
%%
