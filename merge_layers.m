function [newproperties] = merge_layers(ng, insert_layer, properties, graded_layers)
% function [par] = merge_layers(par, parout)
% Merge graded layers into overall layer structure

% Extract par structure
modulus = properties.modulus;
nu = properties.nu;
strain_th_in_plane = properties.strain_th_in_plane;
thickness = properties.thickness;

% Merge layers
nt = size(modulus,1);
modulus(nt+1:nt+ng,:) = graded_layers.modulus;
tmp = modulus;
tmp(nt-insert_layer+1:nt-insert_layer+ng,:) = graded_layers.modulus;
tmp(nt-insert_layer+1+ng:end,:) = modulus(nt-insert_layer+1:nt,:);
modulus = tmp;

nu(nt+1:nt+ng,:) = graded_layers.nu;
tmp = nu;
tmp(nt-insert_layer+1:nt-insert_layer+ng,:) = graded_layers.nu;
tmp(nt-insert_layer+1+ng:end,:) = nu(nt-insert_layer+1:nt,:);
nu = tmp;

strain_th_in_plane(nt+1:nt+ng,:) = graded_layers.strain_th_in_plane;
tmp = strain_th_in_plane;
tmp(nt-insert_layer+1:nt-insert_layer+ng,:) = graded_layers.strain_th_in_plane;
tmp(nt-insert_layer+1+ng:end,:) = strain_th_in_plane(nt-insert_layer+1:nt,:);
strain_th_in_plane = tmp;

thickness(nt+1:nt+ng,:) = graded_layers.thickness;
tmp = thickness;
tmp(nt-insert_layer+1:nt-insert_layer+ng,:) = graded_layers.thickness;
tmp(nt-insert_layer+1+ng:end,:) = thickness(nt-insert_layer+1:nt,:);
thickness = tmp;

% Package output
% define data structure
newproperties.modulus = modulus;
newproperties.nu = nu;
newproperties.strain_th_in_plane = strain_th_in_plane;
newproperties.thickness = thickness;