% Testing change in stress, radius of curvature, and deflection due to 
% layer thickness (z-axis) thermal expansion/compression

% This file uses the parameters for the four layers in Hall (Sandia 
% Paper 2 ) to calculate the stress in the middle of each layer by calling
% on the function 'stress'. The thickens of each layer varies in each
% iteration of the for loop from a 10% decrease to a 10% increase. Radius 
% of curvature and deflection are also calculated.

% Number of iterations
itr = 10;

% Parameters
alpha = [6 80 23 40];
mod = [15 0.1 10 1];    % modulus
nu = [.23 .3 .32 .3];   % poisson
N = length(alpha);

% Initialize quantities of interest to be stored for each iteration.
sigma_mid = zeros(itr+1,N);
rho = zeros(itr+1,1);
delta = zeros(itr+1,1);
e_t = zeros(itr+1,1);
e_b = zeros(itr+1,1);

for jj = 1:itr+1

% Vary layer width. 
widths = [.021 * (.9 + (jj-1)*((1.1-.9)/itr)), ...
    .006 * (.9 + (jj-1)*((1.1-.9)/itr)), ...
    .03 * (.9 + (jj-1)*((1.1-.9)/itr)), ...
    .001 * (.9 + (jj-1)*((1.1-.9)/itr))];  % thickness

% Change in temperature
DT = -180;
eps_th = alpha * DT;    % therm_strain

% Get the top and bottom strains.
[e_t(jj), e_b(jj)] = strain(mod,eps_th,nu,widths);
% Get the stress in the middle of each layer.
sigma_mid(jj,:) = stress(mod,eps_th,nu,widths);

% The total width h is the sum of the widths of each layer.
h = sum(widths);
% Radius of curvature
rho(jj) = h / (e_t(jj) - e_b(jj));
% Disk radius
% Note: This parameter is not in the paper. It is arbitrarily chosen to be
% significantly smaller than the radius of curvature.
L = abs(-1.2607e-05)/100;
% deflection
delta(jj) = abs(rho(jj)) - sqrt(abs(rho(jj)^2) - L^2);

end

% Relative change
for i = 1:N
    sigma_mid(:,i) = sigma_mid(:,i)./sigma_mid(itr/2 + 1,i);
end
rho = rho./rho(itr/2 + 1);
delta = delta./delta(itr/2 + 1);
e_t = e_t./e_t(itr/2 + 1);
e_b = e_b./e_b(itr/2 + 1);

% Plot quantities of interest against percentage of original width.
h_plot = (.9 : (1.1-.9)/itr : 1.1)*100;

plot(h_plot,e_t)
xlabel('Percent of initial width')
ylabel('Top Strain')
title('')

figure
plot(h_plot,e_b)
xlabel('Percent of initial width')
ylabel('Bottom Strain')
title('')

figure
plot(h_plot,sigma_mid)
xlabel('Percent of initial width')
ylabel('Stress')
title('')

figure
plot(h_plot,rho)
xlabel('Percent of initial width')
ylabel('Radius of Curvature')
title('')

figure
plot(h_plot,delta)
xlabel('Percent of initial width')
ylabel('Deflection')
title('')
















