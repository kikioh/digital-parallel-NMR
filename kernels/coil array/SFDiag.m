% calculate the free port S matrix according the designed TM capacitance
%
% Syntax:
%
% 		[obj, SM] = SFDiag(freq,C,SC)
%
% Parameters:
%
% 	        freq    - operation frequency
%
% 	        C       - 1*2 vector, tunning and matching capacitance
%
% 	        SC      - coil array S matrix
%
% Outputs:
%
% 	        obj     - objective function, sum of square the diagonal elements of SF
%
% 	        SM      - S matrix of tuuning and matching network
%
% Mengjia He 2024.01.04

function [obj, SM] = SFDiag(freq,C,SC,option)

if ~exist('option','var') option ='singleCap'; end

% extract parameters
num = size(SC,1);
omega = 2*pi*freq;
SM = [];

% generate SM matrix
switch option

	case 'singleCap'
		
		Ct = C(1); Cm = C(2);

		% prelocate SM matrix
		for m = 1:num
			% tuning and matching for each coil and combine with orginal matrix successively
			A1 = [1,1/(1i*omega*Cm);0,1] * [1,0;1i*omega*Ct,1];
			S1 = A2S(A1);
			SM = blkdiag(SM,S1);
		end
		
	case 'multiCap'
		% prelocate SM matrix
		for m = 1:num
			% tuning and matching for each coil and combine with orginal matrix successively
			A1 = [1,1/(1i*omega*C(m+num));0,1] * [1,0;1i*omega*C(m),1];
			S1 = A2S(A1);
			SM = blkdiag(SM,S1);
		end
		
end

% put the interconnect ports in front, and free ports behind
SM = exchangeOrder(SM,[linspace(2,2*num,num),linspace(1,2*num-1,num)]);

% free port S matrix
s11 = SM(1:num,1:num); s12 = SM(1:num,num+1:num*2);
s21 = SM(num+1:num*2,1:num); s22 = SM(num+1:num*2,num+1:num*2);

% free port S matrix
SF = s22 + s21/(eye(num)-SC*s11)*SC*s12;

% calculate cost function
obj = sum(abs(diag(SF)).^2);

end
