% A example to calculate the B-(Bminus) field of N coils array
% Syntax:
%
% 			[Bm,Vol_factor] = BmArray(coil,sample,model,comsol)
%
% Parameters: 
%                      
%		   coil			- struct, include 
%							- freq, frequency
%							- Z0, charactertic impandnece
%							- num, coil number
%							- excite, number array, incident voltage at match network
%          sample 		- struct, division paras: nr, np, nh, 
%          model	    - COMSOL model
%		   comsol		- struct
%							- objname, string vector, object name of mark point in COMSOL
%							- dset, string, solution daset
%
% Outputs:
%
%     	   Bm     		- N*N cell, B- field of N coils array
%     	   Vol_factor   - volume factor for each voxel
%     	   coord_mesh   - mesh grid in the case of face sampling
%
% Mengjia He, 2022.06.30

function [Bm,Vol_factor,coord_mesh] = BmArray(coil,sample,model,comsol)

% give the coodinate of sample
sample_param = mphevaluate(model,{'r_sample','l_sample'},{'m','m'});
[radius,length] = sample_param.value;

% sample division
n_radius = sample.nr; n_phi = sample.np; n_length = sample.nz;

% volume sample or face slice
if n_phi == 0

	[sample_coord,Vol_factor,n_pos,coord_mesh.x,coord_mesh.z] = xyzCoordFace(radius, length, n_radius, n_length);
else
	[sample_coord,Vol_factor,n_pos] = xyzCoord(radius, length, n_radius, n_phi, n_length);

end

% if x is symmetry axis, exchange x and z
if sample.axis == 'x'
	sample_coord = [sample_coord(3,:);sample_coord(2,:);sample_coord(1,:)];
end

sample_center =cell(coil.num,1);
model.component('comp1').geom('geom1').measure().selection().init(0);
for m = 1:coil.num
	% objectname = append('rot',string(m), '(', comsol.ptindex, ')');
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
if isfield(coil,'freqIndex');
	solNum = coil.freqIndex;
else
	solNum = 1;
end

% import port current
I_simu = zeros(coil.num);
for m = 1:coil.num

	IportName = append('emw.Iport_',string(m));
	I_simu(:,m) = transpose(mphglobal(model,IportName,'dataset',comsol.dset,'outersolnum','all','solnum',solNum));
end
coil.current = I_simu;

% calculate B- field
Bm = cell(coil.num);
for m = 1:coil.num	% sample loop
	Bm_temp = BmNPort(coil,coord{m,1},model,comsol); % B- field for sample m
	for n = 1:coil.num	% coil loop
		Bm{n,m} = Bm_temp(:,n);
	end
end
% The Bm results are as following
% 			sample1		sample2		sample3		sample4	 
% coil1		Bm{1,1}		Bm{1,2}		Bm{1,3}		Bm{1,4}
% coil2		Bm{2,1}		Bm{2,2}		Bm{2,3}		Bm{2,4}
% coil3		Bm{3,1}		Bm{3,2}		Bm{3,3}		Bm{3,4}
% coil4		Bm{4,1}		Bm{4,2}		Bm{4,3}		Bm{4,4}

end