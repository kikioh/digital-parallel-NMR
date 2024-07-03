% pick up the nuclus with the maxmium \Gama, deal with isotropes with multiple channels
% Syntax:
% 
%           [nuclei_max,nucleiField_max]=nucleiSelect(nuclei)
%
% Parameters:
%
%   nuclei               1*N cell, give multiple unique nuclei
%
% Outputs:
%	
%	nuclei_max			- the nuclei with maximal gyromagnetic ratio
%   nucleiField_max   	- the nucleiField with maximal gyromagnetic ratio
%
% Mengjia He, 2022.12.07
 
function [nuclei_max,nucleiField_max]=nucleiSelect(nuclei)

if isempty(nuclei)
    error('the nuclei should include effective isotopes');
end

num = numel(nuclei);

if num == 1 
	nuclei_max = nuclei(1);
else
	nuclei_max = nuclei(1);
	for m = 2:num
		if abs(spin(nuclei_max{1})) < abs(spin(nuclei{m}))
			nuclei_max = nuclei(m);
		end

	end
end
 
nucleiField_max = strExchange(nuclei_max); 

nuclei_max = nuclei_max{1};
nucleiField_max = nucleiField_max{1};
end