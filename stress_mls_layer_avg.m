function [stress] = stress_mls_layer_avg(properties, eps)
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
h = z(end);

if nargin<2 || isempty(eps)
    eps = strain_top_bottom(properties);
end
% Transpose eps array for vector operations
eps = eps'; 
% rows now reflect temperatures, but it is not outputted back to the main script.

% biaxial modulus
biaxial_modulus = modulus./(1-nu);

% Calculate strain
% strain = eps(:,1) + z./h*(eps(:,2)-eps(:,1))'; 
strain = bsxfun(@plus, eps(:,1), (z./h*(eps(:,2)-eps(:,1))')')';
% calculate stress at each layer interface - take the average of strain for
% each layer
avg_strain = (strain(2:end,:) + strain(1:end-1,:))./2;
stress = biaxial_modulus.*(avg_strain - strain_th_in_plane);