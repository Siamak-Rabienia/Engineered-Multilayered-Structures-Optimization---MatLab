function [ epT_scaled ] = thermal_strain_scale(strain_mat, T_vec, T_ref )
%THERMAL_STRAIN_SCALE Scales in-plane thermal strain so that it is zero at
%the reference temperature.
%   Scales according to the formula
%
%       eps_scaled(T) = ( eps_0(T) - eps_0(T_ref) ) / ( 1 + eps_0(T_ref) )
%
%   Inputs:
%   strain_mat (array)  : Columns represent thermal strain in each layer at
%                           a given temperature
%   T_vec (Nx1 array)   : Temperatures correspond to columns of strain_mat
%   T_ref (scalar)      : Reference temperature for the problem

% Find location of reference temperature
ind = abs(T_vec-T_ref) < 1e-10; 
if sum(ind) ~= 1
    disp('Error! Probably, reference temperature not in temperature vector.')
    return
end

% Make matrix where each column is thermal strain at T_ref
epT_ref = strain_mat(:,ind) * ones(size(T_vec));
% Perform matrix algebra to scale
epT_scaled = (strain_mat - epT_ref) ./ (1+epT_ref);

end

