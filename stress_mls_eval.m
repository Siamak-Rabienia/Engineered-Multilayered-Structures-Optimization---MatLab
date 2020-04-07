function [stress] = stress_mls_eval(eps, z, par)
% function [sigma] = stress(eps, modulus, nu, thermal_strain, thickness);
%
% Calculates the stress in the ith layer.
%
% Inputs:
%
% Outputs:

% Extract par structure
modulus = par.modulus;
nu = par.nu;
strain_th_in_plane = par.strain_th_in_plane;

% biaxial modulus
biaxial_modulus = modulus./(1-nu);

% Define structure thickness
h = z(end);

% Calculate strain
% strain = eps(1) + z./h*(eps(2)-eps(1)); 
strain = bsxfun(@plus, eps(:,1), (z./h*(eps(:,2)-eps(:,1))')')';
% calculate stress through material
stress = biaxial_modulus.*(strain - strain_th_in_plane);