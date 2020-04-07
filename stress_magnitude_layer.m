function [stress_mag_layer] = stress_magnitude_layer(stress_boundaries)
% function [stress_mag_layer] = stress_magnitude_layer(stress_boundaries);
% stress_mag_layer = ((sig_i^2 + sig_{i-1}^2 + sig_i*sig_{i-1})/3).^(1/2)

sigplus = stress_boundaries(1:2:end-1,:).^2 + stress_boundaries(2:2:end,:).^2;
sigtimes = stress_boundaries(1:2:end-1,:).*stress_boundaries(2:2:end,:);
stress_mag_layer = ((sigplus + sigtimes)/3).^(1/2);