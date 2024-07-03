% 1D fft transform of given signal vector
% Syntax:
%
% 			[freqAxis,yAxis] = signalFFT(signal,parameters)
%
% Parameters:
%
%          signal 		- time domian signal, vector
%		   parameters	- struct
%                           offset, frequency offset
%                           sweep, sampling frequency, Hz
%                           npoints, sample points in time domain
%                           zerofill, zerofill points in FFT
%                           axisType, Hz or ppm
%                           reference frequency, necessary if axisType=ppm
%
% Outputs:
%
%     	   freqAxis     - frequency, x axis value
%     	   yAxis        - y axis value, complex vector
%
% Mengjia He, 2022.11.04

function [freqAxis,yAxis] = signalFFT(signal,parameters)

% set the default axis Type as ppm
if ~isfield(parameters,'axisType') parameters.axisType = 'ppm'; end

% set the default reference Frequency as 500 MHz
if ~isfield(parameters,'refFrequency') parameters.refFrequency = 500e6; end

% Apodization
signal_temp=apodization(signal,'exp-1d',1);

% Fouier Transform
yAxis=fftshift(fft(signal_temp,parameters.zerofill));

% generate x axis
freqAxis = ft_axis(parameters.offset,parameters.sweep,parameters.zerofill);

if strcmp(parameters.axisType,'ppm') 
    freqAxis= freqAxis/parameters.refFrequency*1e6;
end

end

