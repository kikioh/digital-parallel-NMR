% calculate the S matrix of free port 
%
% Syntax:
%
%          SF = SFArray(freq,Z0,SC)
%
% Parameters: 
%                      
%          freq 		- frequency
%          Z0   		- charactertic impedance
%          SC 			- coil array S parameters
%
% Outputs:
%
%    	   SF  	-  S matrix of free port 
%
% Mengjia He, 2022.07.12

function SF= SFArray(SC,SM)

% dimension of S matrix
num = size(SC,1);

% matching network
S11 = SM(1:num,1:num);S12 = SM(1:num,num+1:num*2);
S21 = SM(num+1:num*2,1:num);S22 = SM(num+1:num*2,num+1:num*2);
SF = S22 + S21 * inv(eye(num)-SC*S11) * SC * S12;

end


