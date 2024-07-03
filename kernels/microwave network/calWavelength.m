% calculate the wavelength in sample
%
% Ref: 沈熙宁，电磁场与电磁波，page 313
%
% Mengjia He， 2024.05.03

% frequency
omega = 2*pi*600e6;

% sample parameters, water
mu = 1.257e-6;
gamma = 5.5e-6;
epsilon = 81*8.85e-12;

% wavelength
lambda = 2*pi/(omega*sqrt(mu*epsilon)) * sqrt(2/(sqrt(1+(gamma/omega*epsilon)^2)+1));
disp('wavelength in water is');
disp(lambda);

