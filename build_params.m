function [ par ] = build_params( E_data, nu_data, epT_data, thickness, T_vec, T_ref )
%BUILD_PARAMS Interpolated given material properties at temperatures
%provided.
%   Inputs:     Type:           Description:
%   E_data      Cell Array      Array of moduli for materials
%   nu_data     Cell Array      Array of poisson ratios
%   epT_data    Cell Array      Array of thermal strains for materials
%   thickness   scalar          Thicknesses of layers
%   T_vec       Array           Temperatures for output
%   T_ref       scalar          Reference temperature
%
%   Output:
%   par         structure      parameters at given temperatures, for full
%                              multilayer structure

num_layers = length(E_data);

par.modulus = zeros(num_layers,length(T_vec));
par.nu = zeros(num_layers,length(T_vec));
strain_unscaled = zeros(num_layers,length(T_vec));
par.thickness = thickness(:); % ensure column vector

% interpolate with respect to temperature
for i = 1:num_layers
    par.modulus(i,:) = interp1(E_data{i}(:,1),E_data{i}(:,2),T_vec);
    par.nu(i,:) = interp1(nu_data{i}(:,1),nu_data{i}(:,2),T_vec);
    strain_unscaled(i,:) = interp1(epT_data{i}(:,1),epT_data{i}(:,2),T_vec);
end
% adjust thermal strain based on reference temperature
par.strain_th_in_plane = thermal_strain_scale(strain_unscaled, T_vec, T_ref);

