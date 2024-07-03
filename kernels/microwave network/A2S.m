% transform from A matrix to S parameter, 50 Ohm characteristic impedance
% S = A2S(A)
% input: A - 2*2 matrix
% output S - 2*2 matrix
% Mengjia He, 2022.06.21

function S = A2S(A)

if ~exist('Z0','var')
	Z0=50; 
end

S11 = (A(1,1)+A(1,2)/Z0-A(2,1)*Z0-A(2,2)) / (A(1,1)+A(1,2)/Z0+A(2,1)*Z0+A(2,2));
S12 = 2*(A(1,1)*A(2,2) - A(1,2)*A(2,1)) / (A(1,1)+A(1,2)/Z0+A(2,1)*Z0+A(2,2));
S21 = 2 / (A(1,1)+A(1,2)/Z0+A(2,1)*Z0+A(2,2));
S22 = (-A(1,1)+A(1,2)/Z0-A(2,1)*Z0+A(2,2)) / (A(1,1)+A(1,2)/Z0+A(2,1)*Z0+A(2,2));

S = [S11,S12;S21,S22];
end