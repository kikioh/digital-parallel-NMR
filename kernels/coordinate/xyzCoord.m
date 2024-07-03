% Script for giving the xyz coordinate of cylinder sample,suppose z axis as the symmetry axis
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

function [sample, vol_factor, num_ensemble] = xyzCoord(R,Z,n_r,n_phi,n_z)
% R = 5;n_r = 5;n_phi = 4; Z = 5; n_z = 5;
num_ensemble = n_r*n_phi*n_z;
vol_factor = zeros(1,n_r*n_phi);

step_r = R/n_r;
step_phi = 2*pi/n_phi;
step_z = Z/n_z;
x = zeros(1,n_r*n_phi);
y = zeros(1,n_r*n_phi);
i = 1;
for r = linspace(step_r/2,R-step_r/2,n_r)
    for phi = linspace(0,2*pi-step_phi,n_phi)
        x(i) = r*cos(phi);
        y(i) = r*sin(phi);
        vol_factor(i) = ((r+step_r/2)^2-(r-step_r/2)^2)/R^2/n_phi;
        i = i + 1;
    end
end

z = linspace(-Z/2+step_z/2,Z/2-step_z/2,n_z);

[~,x] = meshgrid(z,x);
[z,y] = meshgrid(z,y);
sample=[x(:),y(:),z(:)]'; % coordinate of the sampling points
vol_factor = repmat(vol_factor,1,n_z)/n_z;
% num_ensemble = length(sample(1,:)); % number of points in space domain

end