% transfer amplitude-phase control to Cartesian waveform
%
% Mengjia He, 2024.02.29

function [Cx,Cy] = Ap2Xy(power_level,pulse_shape)

numChn = size(pulse_shape,1);

Cx = cell(1,numChn);
Cy = cell(1,numChn);
for m = 1:numChn
    Cx{m} = power_level(m)*cos(pulse_shape(m,:));
    Cy{m} = power_level(m)*sin(pulse_shape(m,:));

end
end

