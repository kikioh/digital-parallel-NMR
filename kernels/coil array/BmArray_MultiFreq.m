% calculate the B-(Bminus) field of N coils array, with multiple
% frequencys, suppose all coils has been deployed with multiple tunning and
% match circuits using shunting method. 
%
% Mispelter, J., Lupu, M. & Briguet, A. NMR probeheads for biophysical and biomedical experiments. (IMPERIAL COLLEGE PRESS, 2015). doi:10.1142/p759.
%
% Syntax:
%
% 			[Bm,BmIndex] = BmArray_MultiFreq(coil,sample,model,comsol)
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
%     	    Bm     		  - struct, 
%								field: nuclei name, value:N*N cell, B- field of N coils array from N samples
%
% Mengjia He, 2022.11.09

function Bm = BmArray_MultiFreq(coil,sample,model,comsol)

% align the coil according to operation frequency
coil_temp = coil;
num = numel(sample.nuclei);

freqUnique = zeros(1,num);
for m = 1:num

	freqUnique(m) = abs(spin(sample.nuclei{m}))*coil.B0/(2*pi);
end

% the frequency sweep in comsol is ascend
freqUnique = sort(freqUnique,'ascend');

% prelocate Bm field
% Bm = cell(numel(freqUnique),coil.num,coil.num);
Bm = struct;
for m = 1:num
    % update calculation frequency
    freq_temp = abs(spin(sample.nuclei{m}))*coil.B0/(2*pi);
	coil_temp.freq = freq_temp;
    coil_temp.freqIndex = find(abs(freqUnique-freq_temp)/freq_temp<1e-4);
	
    % calculate Bp field
    Bm.(sample.nucleiField{m}) = BmArray(coil_temp,sample,model,comsol);
	
end

% % prelocate BmIndex
% BmIndex = zeros(1,numel(sample.nuclei));
% for m = 1: numel(sample.nuclei)
	
	% % find the Bm element for m-th nuclei
	% freq_temp = abs(spin(sample.nuclei{m})*coil.B0))/(2*pi);
	% BmIndex(m) = find(abs(freqUnique-freq_temp)/freq_temp<1e-4);

% end

end

% The Bm results for one nuclei X are as following
% 			sample1			sample2			sample3			sample4	 
% coil1		Bm.X{1,1}		Bm.X{1,2}		Bm.X{1,3}		Bm.X{1,4}
% coil2		Bm.X{2,1}		Bm.X{2,2}		Bm.X{2,3}		Bm.X{2,4}
% coil3		Bm.X{3,1}		Bm.X{3,2}		Bm.X{3,3}		Bm.X{3,4}
% coil4		Bm.X{4,1}		Bm.X{4,2}		Bm.X{4,3}		Bm.X{4,4}
