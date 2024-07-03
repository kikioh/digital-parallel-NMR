close all;

% [spec_ph2, phc] = mrs_firstPHC(specS(2,:));

% [specX_ph2, phc] = mrs_firstPHC(specX(2,:));

% % phc0 = phc(1,1)*0.85;
% % phc1 = phc(1,2)*1.0;
% % np = size(specX,2);
% % phc01 = (phc0+phc1.*(1:np)/np); % linear phase
% % specX_ph2 = specX(2,:) .* exp(1i*phc01);
% % % spec_ph2 = specS(2,:) .* exp(1i*phc1);
% % 
% % plot(freq_axis,real(specX_ph2),'LineWidth',1.2);
% % ylim([-1,90]);
% % xlim([-10,10]);
% specS_ph(2,:) = spec_ph2;
% specX_ph(2,:) = specX_ph2;
% % baseline correction
% fig6 = figure;
% fig6.Position = [100 200 700 500];
% specS_bc_real = transpose(msbackadj(transpose(freq_axis),transpose(real(specS_ph)),'WindowSize',300,'StepSize',150));
% specS_bc_imag = transpose(msbackadj(transpose(freq_axis),transpose(imag(specS_ph)),'WindowSize',300,'StepSize',150));
% specS_bc = specS_bc_real + 1i * specS_bc_imag;
% 
% specX_bc_real = transpose(msbackadj(transpose(freq_axis),transpose(real(specX_ph)),'WindowSize',300,'StepSize',150));
% specX_bc_imag = transpose(msbackadj(transpose(freq_axis),transpose(imag(specX_ph)),'WindowSize',300,'StepSize',150));
% specX_bc = specX_bc_real + 1i * specX_bc_imag;
% 
% % for m = 1:num
% %     subplot(1,num,m);
% %%
% fig6 = figure;
% fig6.Position = [100 200 700 500];
% m =1;
%     plot(freq_axis,real(specX_bc(m,:)),'LineWidth',2,'color',lineColor('8')); hold on;
%     plot(freq_axis,real(specS_bc(m,:)),'LineWidth',1,'color',lineColor(num2str(m))); hold on;
%     xlim([-10,10]);
%     ylim([-1,90]);
%     xlabel('frequency, ppm');
% %     legend('orginal','splited');
%     xlabel('frequency, ppm','FontSize',20);
%     set(gca,'FontSize',20,'FontName','Arial','linewidth',1);
%     set(gca,'ytick',[]);
% end

[~,phc,~] = mrs_firstPHC(specS(1,:));
spec_ph = manualPHC(specS(1,:), phc(1)*1, phc(2)*0.75);
plot(freq_axis,real(spec_ph),'LineWidth',1,'color',lineColor(num2str(1)));
xlim([-8,0]);


