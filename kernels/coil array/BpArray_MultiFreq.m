% A example to calculate the B+(Bplus) field of N coils array
% Syntax:
%
% 			[Bp,Vol_factor,coord_mesh ] = BpArray_MultiFreq(coil,sample,model,comsol)
%
% Parameters:
%
%		   coil			- struct, include
%							- freq, number array, frequency
%							- Z0, charactertic impandnece
%							- num, coil number
%							- excite, number array, incident voltage at match network
%          sample 		- struct, division paras: nr, np, nh, ptindex
%          model	    - COMSOL model
%		   comsol		- struct
%							- objname, string vector, object name of mark point in COMSOL
%							- dset, string, solution daset
%
%
% Outputs:
%
%     	   Bp     - 1*N cell, B+ field of N sample
%
% Mengjia He, 2022.11.09

function Bp= BpArray_MultiFreq(coil,sample,model,comsol)

% prelocate Bp field
Bp = cell(1,coil.num);

% The B+ results are as following
% sample1		sample2		sample3		sample4	 	...
% Bp{1,1}		Bp{1,2}		Bp{1,3}		Bp{1,4}		...
%
% note that different Bp element may be calculated under different frequncy

% align the coil according to operation frequency
coil_temp = coil;
freqUnique = unique(coil.freq,'sorted');

for m = 1:numel(freqUnique)
    % update calculation frequency
    coil_temp.freq = freqUnique(m);
    coil_temp.freqIndex = m; % frequency index in comsol

    % find the coil index that are excited
    coilIndex = find(coil_temp.freq==coil.freq);

    % update excite wave
    coil_temp.excite = zeros(1,coil.num);
    coil_temp.excite(coilIndex) = coil.excite(coilIndex);

    % calculate Bp field
    Bp_temp = BpArray(coil_temp,sample,model,comsol);

    for n = coilIndex
    	Bp{1,n} =  Bp_temp{1,n};
    end
end

end