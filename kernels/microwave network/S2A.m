% transform from S matrix to A parameter, 50 Ohm characteristic impedance
% A = S2A(S)
% input: S - 2*2 matrix
% output A - 2*2 matrix
% Mengjia He, 2022.06.21

function A = S2A(S,Z0)

if ~exist('Z0','var')
	Z0=50; 
end

S11 = S(1,1); S12 = S(1,2); S21 = S(2,1); S22 = S(2,2);

A11 = ((1+S11)*(1-S22)+S12*S21)/ (2*S21);
A12 = Z0 * ((1+S11)*(1+S22)-S12*S21)/ (2*S21);
A21 = 1/Z0 * ((1-S11)*(1-S22)-S12*S21)/ (2*S21);
A22 = ((1-S11)*(1+S22)+S12*S21)/ (2*S21);

A = [A11,A12;A21,A22];
end