% transform from S matrix to Z matrix, 50 Ohm characteristic impedance
% Z = S2Z(S)
% input: S - n*n matrix
% output Z - n*n matrix
% Mengjia He, 2022.06.22

function Z = S2Z(S,Z0)

% define reference impedance of all ports
if ~exist('Z0','var')
	Z0=50; 
end

n = size(S,1);
E = eye(n);
Z_ref = Z0*E;
G_ref = 1/sqrt(Z0)*E;
Z = inv(E-S)*(E+S)*Z_ref;

end