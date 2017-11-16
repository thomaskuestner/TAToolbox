% = = = Maske ganze ROI = = =
dummy_MaskWholeROI = ones(80,80,80);
save('dummy_MaskWholeROI.mat','dummy_MaskWholeROI')

% === For horizontal, vertical, diagonal stripes: ===
Nx = 80; % image dimension in x direction
Ny = Nx; % image dimension in y direction
Nz = Nx; % image dimension in z direction

period = 20; % 20

% = = = Streifen lÃ¤ngs = = =
fx = 1/period;    % period in x direction
fy = 0;      % period in y direction

% = = = Streifen quer = = =
fx = 0;
fy = 1/period;

% = = = Streifen diagonal = = =
fx = 1/period;
fy = fx;

[xi, yi] = ndgrid(1 : Nx, 1 : Ny);
dummy = sin(2 * pi * (fx * xi  + fy * yi)) > 0; % for binary mask; '>0' generates a logical
% dummy = (sin(2 * pi * (fx * xi  + fy * yi)) + 1) / 2; % for gradual [0,1] mask
% imagesc(dummy); % only if you want to see it
% imshow(dummy)
dummy = repmat(dummy,1,1,Nz);

save('dummy_plain_long.mat','dummy')
save('dummy_plain_lat.mat','dummy')
save('dummy_plain_diag.mat','dummy')

period_in_pixel = 1 / sqrt(fx^2 + fy^2);


% === For checkerboard patterns: ===
f = 1 / period; % 1 / period
% Nx = 40;
% Ny = Nx;
% Nz = Nx;
[xi, yi] = ndgrid(1 : Nx, 1 : Ny);
dummy_caro = sin(2 * pi * f * xi) .* sin(2 * pi * f * yi) > 0; % for binary mask
% dummy_caro = (sin(2 * pi * f * xi) .* sin(2 * pi * f * yi) + 1) / 2; % for more gradual mask
% imagesc(dummy_caro);
% imshow(dummy_caro)
dummy_caro = repmat(dummy_caro,1,1,period/2);
dummy_caro(:,:,period/2+1:period) = ~dummy_caro;
dummy_caro = repmat(dummy_caro,1,1,Nx/period);

save('dummy_caro.mat','dummy_caro')


number_squares_x = 2 * f * Nx;
number_squares_y = 2 * f * Ny;





% %% Did Jana implement the following Code by herself (from here on)?
% % = = = Schachbrett = = =
% n = period/2;
% quader0 = zeros(n,n,n);
% quader1 = ones(n,n,n);
% quader_basic = zeros(2*n,2*n,2*n);
% quader_basic(:,:,1:2^n) = [quader0, quader1; quader1, quader0];
% quader_basic(:,:,2^n+1:2*2^n) = [quader1, quader0; quader0, quader1];
% 
% dummy_caro = repmat(quader_basic,128/(2^n*2),384/(2^n*2),384/(2^n*2));
% % dummy_caro = permute(dummy_caro,[1 3 2]);
% % figure
% % imshow(dummy_caro(:,:,3))
% save('dummy_caro.mat','dummy_caro')
% 
% % = = = Streifen lÃ¤ngs = = =
% n = 2;
% plain0 = zeros(2^n,384,384);
% plain1 = ones(2^n,384,384);
% plain_basic = zeros(2*2^n,384,384);
% plain_basic(1:2^n,:,:) = plain0;
% plain_basic(2^n+1:2*2^n,:,:) = plain1;
% 
% dummy_plain_long = repmat(plain_basic,128/(2^n*2),1,1);
% % dummy_plain_long = permute(dummy_plain_long,[3 2 1]);
% imshow(dummy_plain_long(:,:,1))
% 
% save('dummy_plain_long.mat','dummy_plain_long')
% 
% 
% 
% % = = = Streifen quer = = =
% n = 2;
% plain_lat0 = zeros(128,2^n,384);
% plain_lat1 = ones(128,2^n,384);
% plain_lat_basic = zeros(128,2*2^n,384);
% plain_lat_basic(:,1:2^n,:) = plain_lat0;
% plain_lat_basic(:,2^n+1:2*2^n,:) = plain_lat1;
% 
% dummy_plain_lat = repmat(plain_lat_basic,1,384/(2^n*2),1);
% % dummy_plain_lat = permute(dummy_plain_lat,[3 2 1]);
% imshow(dummy_plain_lat(:,:,1))
% 
% save('dummy_plain_lat.mat','dummy_plain_lat')
