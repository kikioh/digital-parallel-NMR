% calculate the total gain matrix of signal vector in coil and matching network 
%
% Syntax:
%
%             [G,F,SF,S11,S12,S21,S22] = gainArray(Z0,SC,SM) or gainArray(coil)
%
% Parameters: 
%                      
%          (coil.)freq 		- frequency
%          (coil.)Z0   		- charactertic impedance
%          (coil.)SC 	    - coil array S parameters
%
% Outputs:
%
%     	   G  	-  total gain matrix of signal vector in coil and matching network 
%    	   F  	-  transform matrix from excitation a to coil current I 
%    	   SF  	-  S matrix of free port 
%
% Note: This function is usually called to calculate the signal and noise level at
% matching network output
%
% Mengjia He, 2022.07.12

function [G,F,SF,S11,S12,S21,S22] = gainArray(varargin)

% input coil strcuture
if nargin == 1
    Z0 = varargin{1}.Z0; 
    SC = varargin{1}.SC; 
    SM = varargin{1}.SM; 

% input Z0,SC,SM
elseif nargin == 3
    Z0 = varargin{1};
    SC = varargin{2};
    SM = varargin{3};
else
    error('input should be coil struct or Z0-SC-SM parameters');
end

% dimension of S matrix
num = size(SC,1);

% matching network
SF = SFArray(SC,SM);

S11 = SM(1:num,1:num);S12 = SM(1:num,num+1:num*2);
S21 = SM(num+1:num*2,1:num);S22 = SM(num+1:num*2,num+1:num*2);

% gain through coil and TM network
E = eye(num);
G1 = S21 * pinv(E - SC * S11);
G2 = 1/2 * (E - SC);
G = G1 * G2;

% transform matrix from excitation a to coil current I 
F1 = 1/sqrt(Z0) * (inv(SC)-E);
F2 = inv(E - SC * S11) * SC * S12;
F = F1 * F2;

end


