% calculate the gain of combinated coil array and matching network
%
% Syntax:
%
% 			[gain,SC] = gainArray(coil,sample,model,comsol)
%
% Parameters: 
%		   coil			- struct, include 
%							- freq, frequency
%							- Z0, charactertic impandnece
%							- num, coil number
%							- excite, number array, incident voltage at match network
%          model	    - COMSOL model
%		   comsol		- struct
%							- objname, string vector, object name of mark point in COMSOL
%							- dset, string, solution daset
%
% Outputs:
%
%     	  	gain    - struct, 
%						field: nuclei name, value:N*N complex matrix, gain through 
%						coil coupling and matching network
%     	   	SC  	- struct
% 						field: nuclei name, value: N*N complex matrix, S matrix of coil
%
% Mengjia He, 2022.11.11

function [gain,SC,SM] = gainArray_MultiFreq(coil,sample)

numIsotope = numel(sample.nuclei);

% prelocate results
gain = struct; 
for m = 1:numIsotope

    % gain matrix through coil and matching network
    gain.(sample.nucleiField{m}) = gainArray(coil.Z0,coil.SC.(sample.nucleiField{m}),...
	coil.SM.(sample.nucleiField{m}));
end

% % prelocate gainIndex
% gainIndex = zeros(1,numel(sample.nuclei));
% for m = 1: numel(sample.nuclei)
	
	% % find the gain element for m-th nuclei
	% freq_temp = abs(spin(sample.nuclei{m})*coil.B0))/(2*pi);
	% gainIndex(m) = find(abs(freqUnique-freq_temp)/freq_temp<1e-4);

% end

end

