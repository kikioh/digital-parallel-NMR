% rearrange the data structure of pulse, transform the nuclei based pulse
% data to voxel based pulse data
% Syntax:
%
% 			[pulse_amp,pulse_dt] = pulseArrange(pulse)
%
% Parameters:
%
%          pulse 		- structure
%                      pulse.nucleiField, cell array, give the nuclei array 
%                      pulse.X - the pulse on nuclei X, for N voxels
%                      pulse.Y - the pulse on nuclei Y, for N voxels
%                      ...
%
% Outputs:
%
%     	   pulse_amp    - 1*N cell, each cell is a cell array indicating the
%     	                  pulse amplitudes on one voxel
%
%     	   pulse_dt      - 1*N cell, each cell is a number (array) indicating the
%     	                  pulse duration on one voxel
%
% Mengjia He, 2022.11.15

function [pulse_amp,pulse_dt] = pulseArrange(pulse)

% extract nuclei
nucleiField = pulse.nucleiField;
numIsotope = numel(nucleiField);
numVox = numel(pulse.(nucleiField{1}));

% prelocate results
pulse_amp = cell(1,numVox);
pulse_dt  = cell(1,numVox);
parfor k = 1:numVox
    pulse_amp{k} = cell(1,2*numIsotope);
end


for q = 1:numIsotope    % nuclei loop
    pulse_temp = pulse.(nucleiField{q});
    
    % calculate pulse amplitude
    parfor k = 1:numVox      % voxel loop
        pulse_amp{k}{2*q-1} = pulse_temp{k}(1,:);     % x control on voxel k
        pulse_amp{k}{2*q} = pulse_temp{k}(2,:);       % y control on voxel k

        % calculate pulse duration in the last nuclei loop
        if (q == numIsotope) && (numel(pulse_temp{k}) == 3)
            pulse_dt{k} = pulse_temp{k}(3);         % pulse duration
		else
			pulse_dt{k} = 0;
        end
    end

end
end

