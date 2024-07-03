% analyse the spectrum of pulse sequence

% Mengjia He, 2022.08.10

clearvars;
close all;
clc;


% pulse parameters
freq0 = 500e6;                  % spectrometer frequency, Hz
% time_dur = 20e-6;               % pulse dur
steps = 200;
spec_width = 500;               % full width of the spectrum,ppm
pulse =load('SL7_hetero.mat').pulse_shape(1,:);
time_dur = load('SL7_hetero.mat').pulse_dt(1);

pulse_temp = zeros(2,size(pulse,2));
pulse_temp(1,:) = real(exp(1i*pulse));
pulse_temp(2,:) = imag(exp(1i*pulse));
pulse = pulse_temp;

% plot time profile
time = time_dur*linspace(0,steps-1,steps);
stairs(time,pulse(1,:),'LineWidth',2); hold on;
stairs(time,pulse(2,:),'LineWidth',2); 
legend('x control','y control');
xlim([0,time_dur*steps]);
set(gca, 'LineWidth',1.3,'FontName','Arial','Fontsize',14);
xlabel('time [s]');
ylabel('Amplitude');

% fft parameters
n_pos = 5;
pulse = pulse(1,:) + 1i * pulse(2,:);
pulse_sampled = repelem(pulse,n_pos);
delta = time_dur/n_pos;
fs = 1/delta;


% Plot the spectrum
figure();
n_fft = n_pos*steps*55;
y_spec=abs(fftshift(fft(pulse,n_fft)));
freq_axis=linspace(-fs/2,fs/2-fs/n_fft,n_fft)/freq0*1e6;
plot(freq_axis,y_spec/max(y_spec),'LineWidth',2);
xlim([-0.1,0.1]*spec_width);
set(gca, 'LineWidth',1.3,'FontName','Arial','Fontsize',14);
xlabel('Frequency shift [ppm]');
ylabel('Amplitude');
title('Pulse spectrum');
grid on;
