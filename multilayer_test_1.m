% % Multilayer #1

% ------------------- 
% Al_2 O_3            1 mm
% -------------------
% PbSn                .5 mm
% -------------------
% Ti/Inver Graded     3 mm         (m = 1/2 or 2)         
% -------------------
% PbSn                .5 mm
% -------------------
% SS316               5 mm
%
% T_ref = 456 K
% 220 <= T <= 456

clear all
close all
load('multilayered_materials_data.mat')

%% First we won't do the graded middle layer

% thickness = [1; .5; 3; .5; 5]*1e-3;
% 
% T_vec = linspace(273,456,100);
% T_ref = 456;
% 
% E_data = {E_Alumina,E_PbSn,E_SS316,E_PbSn,E_SS316};
% nu_data = {nu_Alumina_Lower,nu_SS316,nu_PbSn,nu_PbSn,nu_SS316};
% epT_data = {epT_Alumina,epT_PbSn,epT_SS316,epT_PbSn,epT_SS316};
% 
% par = build_params(E_data, nu_data, epT_data, thickness, T_vec, T_ref);
% 
% eps_mat = strain_top_bottom(par);
% stress_mat = stress_mls_layer_avg(par,eps_mat);
% 
% figure(1)
% plot(T_vec,stress_mat)
% xlabel('Temperature (K)')
% ylabel('Stress')
% grid on

%% Let's insert the graded layer.

% First we won't do the graded middle layer
thickness = [1; .1; .2; 5] * 1e-3;

% Changed our final temp since we were missing data
T_vec = linspace(300,456,100);
T_ref = 456;

% Set up parameters for multilayer WITHOUT GRADED LAYER
E_data = {E_Alumina,E_PbSn,E_PbSn,E_SS316};
nu_data = {nu_Alumina_Lower,nu_PbSn,nu_PbSn,nu_SS316};
epT_data = {epT_Alumina,epT_PbSn,epT_PbSn,epT_SS316};

par = build_params(E_data, nu_data, epT_data, thickness, T_vec, T_ref);

% Add graded layer
n = 50;
exponent = 1/2;
ins_lay = 3;

E_bounds = {E_TiG2,E_Invar};
nu_bounds = {nu_TiG2,nu_Invar};
epT_bounds = {epT_TiG2,epT_Invar};

grade_thickness = 3e-3;

par = insert_graded(E_bounds, nu_bounds, epT_bounds, par, grade_thickness, ...
    n, exponent, ins_lay, T_vec, T_ref);

% evaluate top/bottom strain function
[eps] = strain_top_bottom(par);

% evaluate stress
[stress_mat] = stress_mls_layer_avg(par, eps);

figure(3)
plot(T_vec,stress_mat)
xlabel('Temperature (K)')
ylabel('Stress')
grid on

%% Make sure our continuous stress function is working

h = sum(par.thickness);
zz = linspace(0,h,1000);

% evaluate stress
[stress_mat] = stress_vec(zz,par);

figure(2)
plot(T_vec,stress_mat)
xlabel('Temperature (K)')
ylabel('Stress')
surf(T_vec,zz,stress_mat)
xlabel('Temperature (K)')
ylabel('z position')
zlabel('Stress')
print('mysurf','-dpng')

dz = zz(2)-zz(1);
stress_norm = sqrt(dz*sum(stress_mat.^2));

figure(4)
plot(T_vec,stress_norm)
xlabel('Temperature (K)')
ylabel('Norm of \sigma(z)')

% plot(T_vec,eps(2,:)-eps(1,:))