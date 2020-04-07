function [ graded_layers ] = material_interp_T_dep( n, exponent, graded_properties )
%MATERIAL_INTERP creates linear interpolation of layer properties
%   Forms N layers that interpolate between material properties given.

% Extract parameters
modulus = graded_properties.modulus;
nu = graded_properties.nu;
strain_th_in_plane = graded_properties.strain_th_in_plane;
thickness = graded_properties.thickness;

% Fix this part
chlen = [size(modulus,1), size(nu,1), size(strain_th_in_plane,1)];
if any(chlen ~= 2)
    fprintf('Error: dimension mismatch...');
    return;
end

poly_interp = linspace(0,1,n+2).^exponent;

% Return linear interpolation of stuff
% moduli = (modulus(:,2)-modulus(:,1)) .* poly_interp + modulus(:,1);
tmp = bsxfun(@times, (modulus(2,:)-modulus(1,:))', poly_interp);
moduli = bsxfun(@plus, tmp, modulus(1,:)')';

tmp = bsxfun(@times, (strain_th_in_plane(2,:)-strain_th_in_plane(1,:))', poly_interp);
strain_th_in_planes = bsxfun(@plus, tmp, strain_th_in_plane(1,:)')';

tmp = bsxfun(@times, (nu(2,:)-nu(1,:))', poly_interp);
nus = bsxfun(@plus, tmp, nu(1,:)')';

% Extract interior elements
graded_layers.modulus = moduli(2:end-1,:);
graded_layers.strain_th_in_plane = strain_th_in_planes(2:end-1,:);
graded_layers.nu = nus(2:end-1,:);
graded_layers.thickness= thickness / n * ones(n,1);

end

