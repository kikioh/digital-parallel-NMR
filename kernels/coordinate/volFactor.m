% Script for giving the xyz coordinate of cylinder sample,suppose z axis as the symmetry axis
% Syntax:
%
% 		volFactor= volFactor(nr,np,nz)
%
% Arguments:
%
% 		nr -    number of points along r direction
% 		np -    number of points along phi direction
% 		nz -    number of points along z direction
%
% Outputs:
%
% 	    Vol_factor  -	1*n vector, the volume of each voxel, divided by total Volume
%
% Mengjia He 2024.01.04

function volFactor= volFactor(nr,np,nz)

step_r = 1/nr; step_phi = 2*pi/np;
x = zeros(1,nr*np); y = zeros(1,nr*np);

i = 1; volFactor = zeros(1,nr*np);
for r = linspace(step_r/2,1-step_r/2,nr)
    for phi = linspace(0,2*pi-step_phi,np)
        x(i) = r*cos(phi);
        y(i) = r*sin(phi);
        volFactor(i) = ((r+step_r/2)^2-(r-step_r/2)^2)/1^2/np;
        i = i + 1;
    end
end

volFactor = repmat(volFactor,1,nz)/nz;

end
