% simulation for n-channel one nuclei NMR 
% give independent pulse sequences, detected by independent coil;
% 
% note: prapare the comsol simulated files before running
%
% Calculation time: minutes
%
% Mengjia He, 2024.01.04

clearvars; close all; clc;

% define channel and nuclei 
num = 4;                                     % number of sample (coil)
nuclei = {'1H'};                             % experiment nuclei

% create sample for field import                               
sample=createSample(num, nuclei,'RF');

% define coil array;
coil=createCoil(num,sample);

% comsol RF solution
comsol = comsolSolInf(num,nuclei,'solenoid');

% import B0 field
model_DC=mphopen(comsol.DC.fileName); 
B0 = B0Array(coil,sample,model_DC,comsol.DC);

% manual shimming
B0 = zeroShim(B0,coil.B0);

% import RF simulation
model_RF=mphopen(comsol.RF.fileName);

% tunning and matching
coil = SMcomsol(coil,model_RF,comsol.RF);

% chain Gain 
gain = gainArray(coil.Z0,coil.SC,coil.SM);

% calculate B1 field
Bp = BpArray(coil,sample,model_RF,comsol.RF);
Bm = BmArray(coil,sample,model_RF,comsol.RF);

%% Spinach simulation

% isotopes
[sys,inter,iso]=createSpin_Nchn(num,nuclei);

% magnet for Hamiltonian
sys.magnet = 1;                       

% basis set
bas.formalism='sphten-liouv';
bas.approximation='IK-2';
bas.space_level=1;
bas.connectivity='scalar_couplings';

% Spinach housekeeping
spin_system=create(sys,inter);
spin_system=basis(spin_system,bas);

% set up the spin state
rho = paraRho(num,sample,spin_system,iso);

% get control operators
opts = paraOpts(num,sample,spin_system,iso);

% drift Hamiltonian for the ensemble
H=paraH(num,sample,spin_system,B0,coil);

% acquisition parameters
parameters.offset = 0;      % frequency offset
parameters.sweep=1e4;       % Sweep frequency, Hz
parameters.npoints=1024;    % Sample points
parameters.zerofill=1024;   % zerofill points in FFT

% FID calculation
compSample = createComposite(sample,H,opts,rho,iso);
fid = paraFID(num,compSample,spin_system,Bp,Bm,parameters);

% signal chain calculation
[~,~,~,total] = signalArray(fid,coil,gain);

% visulation
plot_paraSpec(total,parameters);
