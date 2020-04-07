% % Timing Test
% 
% Compare running time of non-vectorized and vectorized computations of two
% different strain functions.
%
% Result: vectorized is faster. We'll use that from now on.

modulus = [
    15 % Ceramic
    0.1  % Adhesive
    10  % Aluminum
    1  % Encaps
    ];

nu = [
    0.23 % Ceramic
    0.3  % Adhesive
    0.32 % Aluminum
    0.3  % Encaps
    ];

delta_t = -180; % K
strain_th_in_plane = [
    6*delta_t % Ceramic
    80*delta_t  % Adhesive
    23*delta_t % Aluminum
    40*delta_t % Encaps
    ];

thickness = [
    0.021  % Ceramic
    0.006  % Adhesive
    0.03   % Aluminum
    0.001  % Encaps
    ];

% define data structure
par.modulus = modulus;
par.nu = nu;
par.strain_th_in_plane = strain_th_in_plane;
par.thickness = thickness;

% Paul's function

tic

for i = 1:1000
% test top/bottom strain function
    [eps, z] = strain_top_bottom(par);
end

toc

% Peter's function

tic

for i = 1:1000
% test top/bottom strain function
   strain(modulus', strain_th_in_plane', ...
        nu', thickness');
end

toc

% Paul wins :(