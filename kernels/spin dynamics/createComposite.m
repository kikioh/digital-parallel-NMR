% create the composite sample information fro parallel NMR simulation
%
% Mengjia He, 2024.01.04

function compSample = createComposite(sample,H,opts,rho,iso)


compSample.sample = sample;
compSample.H = H;
compSample.opts = opts;
compSample.rho = rho;
compSample.iso = iso;

end