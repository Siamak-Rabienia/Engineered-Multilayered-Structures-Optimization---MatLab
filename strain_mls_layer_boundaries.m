function [strain] = strain_mls_layer_boundaries(z, properties, eps)
% function [sigma] = stress(eps, modulus, nu, thermal_strain, thickness);
%
% Calculates the stress in the ith layer.
%
% Inputs:
%
% Outputs:

% Expand input
modulus = properties.modulus;
nu = properties.nu;
strain_th_in_plane = properties.strain_th_in_plane;
% thickness = properties.thickness;

% Get number of layers
N = size(modulus,1);

% Check to make sure it all matches
chlen = [size(modulus,1), size(nu,1), size(strain_th_in_plane,1)];
if any(chlen ~= N)
    fprintf('Error: dimension mismatch...');
    eps = [Nan, Nan];
end

% generate z vector based on cumulative thickness
% z = [0;cumsum(thickness)];%%zeros(N+1,1);
% z(2:N+1) = cumsum(thickness);
h = z(end);

if nargin<2 || isempty(eps)
    eps = strain_top_bottom(properties);
end
% Transpose eps array for vector operations
eps = eps'; 
% rows now reflect temperatures, but it is not outputted back to the main script.

% Calculate strain
% strain = eps(:,1) + z./h*(eps(:,2)-eps(:,1))'; 
strain = bsxfun(@plus, eps(:,1), (z./h*(eps(:,2)-eps(:,1))')')';
return