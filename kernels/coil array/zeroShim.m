% zero order shimming of the simulated B0, i.e., remove it's mean
% difference from reference B0
%
% Syntax:
%
%        B0_shim = zeroShim(B0,B0_ref)
%
% Parameters: 
%          
%       Bp          - cell array, each cell is the sampled values of unshimmed B0
%       B0_ref    	- reference B0
%
% Outputs:
%
%       B0_shim       - zero order shimmed B0
%
% Mengjia He, 2022.09.01

function B0_shim = zeroShim(B0,B0_ref,ideal)

% set up default reference magnet
if ~exist('B0_ref','var') B0_ref=11.74; end

% set up default reference magnet
if ~exist('ideal','var') ideal='nonideal'; end

% prelocate shimmed B0
B0_shim = cell(size(B0));
if strcmp(ideal,'ideal')

	for m = 1:numel(B0)   % sample loop

		B0_shim{m} = B0_ref * ones(size(B0{m}));
		
	end
else
	for m = 1:numel(B0)   % sample loop

		deltB_bar = mean(B0{m}-B0_ref);
		B0_shim{m} = B0{m} - deltB_bar;
		
	end

end

end
