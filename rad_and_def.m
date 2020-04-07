function [rho, delta] = rad_and_def(L, properties)

% rad_and_def calculates the radius of curvature and deflection from
% material properties.
% 
% Inputs:
% 
% L (1 x 1)                   : disk radius
% modulus (1 x N array)       : elastic moduli of layers
% therm_strain (1 x N array)  : thermal strain (alpha * Delta T) of layers
% poisson (1 x N array)       : poisson ratio of layers
% thickness (1 x N array)     : thickness of layers
% 
% Outputs:
% 
% rho (1 x TN)                 : radius of curvature
% delta (1 x TN)               : deflection
% TN is the number of temperature points

% Total material thickness
h = sum(properties.thickness);

% Find top and bottom strain
% [e_t,e_b] = strain(modulus, therm_strain, poisson, thickness);
[eps] = strain_top_bottom(properties);
% eps = [        T1     T2 ...
%   eps_bottom   ...
%   eps_top      ...

% Radius of curvature
% rho = h / (e_t - e_b);
rho = h ./ (eps(2,:) - eps(1,:));

% Deflection
% 'sign' and 'abs' are due to some sign considerations on radius of
% curvature. If it bends up, rho is (+), and if it bends down, rho is (-).
% Deflection needs to account for this, i.e., delta(-rho) = -delta(rho).
delta = sign(rho).*(abs(rho) - sqrt(abs(rho.^2) - L.^2));

% If we are at the reference temperature, then there is no strain, i.e, 
% top strain = bottom strain = 0. And so the radius of curvature if Inf and
% deflection is 0.
for i = 1:size(eps,2)
    if eps(2,i) == 0 && eps(1,i)== 0
        rho(i) = Inf;
        delta(i) = 0;
    end
end

end



