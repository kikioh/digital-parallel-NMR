% optimization of capacitor value to minimize the reflection ceofficient
%
% note: use Nelder-Mead simplex algorithm 
%
% Syntax:
%
% 		    [SM,C_opt] = tmOptimize(freq,Z0,SC)
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
% 	        SM      - S matrix of tuuning and matching network
%
% Mengjia He 2024.01.04

function [SM,C_opt] = tmOptimize(freq,Z0,SC,Capoption)

if ~exist('Capoption','var') Capoption ='singleCap'; end

% determine coil array number
num = size(SC,1);

switch Capoption

	case 'singleCap'
		
		% initial guess
		[Ct0, ~, Cm0] = tm1Port(freq,Z0,SC(1,1));
		C0 = [Ct0,Cm0];
		
		% define objective function
		fun = @(C) SFDiag(freq,C,SC,'singleCap');

		% Nelder-Mead simplex algorithm 
		C_opt = fminsearch(fun,C0);
		
		% calculated optimized SM 
		[~,SM] = SFDiag(freq,C_opt,SC,'singleCap');
		
	case 'multiCap'
	
		C0 = zeros(1,2*num);
		% initial guess	
		for m = 1:num
			[C0(m), ~, C0(m+num)] = tm1Port(freq,Z0,SC(m,m));
		end
			
		% define objective function
		fun = @(C) SFDiag(freq,C,SC,'multiCap');
		
		options.TolFun = 1e-5;
		options.TolX = 1e-5;
		% Nelder-Mead simplex algorithm 
		C_opt = fminsearch(fun,C0,options);
		
		% calculated optimized SM 
		[~,SM] = SFDiag(freq,C_opt,SC,'multiCap');

end



