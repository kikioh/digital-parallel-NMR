% analyse the spectrum of single pulse

% Mengjia He, 2022.08.10

clearvars;
clc;

% pulse parameters
freq0 = 500e6;                  % spectrometer frequency, Hz
time_dur = 20e-6;               % pulse length
spec_width = 500;               % full width of the spectrum,ppm


% fft parameters
n_pos = 100;
delta = time_dur/n_pos;
fs = 1/delta;
pulse = ones(1,n_pos);       % number of fft

% Plot the spectrum
figure();
n_fft = n_pos*50;
y_spec=abs(fftshift(fft(pulse,n_fft)));
freq_axis=linspace(-fs/2,fs/2-fs/n_fft,n_fft)/freq0*1e6;
plot(freq_axis,y_spec/max(y_spec),'LineWidth',2);
xlim([-0.5,0.5]*spec_width);
set(gca, 'LineWidth',1.3,'FontName','Arial','Fontsize',14);
xlabel('Frequency shift [ppm]');
ylabel('Amplitude');
% title('Pulse spectrum');
grid on;
% hline = refline(0,0.90);
% hline.Color = 'k';