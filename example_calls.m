% % Sample Function Calls
% % Peter Wills, 7/21/2016

% We're going to do some example calls of the stress and strain functions
% of Paul's. They're a bit different from the old ones.

% First, we list our parameters in a COLUMN VECTOR. In the old function, we
% used row vectors. This will sometimes not be an issue, but it can become
% an issue eventually, so it's worth paying attention to.

% setup workspace
clear all; close all; clc;

% Initialize properties
modulus = [
    15 % Ceramic
    0.1  % Adhesive
    10  % Aluminum
    1  % Encaps
    ];

nu = [
    0.23 % Ceramic
    0.3  % Adhesive
    0.32 % Aluminum
    0.3  % Encaps
    ];

delta_t = -180; % K

strain_th_in_plane = [
    6*delta_t % Ceramic
    80*delta_t  % Adhesive
    23*delta_t % Aluminum
    40*delta_t % Encaps
    ];

thickness = [
    0.021  % Ceramic
    0.006  % Adhesive
    0.03   % Aluminum
    0.001  % Encaps
    ];

% We'll need the number of layers:
N = length(thickness); % Could have used any of the vectors

% We need to wrap these things up in a "structure". We'll call the
% structure 'par', and build it as follows:

properties.modulus = modulus;
properties.nu = nu;
properties.strain_th_in_plane = strain_th_in_plane;
properties.thickness = thickness;

% Now we're ready to call the strain function. The output is the top and
% bottom strain

strains = strain_top_bottom(properties);

% Now let's figure out the mean stress at the center of each layer. We call
% it like so:

stress_mean = stress_mls_layer_avg(properties);

% Take a look in your workspace to make sure that everything came out like
% you expected.

% Calculate radius of curvature and deflection
L = 1e-5;
[rho, delta] = rad_and_def(L, properties);

% We'll use the other stress function. It will give us the stress at
% a vector of z locations in the multilayer. This will be useful for
% visualizing the stress, as well as for general calculation of L1 norms,
% etc.

% z = [0; cumsum(thickness)];
% h = z(end);
% zz = linspace(0,h,1000);
% 
% stress = stress_vec(zz,properties);
% plot(zz,stress)