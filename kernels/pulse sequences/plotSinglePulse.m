% plot single pulse

% Mengjia He, 2022.08.10

clearvars;
clc;
x = linspace(0,30,4)*2;
y = [0,1,0,0];
stairs(x,y,'LineWidth',2);
xlim([0,30]*2);
set(gca, 'LineWidth',1.3,'FontName','Arial','Fontsize',14);
xlabel('time [us]');
ylabel('Amplitude');
% title('single pulse');
