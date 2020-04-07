function [ res ] = hw1_c( lays )
%HW1_C Function to generate different material analytics plots 
% for different layer numbers. This function is mostly based on the 
% solution to homework problem A. J.B 7/22/16
% 
% INPUT: 
% lays := Number of layers (Meant to be even).
% OUTPUT:
% res := Flag for succes/failure. 


%% Code to load functions and materials.
% [delim] = '/'; % OS_delimiter
% % Search for folder header
% flag = 'IMSM_2016_Sandia';
% srch = pwd;
% temp = strfind(srch,flag);
% main_dir = srch(1:temp+length(flag));
% % load material data
% material_data = strcat(main_dir,'materials',delim,'multilayered_materials_data.mat');
% load(material_data);
% % define path to analysis functions
% functions = strcat(main_dir,delim,'code',delim,'functions');
% addpath(functions);

%%
load('../../materials/multilayered_materials_data');

% -------------------------------------------------------------------------
% USER INTERFACE
% -------------------------------------------------------------------------
% Input Settings
% Specifics for the problem.
res = 0;
T_vec = linspace(298,800,100);
T_ref = 600;
T_vec = unique([T_vec T_ref]);
L = 300*1e-3; % [m]

% Define non-graded layers as pairs.
t1 = 1; t2 = 0.5;
thickness = 1e-3.*repmat( [ t1; t2  ], lays, 1 ); %zeros(40,1);

% Define data structures.
E_data = {};
nu_data = {};
epT_data = {};

for i = 1: 2*lays
    if mod(i,2) ~= 0
        E_data{i} = E_Alumina; 
        nu_data{i} = nu_Alumina_Lower; 
        epT_data{i} = epT_Alumina; 
    else
        E_data{i} = E_Aluminum;
        nu_data{i} = nu_Aluminum;
        epT_data{i} = epT_Aluminum;
    end
end

% Scale axes for plotting
scale_stress = 1e-6; % convert Pa to MPa
scale_zloc = 1e3; % convert mm - m
% -------------------------------------------------------------------------
% USER - DO NOT EDIT BEYOND THIS POINT
% -------------------------------------------------------------------------

% Build properties structure
properties = build_params(E_data, nu_data, epT_data, thickness, T_vec, T_ref);

% evaluate top/bottom strain function
[eps] = strain_top_bottom(properties);
% display
fprintf('Strain of bottom/top\n');
fprintf('\tepsilon_bottom = %4.4e\n',eps(:,1));
fprintf('\tepsilon_top = %4.4e\n',eps(:,2));

% evaluate stress
[stress] = stress_mls_layer_avg(properties, eps);
z = [0; cumsum(properties.thickness)];
%figure
%plot(scale_zloc*(z(2:end)+z(1:end-1))./2, scale_stress*stress, 'o')
%ylabel('\sigma [MPa]');
%xlabel('z-location [mm]');

% evaluate stress at boundaries
z = [0; cumsum(properties.thickness)];
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

% calculate top/bottom stress for each layer
[stress_boundaries] = stress_mls_layer_boundaries(zb, boundary_properties, eps);
 
% % Calculate top/bottom strain for each layer
[strain_boundaries] = strain_mls_layer_boundaries(zb, boundary_properties, eps);
% 
% % Calculate radius of curvature and deflection
 [rho, delta] = rad_and_def(L, properties);
% 
% % Stress analysis
 [stress_mag_layer] = stress_magnitude_layer(stress_boundaries);
 
% % Strain analysis
 [strain_mag_layer] = strain_magnitude_layer(strain_boundaries);

 
%% Choice of different plots.
% plot(T_vec, delta, '-')
% % plot(scale_zloc*(z(2:end)+z(1:end-1))./2, scale_stress*stress, 'o')
% %hold off
% title('deflection');
% xlabel('Temp.');

% plot(scale_stress*stress_mag_layer(:,1))
% title('Stress Magnitude-First Temp.');
% ylabel('\sigma_{mag} [MPa]');
% xlabel('layer i');
% 

plot(scale_zloc*zb, scale_stress*stress_boundaries(:,1), '-')
% plot(scale_zloc*(z(2:end)+z(1:end-1))./2, scale_stress*stress, 'o')
title('Boundary Stress-First Temp.');
xlabel('z-location [mm]');
ylabel('\sigma [MPa]');
input('Hit <Enter>');


end

