% calculate the total B field at given sample points, with N port excitation
% Syntax:
%
%             B = I2B(I_coil, B_simu,I_simu)
%
% Parameters: 
%                      
%          I_coil	- 1*N vector, calculated current at N coil port
%          B_simu  	- 1*N vector, B field from COMSOL
%          I_simu  	- N*N matrix, coil port current from COMSOL
%
% Outputs:
%
%     	   B  -  complex number, B field at one point with N excitation
%     	   C  -  complex vector, the linear coefficient on coil current
%
% Note: This function is usually called by BpNPort.m which calculates B+ field
% when given N port excitation
%
% Mengjia He, 2022.06.27

function [B,C] = I2B(I_coil, B_simu,I_simu)

% calculate the combination cofficient
% Ref:matlab-help-pinv page
C = lsqminnorm(I_simu,transpose(B_simu));

% calculate total B field at sample point
B = I_coil * C;

end


