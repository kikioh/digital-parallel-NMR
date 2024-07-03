% calculate the tuning and matching capacitance from reflection coefficient

% Ref: 2011-A Numerical Postprocessing Procedure for Analyzing Radio Frequency MRI Coils

% Mengjia He, 2022.06.20
function [Ct,Lt,Cm] = tm1Port(freq,Z0,Gama)

if ~exist('Z0','var')
	Z0=50; 
end

omega0 = 2*pi*freq;

% convert to Y parameter
Z = Z0 * (1+Gama)/(1-Gama);
Y_r = real(1/Z); Y_i = imag(1/Z);

% calculate the Ct and Cm
temp = -sqrt(Y_r/Z0 - Y_r^2) - Y_i;
Ct = 0; Lt = 0;
if temp > 0
	Ct = 1/(omega0) * temp;
	s = omega0 * Ct + Y_i;
else
	Lt = -1/(omega0 * temp);
	s = -1/(omega0 * Lt) + Y_i;
end


Cm = -(s^2 + Y_r^2)/(omega0 * s);

end