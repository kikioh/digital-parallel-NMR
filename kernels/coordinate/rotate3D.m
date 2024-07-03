% Script to rotate a vector in 3D space with a gernal pulse
% Syntax:
%                 RotMat = rotate3D(beta,phi)
%
% Parameters:
%
%    beta          -  flip angle of the pulse, rad
%
%    phi           -  phase of the pulse, rad
%
% Outputs:
%
%    RotateMatrix        -  Rotate matrix, which can be used to spin state
%                           i.e., [Lx;Ly;Lz] = RotMat * [Lx;Ly;Lz]

function RotMat = rotate3D(beta,phi)

Rz_phi = [cos(phi), -sin(phi), 0;        % Rotate phi along z axis
          sin(phi), cos(phi),  0;
          0,        0,         1];
Rx_beta = [1, 0,         0;              % Rotate beta along x axis
           0, cos(beta), -sin(beta);
           0, sin(beta), cos(beta)];

Rz_mius_phi = [cos(-phi), -sin(-phi), 0; % Rotate -phi along z axis
               sin(-phi), cos(-phi),  0;
               0,         0,          1];
RotMat = Rz_phi * Rx_beta * Rz_mius_phi;
end

