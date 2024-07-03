% Create sample for extract B field
% Syntax:
%
%                    sample=createSample(num, nuclei, field, options)
%
% Parameters:
%
%	num                	- nummber of samples
%
%   nuclei              - 1*N cell, give isotopes, like{'1H','13C'}, each
%                         channel include these nuclei
%
%   field				- string, specify the field calculation name, 'RF' or 'gradient'
%
%   options.nr          - division number in r direction
%
%   options.np          - division number in phi direction
%
%   options.nz          - division number in z direction
%
%   options.axis        - choose the axis for cylinder sample 
%
% Outputs:
%
%    sample   - COMSOL sample description structure
%
% Mengjia He, 2024.01.01

function sample=createSample(num, nuclei, field, options)

switch field
	case 'RF'
		% default options
		if ~exist('options','var') options = struct; end

		% default division number in r direction
		if ~isfield(options,'nr') options.nr = 3; end

		% default division number in phi direction
		if ~isfield(options,'np') options.np = 3; end

		% default division number in z direction
		if ~isfield(options,'nz') options.nz = 8; end

		% default axis of cylinder sample
		if ~isfield(options,'axis') options.axis = 'x'; end

	case 'gradient'
	
		% default options
		if ~exist('options','var') options = struct; end

		% default division number in r direction
		if ~isfield(options,'nr') options.nr = 1; end

		% default division number in phi direction
		if ~isfield(options,'np') options.np = 1; end

		% default division number in z direction
		if ~isfield(options,'nz') options.nz = 20; end

		% default axis of cylinder sample
		if ~isfield(options,'axis') options.axis = 'z'; end

end

% number of samples
sample.num = num;

% define sample division
sample.nr = options.nr;
sample.np = options.np;
sample.nz = options.nz;

% axis of cylinder sample
sample.axis = options.axis;

% number of voxels
sample.numVox = sample.nr * sample.np * sample.nz;

% volume Factor of each voxel
sample.volFactor = volFactor(sample.nr,sample.np,sample.nz);

% nuclei in the sample
sample.nuclei = nuclei;
sample.nucleiField = strExchange(nuclei);

end