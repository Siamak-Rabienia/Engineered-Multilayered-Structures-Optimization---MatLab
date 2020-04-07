function eps = strain_top_bottom(properties)
% function [eps] = strain_top_bottom(modulus, poisson, thermal_strain, thickness)
% This function will calculate the strain at the top and bottom of a
% multilayered axisymmetric structure.  The general formulation was derived
% from the following sources:
% 1) Hall
% 2) Zhang
%
% Inputs            Type        Description
% N                 scalar      # of layers
% M                 scalar      # of temperatures
% modulus           NxM         [MPa] - Elastic Modulus = fnc(temp)
% poisson           NxM         [-] - Poisson's ratio = fnc(temp)
% thermal_strain    NxM         [-] - thermal strain = fnc(temp)
% thickness         NxM         [m] - thickness of layer (fnc(temp)?)
%
% Output        Type        Description
% eps           2xM         [strain at bottom, strain at top of structure]'

% Expand input
modulus = properties.modulus;
nu = properties.nu;
strain_th_in_plane = properties.strain_th_in_plane;
thickness = properties.thickness;

% Get number of layers
N = size(modulus,1);

% Check to make sure it all matches
chlen = [size(modulus,1), size(nu,1), size(strain_th_in_plane,1), ...
    size(thickness,1)];
if any(chlen ~= N)
    fprintf('Error: dimension mismatch...');
    eps = [Nan, Nan];
end

% generate z vector based on cumulative thickness
z = zeros(N+1,1);
z(2:N+1) = cumsum(thickness);
h = z(end); % total thickness

% % Implement Zhang's method for gradient layers
% gflag = find(grad_flag == 1);
% ng = 10; % number of gradient layers - tune/input
% if ~isempty(gflag)
%     [z, modulus, nu, thermal_strain, N] = apply_gradient_blending(gflag, z, modulus, nu, thermal_strain, N);    
% end

% define biaxial modulus
biaxial_modulus = modulus./(1-nu);

% define coefficients
A = biaxial_modulus'*[z(2:N+1), z(2:N+1).^2, z(2:N+1).^3];
B = biaxial_modulus'*[z(1:N), z(1:N).^2, z(1:N).^3];
bm_ts = biaxial_modulus.*strain_th_in_plane;
C = bm_ts'*[z(2:N+1), z(2:N+1).^2];
D = bm_ts'*[z(1:N), z(1:N).^2];

% define denominator
F = 4.*(A(:,3) - B(:,3)).*(A(:,1)-B(:,1)) - 3.*(A(:,2) - B(:,2)).^2;

% define bottom strain
eps(:,1) = (4.*(C(:,1) - D(:,1)).*(A(:,3)-B(:,3)) - 3.*(A(:,2)-B(:,2)).*(C(:,2)-D(:,2)))./F;

% define top strain
eps(:,2) = ((C(:,2)-D(:,2)).*(6.*h.*(A(:,1)-B(:,1)) - 3.*(A(:,2)-B(:,2)))...
    + (C(:,1)-D(:,1)).*(4.*(A(:,3)-B(:,3)) - 6.*h.*(A(:,2)-B(:,2))))./F;

% Transpose eps array such that columns represent different temperatures
eps = eps';

return