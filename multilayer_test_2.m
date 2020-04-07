% % Multilayer Test #2

% Here's our stack:
%
% ------------------- 
% Al                  .5 mm
% -------------------
% Graded              4 mm (m = whatever, let's start with 1/2)
% -------------------
% Cu                  2 mm      
% -------------------
%
% T_ref = 295 K
% 220 <= T <= 440

clear all
load('multilayered_materials_data.mat')

thickness = [.5; 2]*1e-3;

T_vec = linspace(220,400,100);
T_ref = 295;
T_vec = [T_vec T_ref];

E_data = {E_Aluminum,E_Cu};
nu_data = {nu_Aluminum,nu_Cu};
epT_data = {epT_Aluminum,epT_Cu};

% Build parameters WITHOUT GRADED LAYERS
par = build_params(E_data, nu_data, epT_data, thickness, T_vec, T_ref);

% Add graded layer
n = 50;
exponent = 1/2;
ins_lay = 2;

% Since we're interpolating between the two materials in the stack, we can
% just use our data as our bounds:
E_bounds = E_data;
nu_bounds = nu_data;
epT_bounds = epT_data;

grade_thickness = 4e-3;

% Now insert our graded layers with given bounds into par
par = insert_graded(E_bounds, nu_bounds, epT_bounds, par, grade_thickness, ...
    n, exponent, ins_lay, T_vec, T_ref);

% evaluate stress
% [stress_mat] = stress_mls_layer_avg(par, eps);

h = sum(par.thickness);
zz = linspace(0,h,1000);

% evaluate stress
[stress_mat] = stress_vec(zz,par);

figure
surf(T_vec,zz,stress_mat)
xlabel('Temperature (K)')
ylabel('z position')
zlabel('Stress')

figure
plot(zz,stress_mat(:,end-1),'.--')
grid on

[zb,bd_props] = bd_props(par);
eps = strain_top_bottom(par);

% Top/bottom strain for each layer
[stress_boundaries] = stress_mls_layer_boundaries(zb, bd_props, eps);

% Calculate top/bottom strain for each layer
[strain_boundaries] = strain_mls_layer_boundaries(zb, bd_props, eps);

figure
plot(zb, stress_boundaries(:,end-1))