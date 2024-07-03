% Script for giving the xyz coordinate of XOZ face inside a cylinder sample 
% Syntax 
% sample = xyzCoordinate(R,Z,n_x,n_z)
% Arguments
% R:     the maxmium radius of cylinderal sample
% n_x:   the number of points along r direction
% Z:     the length of cylinderal sample
% n_z    the number of points along z direction
% Outputs
% sample:       3*n array, coordinate of the sampling points
% Volume_voxel: 1*n vector, the volume of each voxel, divided by total Volume
% x,z: meshgrid matrix of sample points
% Mengjia He 2022.05.10

function [sample, Vol_factor,n_pos,x,z] = xyzCoordFace(R,Z,n_x,n_z)
% R = 5;n_r = 5;n_phi = 4; Z = 5; n_z = 5;
Volume_voxel = zeros(1,n_x);

step_x = 2*R/n_x;
step_z = Z/n_z;
i = 1;
for r = linspace(-R+step_x/2,R-step_x/2,n_x)
    if r > 0
        Volume_voxel(i) = ((r+step_x/2)^2-(r-step_x/2)^2)/R^2/2;
    elseif r < 0
        Volume_voxel(i) = ((r-step_x/2)^2-(r+step_x/2)^2)/R^2/2;
    else
        Volume_voxel(i) = (step_x)^2/R^2;
    end
    i = i + 1;
end

x = linspace(-R+step_x/2,R-step_x/2,n_x);
z = linspace(-Z/2+step_z/2,Z/2-step_z/2,n_z);

[z,x] = meshgrid(z,x);
y = zeros(size(x));
sample=[x(:),y(:),z(:)]'; % coordinate of the sampling points
Vol_factor = repmat(Volume_voxel,1,n_z)/n_z;
n_pos = length(Vol_factor);
end