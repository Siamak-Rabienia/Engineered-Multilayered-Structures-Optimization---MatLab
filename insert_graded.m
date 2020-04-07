function [ newproperties ] = insert_graded( E_bounds, nu_bounds, epT_bounds, ...
    properties, graded_thickness, n, exponent, ins_loc, T_vec, T_ref)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

graded_settings.modulus(1,:) = interp1(E_bounds{1}(:,1),E_bounds{1}(:,2),T_vec);
graded_settings.modulus(2,:) = interp1(E_bounds{2}(:,1),E_bounds{2}(:,2),T_vec);
graded_settings.nu(1,:) = interp1(nu_bounds{1}(:,1),nu_bounds{1}(:,2),T_vec);
graded_settings.nu(2,:) = interp1(nu_bounds{2}(:,1),nu_bounds{2}(:,2),T_vec);
graded_settings.strain_th_in_plane(1,:) = interp1(epT_bounds{1}(:,1),epT_bounds{1}(:,2),T_vec);
graded_settings.strain_th_in_plane(2,:) = interp1(epT_bounds{2}(:,1),epT_bounds{2}(:,2),T_vec);

graded_settings.thickness = graded_thickness;

% Calculate grated layers
[graded_layers] = material_interp_T_dep(n, exponent, graded_settings);

% Insert grated layers into initial setup
[newproperties] = merge_layers(n, ins_loc, properties, graded_layers);

newproperties.strain_th_in_plane = thermal_strain_scale(newproperties.strain_th_in_plane,...
    T_vec, T_ref);

end

