% A example to calculate the B+(Bplus) field of N coils array
% Syntax:
%
% 			[Bp,Vol_factor] = BpArray(coil,sample,model,comsol)
%
% Parameters: 
%                      
%		   coil			- struct, include 
%							- freq, frequency
%							- Z0, charactertic impandnece
%							- num, coil number
%							- excite, number array, incident voltage at match network
% 							- freqIndex(optional), indicate solution number in COMSOL
%          sample 		- struct, division paras: nr, np, nh, ptindex
%          model	    - COMSOL model
%		   comsol		- struct
%							- objname, string vector, object name of mark point in COMSOL
%							- dset, string, solution daset
%
% Outputs:
%
%     	   Bp     		- 1*N cell, B+ field of N sample
%     	   gFunction    - 1*N cell, coefficients transform coil current to B+ field
%     	   Vol_factor   - volume factor for each voxel
%     	   coord_mesh   - mesh grid in the case of face sampling
%
% Mengjia He, 2022.06.30

function [Bp,gFunction,Vol_factor,coord_mesh,coord] = BpArray(coil,sample,model,comsol)


% give the coodinate of sample
sample_param = mphevaluate(model,{'r_sample','l_sample'},{'m','m'});
[radius,length] = sample_param.value;
length = length;
% sample division
n_radius = sample.nr; n_phi = sample.np; n_length = sample.nz;

% volume sample or face slice
if n_phi == 0

	[sample_coord,Vol_factor,n_pos,coord_mesh.x,coord_mesh.z] = xyzCoordFace(radius, length, n_radius, n_length);
else
	[sample_coord,Vol_factor,n_pos] = xyzCoord(radius, length, n_radius, n_phi, n_length);
	coord_mesh = 0;

end

% if x is symmetry axis, exchange x and z
if sample.axis == 'x'
	sample_coord = [sample_coord(3,:);sample_coord(2,:);sample_coord(1,:)];
end

sample_center =cell(coil.num,1);
model.component('comp1').geom('geom1').measure().selection().init(0);
for m = 1:coil.num
	% objectname = append('rot', string(m), '(', comsol.ptindex, ')');
	objectname = comsol.objname(m);
	model.component('comp1').geom('geom1').measure().selection().set(objectname,[1]);
	sample_center{m,1} =  model.component('comp1').geom('geom1').measure().getVtxCoord();
	model.component('comp1').geom('geom1').measure().selection().remove(objectname,[1]);
end

% move to each sample center
coord = cell(coil.num,1);
for m = 1:coil.num

	center_temp = sample_center{m,1};
	coord{m,1}  = sample_coord + repmat(center_temp,1,n_pos);
end

% select solution number, i.e., frequency
if isfield(coil,'freqIndex')
	solNum = coil.freqIndex;
else
	solNum = 1;
end

% default excite voltage
if ~isfield(coil,'excite') coil.excite = 0.01*ones(1,coil.num); end

% default B field calaulation: no approximation
if ~isfield(coil,'approximation') coil.approximation='none'; end

% % import S parameters
% if coil.num == 1
	% SC = mphglobal(model,'emw.S11','dataset',comsol.dset,'outersolnum','all','solnum',solNum);
	% coil.SC = SC;
% else
	% SC = mphevalglobalmatrix(model,'emw.S','dataset',comsol.dset,'solnum',solNum);
	% coil.SC = SC(:,2:coil.num+1);
% end

% import port current
I_simu = zeros(coil.num);
for m = 1:coil.num
	IportName = append('emw.Iport_',string(m));
	I_simu(:,m) = transpose(mphglobal(model,IportName,'dataset',comsol.dset,'outersolnum','all','solnum',solNum));
end
coil.current = I_simu;

% calculate B+ field
Bp = cell(1,coil.num);
gFunction = cell(1,coil.num);
for m = 1:coil.num
	[Bp{1,m},gFunction{1,m}] = BpNPort(coil,coord{m,1},model,comsol);
end

% The B+ results are as following
% sample1		sample2		sample3		sample4	 
% Bp{1,1}		Bp{1,2}		Bp{1,3}		Bp{1,4}
end