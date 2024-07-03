% calculate the coefficient that transform the excite voltage to coil current. Syntax:
%
%             F = E2I(Z0, SC, SM)
%
% Parameters:      
%       SM      - 2N*2N matrix, TM network S matrix
%       Z0      - real number, charactertic impedance
%       SC 	    - N*N matrix, coil array S matrix
%
% Outputs:
%
%       F       - N*N matrix, coefficient transform the excite voltage to coil current
%
% Mengjia He, 2022.11.21

function F = E2I(Z0, SC, SM)

% set the default charactertic impedance as 50 Ohm
if ~exist('Z0','var'), Z0=50; end

% dimension of S matrix
num = size(SC,1);

% matching network
S11 = SM(1:num,1:num);  S12 = SM(1:num,num+1:num*2);

% transform matrix from excitation a to coil current I 
E = eye(num);
F1 = 1/sqrt(Z0) * (inv(SC)-E);
F2 = inv(E - SC * S11) * SC * S12;
F = F1 * F2;

end

% % combine coil array with tunning and matching circuit
% n = size(SC,1);
% [SCM, a_mat] = SCMA(freq,Z0,SC);
% 
% % calculate f function
% fFunction = 1/sqrt(Z0) * (eye(size(SCM))-SCM)* a_mat;
% fFunction = fFunction(1:n,:);