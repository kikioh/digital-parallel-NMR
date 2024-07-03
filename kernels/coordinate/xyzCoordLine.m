% Script for giving the xyz coordinate along the z axis of cylinder sample center, suppose z axis as the symmetry axis
% Syntax:
%
% 			[sample, vol_factor, num_ensemble] = xyzCoord(R,Z,n_r,n_phi,n_z)
%
% Arguments:
%
% 		R:     the maxmium radius of cylinderal sample
% 		Z:     the length of cylinderal sample
% 		n_r:   the number of points along r direction
% 		n_phi: the number of points along phi direction
% 		n_z    the number of points along z direction
%
% Outputs:
%
% 		sample:       	3*n array, coordinate of the sampling points
% 		Vol_factor: 	1*n vector, the volume of each voxel, divided by total Volume
% 		num_ensemble: 	number, number of points in space domain

% Mengjia He 2022.02.14

function [sample,num_ensemble] = xyzCoordLine(Z,n_z)

num_ensemble = n_z;

x = zeros(1,n_z);
y = zeros(1,n_z);
step_z = Z/n_z;
z = linspace(-Z/2+step_z/2,Z/2-step_z/2,n_z);
sample=[x(:),y(:),z(:)]'; % coordinate of the sampling points


end