% plot transfer fidelity of pulse
%
% Mengjia He， 2024.01.10

function plotFidelity(fig,x,y,fidelity)
num = numel(fidelity);
fig.Position = [200 100 300 400];
for m = 1:num   % sample loop
    z = transpose(real(fidelity{m}));
    subplot(num,1,m);
    imagesc(x/1e3,y/1e3,z);
    colormap(hmj_cmap('coolwarm'));
    colorbar;
    clim([0.95 1]);
    xlabel('\nu_0, kHz');
    ylabel('\nu_1, kHz');
    set(gca,'YDir','normal');
    title(['$\overline{\eta}=' num2str(mean(mean(z))) '$'], 'Interpreter', 'latex');
end
end