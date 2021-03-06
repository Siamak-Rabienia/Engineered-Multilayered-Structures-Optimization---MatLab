function [boundary_properties, zb] = generate_boundary_properties(properties)
% [boundary_properties, zb] = generate_boundary_properties(properties);
% set up layer stacks for calculating stress at each boundary for each
% materiald

z = [0; cumsum(properties.thickness)];
n = size(properties.modulus,1);
zb = zeros(2*n,1);
for i = 1:size(properties.modulus,1)
    boundary_properties.modulus(2*(i-1)+1,:) = properties.modulus(i,:);
    boundary_properties.modulus(2*i,:) = properties.modulus(i,:);
    
    boundary_properties.nu(2*(i-1)+1,:) = properties.nu(i,:);
    boundary_properties.nu(2*i,:) = properties.nu(i,:);
    
    boundary_properties.strain_th_in_plane(2*(i-1)+1,:) = properties.strain_th_in_plane(i,:);
    boundary_properties.strain_th_in_plane(2*i,:) = properties.strain_th_in_plane(i,:);
    
    zb(2*(i-1)+1,:) = z(i,:);
    zb(2*(i),:) = z(i+1,:);
end