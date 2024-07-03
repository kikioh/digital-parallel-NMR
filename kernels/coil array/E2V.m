% calculate the coefficient that transform the excite voltage to coil current. Syntax:
%
%             FV = E2V(Z0, SC, SM)
%
% Parameters:      
%       SM      - 2N*2N matrix, TM network S matrix
%       Z0      - real number, charactertic impedance
%       SC 	    - N*N matrix, coil array S matrix
%
% Outputs:
%
%       FV       - N*N matrix, coefficient transform the excite voltage to
%                  coil voltage
%
% Mengjia He, 2022.11.21

function FV = E2V(Z0, SC, SM)

% set the default charactertic impedance as 50 Ohm
if ~exist('Z0','var'), Z0=50; end

% dimension of S matrix
num = size(SC,1);

% matching network
S11 = SM(1:num,1:num);  S12 = SM(1:num,num+1:num*2);
S21 = SM(num+1:num*2,1:num);    S22 = SM(num+1:num*2,num+1:num*2);

% transform matrix from excitation a to coil current I 
E = eye(num);
F1 = sqrt(Z0) * (inv(SC)+E);
F2 = inv(E - SC * S11) * SC * S12;
FV = F1 * F2;

end