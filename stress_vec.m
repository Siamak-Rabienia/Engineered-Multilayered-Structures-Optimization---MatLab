function [stress] = stress_vec(zz, par, eps)
% Documentation goes here.

% Expand input
modulus = par.modulus;
nu = par.nu;
strain_th_in_plane = par.strain_th_in_plane;
thickness = par.thickness;

% Get number of layers and temps
[N, T_len] = size(modulus);

% Check to make sure it all matches
chlen = [size(modulus,1), size(nu,1), size(strain_th_in_plane,1), ...
    size(thickness,1)];
if any(chlen ~= N)
    fprintf('Error: dimension mismatch...');
    eps = [Nan, Nan];
end

% get z vector
z = [0; cumsum(thickness)];
h = z(end);

% Calculate strain if we don't already have it
if nargin<3 || isempty(eps)
    eps = strain_top_bottom(par);
end

% biaxial modulus
biaxial_modulus = modulus./(1-nu);zn = length(zz);

% Make vector of z values
zmat = ones(T_len,1)*zz;
zmat = zmat';

% Make stepwise function of thermal stress and biaxial modulus
strain_step = zeros(size(zmat));
modulus_step = zeros(size(zmat));

for i = 1:N
    region = z(i)<zmat & zmat <= z(i+1);
    region_len = sum(region(:,1));
    strain_step(region) = ones(region_len,1)*strain_th_in_plane(i,:);
    modulus_step(region) = ones(region_len,1)*biaxial_modulus(i,:);
end

% Calculate strain 
eps_b_mat = ones(zn,1)*eps(1,:);
eps_t_mat = ones(zn,1)*eps(2,:);
strain = eps_b_mat + zmat/h .*(eps_t_mat-eps_b_mat) ;
% calculate stress through material
stress = modulus_step.*(strain - strain_step);