% Script for giving the xyz coordinate of cylinder sample,suppose z axis as the symmetry axis
% Syntax:
%
% 			sampleCoord = sampleCoord(coil,sample,model,comsol)
%
% Arguments:
%
%		   coil			- struct, include 
%							- freq, frequency
%							- Z0, charactertic impandnece
%							- num, coil number
%							- excite, number array, incident voltage at match network
% 							- freqIndex(optional), indicate solution number in COMSOL
%          sample 		- struct, division paras: nr, np, nh, ptindex
%          model	    - COMSOL model
%
% Outputs:
%
% 		sampleCoord:       	n*1 cell array, coordinate of the n sample

% Mengjia He 2022.02.14

function [coord,volFactor] = sampleCoord(coil,sample,model,comsol)

% give the coodinate of sample
sample_param = mphevaluate(model,{'r_sample','l_sample'},{'m','m'});
[radius,length] = sample_param.value;
length = length * 0.8;
% sample division
n_radius = sample.nr; n_phi = sample.np; n_length = sample.nz;

% volume sample or face slice
if n_phi == 0

	[sample_coord,volFactor,n_pos,coord_mesh.x,coord_mesh.z] = xyzCoordFace(radius, length, n_radius, n_length);
else
	[sample_coord,volFactor,n_pos] = xyzCoord(radius, length, n_radius, n_phi, n_length);

end

% if x is symmetry axis, exchange x and z
if sample.axis == 'x'
	sample_coord = [sample_coord(3,:);sample_coord(2,:);sample_coord(1,:)];
end

sample_center =cell(sample.num,1);
model.component('comp1').geom('geom1').measure().selection().init(0);
for m = 1:sample.num
	% objectname = append('rot', string(m), '(', comsol.ptindex, ')');
	objectname = comsol.objname(m);
	model.component('comp1').geom('geom1').measure().selection().set(objectname,[1]);
	sample_center{m,1} =  model.component('comp1').geom('geom1').measure().getVtxCoord();
	model.component('comp1').geom('geom1').measure().selection().remove(objectname,[1]);
end

% move to each sample center
coord = cell(sample.num,1);
for m = 1:sample.num

	center_temp = sample_center{m,1};
	coord{m,1}  = sample_coord + repmat(center_temp,1,n_pos);
	
end

end