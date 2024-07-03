% plot the 1d parallel NMR signals
%
% Syntax:
%
% 			plot_paraSpec(signals,parameters)
%
% Parameters:
%
%          signals 		- 1*n cell, time domian signals, each element is
%                         the 1d signal form one channel
%
%		   parameters	- struct
%                           offset, frequency offset
%                           sweep, sampling frequency, Hz
%                           npoints, sample points in time domain
%                           zerofill, zerofill points in FFT
%                           axisType, Hz or ppm
%                           refFrequency, necessary if axisType=ppm
%							x_Ubound, maxmium frequency value in the plot
%							color, indicate the line color in the plot
%
% Outputs:
%
%    this function produces a figure
%
% Mengjia He, 2024.01.04

function plot_paraSpec(signals,parameters)

% set the default axis Type as ppm
if ~isfield(parameters,'axisType') parameters.axisType = 'ppm'; end

% set the default axis Type as ppm
if ~isfield(parameters,'refFrequency') parameters.refFrequency = 500e6; end

% set the default axis Type as ppm
if ~isfield(parameters,'color') parameters.color = 'matlab1'; end

% set the default x axis limit
if ~isfield(parameters,'x_Ubound') 

	if strcmp(parameters.axisType,'ppm') 
		parameters.x_Ubound= parameters.sweep/2/parameters.refFrequency*1e6;
	else
		parameters.x_Ubound= parameters.sweep/2;
	end
	parameters.x_Ubound = ceil(parameters.x_Ubound);
end
x_Ubound = parameters.x_Ubound;

% number of channels
num = numel(signals);

% Fouier Transform
paraSpec = cell(1,num);
for m = 1:num
   if m == 1
        [freq_axis,paraSpec{m}] = signalFFT(signals{1},parameters);
   else
       [~,paraSpec{m}] = signalFFT(signals{m},parameters);
   end
end


% Visulation
fig1 = figure();
fig1.Position = [100 50 300 600];
tiledlayout(num,1,'TileSpacing',"compact");
for m =1:num
    nexttile;
    plot(freq_axis,abs(paraSpec{m}),'LineWidth',0.5,'color',lineColor(parameters.color)); hold on;
    axis tight;
    set(gca, 'XDir','reverse');
    xlim([0,x_Ubound]);
    set(gca,'ytick',[]);
    set(gca,'Xticklabel',[]);
    box off;
    set(gca, 'TickDir','none');
    set(get(gca,'YAxis'),'visible','off');
end
xlabel('frequency, ppm');
set(gca,'FontSize',13,'FontName','Arial');
set(gca,'xtick',0:x_Ubound/5:x_Ubound, 'XTickLabel', 0:x_Ubound/5:x_Ubound);
end