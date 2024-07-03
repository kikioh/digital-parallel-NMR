% plot pulse sequences with complex waveform input
% Syntax:
%
% 			PulsePlot_ap2(waveform,pulse_dt,boundEff)
% Parameters: 
%                      
%		   waveform			- 1* N complex vector, gives the excitation
%		                        waveform		   
%          pulse_dt	        - 1*N number vector, give the excitation tiem
%                               in each slice
%		   boundEff		    - optional number, give upperband and lower band
%
% Mengjia He, 2023.02.10

function PulsePlot_ap2(waveform,pulse_dt,plotname,pulseName,bound)

if ~exist('bound','var')
	bound = 1.2;
end

if ~exist('pulseName','var')
	pulseName = 'original';
end

% Build the time axis
t_axis=[0 cumsum(pulse_dt)];

% prapare waveform
waveform=[waveform waveform(:,end)];

% set default linewidth
% set(0,'DefaultLineLineWidth',4);
lw = 0.5;
% Plot waveform,Piecewise-constant
xmax = sum(pulse_dt);
% Axis limits


% plot amplitude
yyaxis left;
ax = gca;
switch pulseName
    case  'original'
		stairs(t_axis'*1e3,abs(waveform),'Color',[0 0.4470 0.7410],'linewidth',lw);
		ax.YColor = [0 0.4470 0.7410];

	case  'ocPulse'
		% oc pulse
		stairs(t_axis'*1e3,abs(waveform),'Color',[16,39,60]/255,'linewidth',lw);
		ax.YColor = [16,39,60]/255;

	case  'cpTerm'
		% compensation term
		stairs(t_axis'*1e3,abs(waveform),'Color',[108,50,10]/255,'linewidth',lw);
		ax.YColor = [108,50,10]/255;

	case  'cpPulse'
		% cooperative pulse
		stairs(t_axis'*1e3,abs(waveform),'Color',[36,78,30]/255,'linewidth',lw);
		ax.YColor = [36,78,30]/255;
end

% ylabel('amplitude');
xlabel('time, ms');
set(gca,'xlim',[0 xmax]*1e3,'ylim',[0 bound]);

% plot phase
yyaxis right;
ax = gca;
switch pulseName
    case  'original'
		stairs(t_axis'*1e3,angle(waveform),'Color',[0.8500 0.3250 0.0980],'linewidth',lw);
		ax.YColor = [0.8500 0.3250 0.0980];

	case  'ocPulse'
		% oc pulse
		stairs(t_axis'*1e3,angle(waveform),'Color',[146,188,226]/255,'linewidth',lw);
		ax.YColor = [146,188,226]/255;

	case  'cpTerm'
		% compensation term
		stairs(t_axis'*1e3,angle(waveform),'Color',[241,158,101]/255,'linewidth',lw);
		ax.YColor = [241,158,101]/255;

	case  'cpPulse'
		% cooperative pulse
		stairs(t_axis'*1e3,angle(waveform),'Color',[161,217,154]/255,'linewidth',lw);
		ax.YColor = [161,217,154]/255;
end
set(gca,'ylim',[-pi pi]);
set(gca,'Ytick',[-pi 0 pi],'YTickLabel',{'-\pi','0','\pi'});

% Set fonts
grid off;
% title(plotname,'FontWeight','normal');
set(gca,'FontSize',13,'FontName','Arial','linewidth',lw);
end

% function grumble(waveform)
% if (~isnumeric(waveform))||(~isreal(waveform))
    % error('waveform must be a real numerical array.');
% end
% end