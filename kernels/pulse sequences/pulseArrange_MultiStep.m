% rearrange the data structure of pulse, transform the nuclei based pulse
% data to voxel based pulse data
% Syntax:
%
% 			[amplitudes,pulse_dt] = pulseArrange_MultiStep(pulse)
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
%     	   amplitudes    - 1*N cell, each cell is a cell array indicating the
%     	                  pulse amplitudes on one voxel
%
%
% Mengjia He, 2022.11.15

function amplitudes = pulseArrange_MultiStep(pulse)

% extract nuclei
nucleiField = pulse.nucleiField;
numIsotope = numel(nucleiField);
numVox = size(pulse.(nucleiField{1}),2);

% prelocate results
amplitudes = cell(1,numVox);

parfor k = 1:numVox
    amplitudes{k} = cell(1,2*numIsotope);
end


for q = 1:numIsotope    % nuclei loop

    pulse_temp = pulse.(nucleiField{q});
    
    % calculate pulse amplitude
    parfor k = 1:numVox      % voxel loop
        amplitudes{k}{2*q-1} = transpose(real(pulse_temp(:,k))); % x control on voxel k
        amplitudes{k}{2*q} =transpose(imag(pulse_temp(:,k)));       % y control on voxel k
    end

end
end

