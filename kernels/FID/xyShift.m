% compare the spectrum from same sample but with different SNR
% 
% Note: shift x and y value and plot in one figure
%
% Mengjia He, 2024.01.01

clearvars;
close all;
clc;

% Set parameters
frequencies = [10, 20, 30];  % Frequencies of the sine waves
amplitudes = [1, 0.5, 0.2];  % Amplitudes of the sine waves
sampling_rate = 500;  % Sampling rate in Hz
duration = 5;  % Duration of the signal in seconds

% Generate the signal
t = 0:1/sampling_rate:duration-1/sampling_rate;
signal = zeros(size(t));

for i = 1:length(frequencies)
    signal = signal + amplitudes(i) * exp(2i * pi * frequencies(i) * t);
end

% line boardening
signal = signal .* exp(-0.1* t);

% Perform FFT and plot the frequency spectrum
n = length(signal);
fft_values = fftshift(fft(signal));
ax_freq=linspace(-sampling_rate/2,sampling_rate/2,n);

figure;
hold on;
plot(ax_freq, abs(fft_values));
% shift x and y
numShift = 5;
x0 = ax_freq;   xShift = 1;
y0 = abs(fft_values);   yShift = 100;
x = zeros(numShift,numel(x0));
y = zeros(numShift,numel(y0));
for m = 1:numShift
    x(m,:) = x0 + xShift*m;
    y(m,:) = y0 + yShift*m;
    plot(x(m,:), y(m,:)); 
end
hold off;
title('FFT of the Signal');
xlabel('Frequency (Hz)');
ylabel('Amplitude Spectrum');
grid on;
xlim([0,50]);
set(gca, 'XDir', 'reverse');
