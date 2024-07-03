% discomposite the sample information fro parallel NMR simulation
%
% Mengjia He, 2024.01.04

function [sample,H,opts,rho,iso] = disComposite(compSample)


sample = compSample.sample;
H = compSample.H;
opts = compSample.opts;
rho = compSample.rho;
iso = compSample.iso;

end