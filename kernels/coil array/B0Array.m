% extract the B0 field of N coils array from COMSOL
% Syntax:
%
% 			[B0,Vol_factor] = B0Array(coil,sample,model,comsol)
%
% Parameters: 
%                      
%		   coil			- struct, include 
%							- freq, frequency
%							- Z0, charactertic impandnece
%							- num, coil number
%							- excite, number array, incident voltage at match network
%          sample 		- struct, division paras: nr, np, nh 
%          model	    - COMSOL model
%		   comsol		- struct	
%							- objname, string vector, object name of mark point in COMSOL
%							- dset, string, solution daset
%
% Outputs:
%
%     	   B0     			- 1*N cell, B0 field inside N samples
%		   coord			- 1*N cell, coordinate of sample point of N samples
%		   Vol_factor		- 1*numVox, weights of each voxel according to its volume
%		   sample_coord		- 3*numVox, coordinate of sample point, assuming (0,0,0) as center point.
%
% Mengjia He, 2022.08.26

function [B0,coord,Vol_factor,sample_coord] = B0Array(coil,sample,model,comsol)

%
num = sample.num;

% give the coodinate of sample
sample_param = mphevaluate(model,{'r_sample','l_sample'},{'m','m'});
[radius,length] = sample_param.value;
length = length * 0.8;
% sample division
n_radius = sample.nr; n_phi = sample.np; n_length = sample.nz;
[sample_coord,Vol_factor,n_pos] = xyzCoord(radius, length, n_radius, n_phi, n_length);

% if x is symmetry axis, exchange x and z
if sample.axis == 'x'
	sample_coord = [sample_coord(3,:);sample_coord(2,:);sample_coord(1,:)];
end

sample_center =cell(num,1);
model.component('comp1').geom('geom1').measure().selection().init(0);
for m = 1:num
	% objectname = append('rot',string(m), '(', comsol.ptindex, ')');
	objectname = comsol.objname(m);
	model.component('comp1').geom('geom1').measure().selection().set(objectname,[1]);
	sample_center{m,1} =  model.component('comp1').geom('geom1').measure().getVtxCoord();
	model.component('comp1').geom('geom1').measure().selection().remove(objectname,[1]);
end

% move to each sample center
coord = cell(1,num);
for m = 1:num

	center_temp = sample_center{m,1};
	coord{1,m}  = sample_coord + repmat(center_temp,1,n_pos);
end

% extract B0 field
B0 = cell(1,num);
for m = 1:num

    B0{1,m} = mphinterp(model,'mfnc.Bz','coord',coord{1,m});
end

% The Bm results are as following
% sample1		sample2		sample3		sample4	 
% B0{1,1}		B0{1,2}		B0{1,3}		B0{1,4}

end