% calculate the current flow and power into each coil, given the coil array S parameter
% and excited wave at tuned and matched port. Syntax:
%
%             [Ic,Vc,Pc] = IcArray(Z0, SC, SM, a_free)
%
% Parameters: 
%                      
%           SM      - 2N*2N matrix, TM network S matrix
%           Z0      - real number, charactertic impedance
%           SC 	    - N*N matrix, coil array S matrix
%		    a_free	- N*numP vector, incident wave in free port
%
% Outputs:
%
%           Ic      - N*numP vector, current vector flow into coil array
%
%           Vc    	- N*numP vector, voltage of each coil
%
%           Pc      - N*numP vector, power vector flow into coil array
%
% Mengjia He, 2022.06.27

function [Ic,Vc,Pc] = IcArray(Z0, SC, SM, a_free)

% calculate F function
FI = E2I(Z0, SC, SM);
FV = E2V(Z0, SC, SM);

% prelocate coil curent and voltage
Ic = FI*a_free;
Vc = FV*a_free;

% calculate the coil power
Pc = 0.5 * real(Vc.*conj(Ic));

end