% Signal amplitude for unit Volume, B1_rec = 1T, Syntax:
% 
% 				amplitude = signalAmp(B0,I,gama,n,T)
%
% Parameters:
%
% 	B0:    DC magnetic field, T
% 	I:     spin number
% 	gama:  gyromagnetic ratio, rad/s
% 	n:     the number of spins per m^3 (volume)
% 	T:     temperature，Kelvin
%
% Outputs:
%
% 	amplitude:  Signal amplitude for unit Volume and unit B1
%
% Note: This output can be directly multiplied to singal strength equation
%
% Ref: 1976_Hault_JMR_The Signal-to-Noise Ratio of the Nuclear Magnetic Resonance Experiment
%	   Eq.(4-5)
%
% Mengjia He 2022.02.14

function amplitude = signalAmp(B0,I,gama,n,T)

hbar = 1.054571628e-34;     % Planck constant
k = 1.3806503e-23;          % Boltzmann constant

% Equilibrium Magnetization at high-temperature limit
Mz = n*gama^2*hbar^2*B0*I*(I+1)/(3*k*T); 

omega = gama * B0;
amplitude = omega * Mz;

end