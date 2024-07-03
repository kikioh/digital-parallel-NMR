% Create sample for extract B field
% Syntax:
%
%                    coil=createCoil(num,options)
% Parameters:
%
%   nuclei              - 1*N cell, give isotopes, like{'1H','13C'}, each
%                         channel include these nuclei
%
%   options.nr    - division number in r direction
%
%   options.np    - division number in phi direction
%
%   options.nz    - division number in z direction
%
% Outputs:
%
%    sample   - COMSOL sample description structure
%
%
% Mengjia He, 2024.01.01

function coil=createCoil(num,options,gradient)

% default options
if ~exist('options','var') options = struct; end

% default coil setting for gradient calculation
if exist('gradient','var')
	coil.num = num*2;            % number of coils
	coil.freq = 500e6; 			 % frequency
	coil.Z0 = 50;			     % reference impedance
	coil.R=load('HiscoreGradient.mat').R;
	coil.L=load('HiscoreGradient.mat').L;
	coil.M=load('HiscoreGradient.mat').M;
	
else

	% default operation frequency
	if ~isfield(options,'freq') options.freq = 500e6; end

	% default reference impedance
	if ~isfield(options,'Z0') options.Z0 = 50; end

	% default reference magnet
	if ~isfield(options,'B0') options.B0 = 11.74; end

	% default excitation profile
	if ~isfield(options,'freeze') options.freeze = zeros(1,num); end

	% define coil array;
	coil.num = num; 
	coil.freq = options.freq; 
	coil.Z0 = options.Z0; 
	coil.B0 = options.B0; 

	coil.excite = zeros(1,num);
	coil.excite(~options.freeze) = 0.1;
end

end