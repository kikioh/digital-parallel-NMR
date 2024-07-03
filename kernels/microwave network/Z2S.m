% transform from Z matrix to S matrix, 50 Ohm characteristic impedance
% S = Z2S(Z)
% input: Z - n*n matrix
% output S - n*n matrix
% Mengjia He, 2022.06.22

function S = Z2S(Z,Z0)

% define reference impedance of all ports
if ~exist('Z0','var')
	Z0=50; 
end


n = size(Z,1);
E = eye(n);
Z_ref = Z0*E;
G_ref = 1/sqrt(Z0)*E;
S = (Z - Z_ref) * inv(Z + Z_ref);

end