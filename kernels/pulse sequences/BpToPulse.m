% from B+ field to pulse sequences, for a hard pulse, wih space
% distribution
% Syntax:
%
%        pulse = BpToPulse(Bp,isotope)
%
% Parameters: 
%          
%       Bp          			- N*1 vector, B+ field of N voxels
%       isotope(optional)    	- string, spin isotope, like '1H'
%       duration(optional)    	- number, give pulse duration
%
% Outputs:
%
%    pulse   - N*1 cell, each cell element is 3 * npoints vector, indicate
%               Cx and Cy controls and time grids
%
% Mengjia He, 2022.09.01

function pulse = BpToPulse(Bp,isotope,duration)

% set up default isotope
if ~exist('isotope','var') isotope='1H'; end

% set up default pulse duration
if ~exist('duration','var') duration=20e-6; end

% number of voxels
num_vox = length(Bp);

% transform B+ field to amplitude and phase
amplitudes = 0.5 * abs(spin(isotope)) * abs(Bp);
phases = angle(Bp);

% Pulse calibration
integral=sum(amplitudes);
calibrate=(pi/2)*num_vox/(integral*duration);
amplitudes = amplitudes * calibrate;

% Pulse transformation from (A,phi) to (X,Y)
pulse = cell(num_vox,1);    % prelocate the pulse

for m = 1:length(Bp)    % voxel loop

    [Cx,Cy]=polar2cartesian(amplitudes(m),phases(m));
    pulse{m} = [Cx;Cy;duration];
end

end
