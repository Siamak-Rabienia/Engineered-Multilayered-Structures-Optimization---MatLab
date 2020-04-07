function [strain_mag_layer] = strain_magnitude_layer(strain_boundaries)
% function [stress_mag_layer] = stress_magnitude_layer(stress_boundaries);
% stress_mag_layer = ((sig_i^2 + sig_{i-1}^2 + sig_i*sig_{i-1})/3).^(1/2)

epsplus = strain_boundaries(1:2:end-1,:).^2 + strain_boundaries(2:2:end,:).^2;
epstimes = strain_boundaries(1:2:end-1,:).*strain_boundaries(2:2:end,:);
strain_mag_layer = ((epsplus + epstimes)/3).^(1/2);