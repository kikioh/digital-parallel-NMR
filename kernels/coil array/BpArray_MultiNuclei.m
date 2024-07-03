% A example to calculate the B+(Bplus) field of N coils array
% Syntax:
%
%			 [Bp,gFunction] = BpArray_MultiNuclei(coil,sample,model,comsol)
%
% Parameters:
%
% coil		- struct, include
% 				- freq, number array, frequency
% 				- Z0, charactertic impandnece
% 				- num, coil number
% 				- excite, number array, incident voltage at match network
%
% sample 	- struct, division paras: nr, np, nz, ptindex
%
% model	    - COMSOL model
%
% comsol	- struct
% 				- objname, string vector, object name of mark point in COMSOL
% 				- dset, string, solution daset
%
% Outputs:
%
%				Bp     		- struct,B.X - B+ field of nuclei X
%
%				gfunction  	- struct, gFunction.X, 1*N cell, 
%							  coefficients transform coil current to B+ field
%
% Mengjia He, 2022.11.09

function [Bp,gFunction] = BpArray_MultiNuclei(coil,sample,model,comsol)

numIsotope = numel(sample.nuclei);
nucleiField = sample.nucleiField;

coil_temp = struct;
coil_temp.num = coil.num;
coil_temp.excite = coil.excite;
coil_temp.Z0 = coil.Z0;

% coil_temp = coil;

% calculate operation frequency
freqUnique = zeros(1,numIsotope);
for q = 1:numIsotope

	freqUnique(q) = abs(spin(sample.nuclei{q}))*coil.B0/(2*pi);
	
end

% the frequency sweep in comsol is ascend
freqUnique = sort(freqUnique,'ascend');

% % extract S matrix cell array
% SC = extractS_Multifreq(coil,sample,model,comsol,'cell');

% calculate Bp field nuclei by nuclei
Bp = struct; gFunction = struct;
for q = 1:numIsotope	% nuclei loop

	% update calculation frequency
	coil_temp.freq = abs(spin(sample.nuclei{q}))*coil.B0/(2*pi);
	coil_temp.freqIndex = find(abs(freqUnique-coil_temp.freq)/coil_temp.freq < 1e-6); % frequency index in comsol

	% % update excite wave
	% coil_temp.excite = 0.01 * ones(1,coil.num);
	% coil_temp.SC = SC{coil_temp.freqIndex};
	% coil.temp.SM = SMArray(coil_temp.freq,coil_temp.Z0,coil_temp.SC);
	
	coil_temp.SC = coil.SC.(nucleiField{q});
	coil_temp.SM = coil.SM.(nucleiField{q});
	
	% calculate Bp field
	[Bp.(nucleiField{q}),gFunction.(nucleiField{q})] = BpArray(coil_temp,sample,model,comsol);

end

end

% The B+ results of nuclei X are as following
%
% sample1		sample2			sample3			sample4	 	...
% Bp.X{1,1}		Bp.X{1,2}		Bp.X{1,3}		Bp.X{1,4}	...
%
% Bp.X are calculated under X resonance, with uniform excitation (see line 51).