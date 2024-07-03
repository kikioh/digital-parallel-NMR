% pulse compensation for 2 channels, single nuclei, apply independent
% pulse sequences on each channel, detected by 2 independent coil
%
% coil: solenoid array
%
% optimal control pulse is robust to resonance offset and B1 power level
%
% Calculation time: minutes
%
% Mengjia He, 2024.01.05

clearvars; clc; close all;

%% import B fields

% define channel and nuclei
num = 2;                                    % number of sample (coil)
nuclei = {'1H'};                            % experiment nuclei

% define sample division
sample=createSample(num, nuclei,'RF');

% define coil array;
coil=createCoil(num);

% comsol RF solution
comsol = comsolSolInf(num,nuclei,'solenoid');

% import B0 field
model_DC=mphopen(comsol.DC.fileName);
B0 = B0Array(coil,sample,model_DC,comsol.DC);

% manual shimming
B0 = zeroShim(B0,coil.B0,'ideal');

% import B1 field
model_RF=mphopen(comsol.RF.fileName);

% tunning and matching
coil = SMcomsol(coil,model_RF,comsol.RF);

% chain Gain
[gain,Fmatrix] = gainArray(coil.Z0,coil.SC,coil.SM);

% import B1 field
[Bp.import,gFunction]= BpArray(coil,sample,model_RF,comsol.RF);
Bm = BmArray(coil,sample,model_RF,comsol.RF);

% drop B1 phase for optimal control
Bp.import = zeroPhaseShim(Bp.import);


%% parallel FID acquisition

% isotopes
[sys,inter,iso]=createSpin_Nchn(num,nuclei,'random');

% magnet
sys.magnet = 1;                                 % magnet for Hamiltonian

% Basis set
bas.formalism='sphten-liouv';
bas.connectivity='scalar_couplings';
bas.approximation='IK-2';
bas.space_level=1;
tols.prox_cutoff = 5;

% Spinach housekeeping
spin_system=create(sys,inter);
spin_system=basis(spin_system,bas);

% set up the spin state
rho = paraRho(num,sample,spin_system,iso);

% get control operators
opts = paraOpts(num,sample,spin_system,iso);

% drift Hamiltonian for the ensemble
H = paraH(num,sample,spin_system,B0,coil);

% acquisition parameters
parameters.offset = 0;      % frequency offset
parameters.sweep=1e4;       % Sweep frequency, Hz
parameters.npoints=4096;    % Sample points
parameters.zerofill=4096;   % zerofill points in FFT

% FID calculation
compSample = createComposite(sample,H,opts,rho,iso);
fid = paraFID(num,compSample,spin_system,Bp.import,Bm,parameters);

%% coupling identification

% define noise level
noise_level = -50;

% signal acquisition
[~,~,~,total,SNR] = signalArray(fid,coil,gain,noise_level);

%plot mixed signal
parameters.color = 'grey';
plot_paraSpec(total,parameters);

% coupling matrix estimation
mixedSignal = cell2mat(total);
We=sobi_bench(mixedSignal);

% plot recovered signal
Y = We * mixedSignal;
Y = mat2cell(Y, ones(1, size(Y, 1)), size(Y, 2));
parameters.color = 'matlab1';
plot_paraSpec(Y,parameters);

% estimated gain matrix
gainEst = inv(We);
gainEst = gainEst/ norm(gainEst,'fro');

% check estimation error
CA  = 1/num*norm(eye(num)-inv(gainEst) * gain/norm(gain,'fro'),1);

%% optimal control
numP = 100;
numBW = 20;
BW = 5e3;
OffsetSeq = linspace(-BW/2,BW/2,numBW);

% redifine spin system
[sys,inter,iso]=createSpin_Nchn(num,nuclei,'optCon');
sys.magnet = 1;                                 % magnet for Hamiltonian

% Spinach housekeeping
spin_system=create(sys,inter);
spin_system=basis(spin_system,bas);

% set up the spin state
rho = paraRho(num,sample,spin_system,iso);

% get control operators
opts = paraOpts(num,sample,spin_system,iso);

% drift Hamiltonian for the ensemble
H = paraH(num,sample,spin_system,B0,coil);

% sort the drifts and B1 with asend B1 amplitude
BpSort = cell(1,num);   HSort = cell(size(H));
for m = 1:num
   [BpSort{m},index] = sort(Bp.import{m},'ComparisonMethod','abs');
   HSort(m,:) = H(m,index);
end

% prelocate control waveform
pulse_phase = cell(1,num);
for m=1:num     % sample loop

    control.drifts=cellfun(@(x) {x},HSort(m,:),'UniformOutput',false); % Drifts

    % Power levels for the ensemble
    control.pwr_levels=abs(spin(nuclei{1})) * abs(BpSort{m});  
    control.phase_levels = angle(BpSort{m});

    % Define control parameters
    control.pulse_dt=20e-6*ones(1,numP);            % pulse duration
    control.operators = {opts.Lx{m},opts.Ly{m}};    % control operators
    control.rho_init=rho.z(m);                      % Starting state
    control.rho_targ=rho.x(m);                      % Destination state
    control.method='lbfgs';                         % Optimisation method
    control.max_iter=200;                           % Maximum iterations
    control.tol_f = 0.995;                          % minimum fidelity
    control.penalties={'SNS'};                      % Penalty types
    control.p_weights=100;                          % Penalty weights
    control.amplitudes=ones(1,numP);                % Amplitude profile
    control.freeze=zeros(1,numP);                   % Nothing is frozen
    control.offsets={OffsetSeq};                    % Offsets, Hz
    control.off_ops={opts.Lz{m}};                   % Offset operator
    control.ens_corrs={'power_drift'};              % Align power and drift
    control.parallel='ensemble';                    % parallelisation mode

    % % Plotting options
    % control.plotting={'xy_controls','robustness'};

    % Spinach housekeeping
    spin_system=optimcon(spin_system,control);

    % Waveform guess
    guess=randn(1,numP) + pi;

    % Run the optimization
    pulse_phase{m}=fminnewton(spin_system,@grape_phase,guess);

end

%% pulse compensation

% calculate eigen excitation profile
ap_controls = cell(1,num); eigen = zeros(num,numP);
for m = 1:num
    ap_controls{m} = mean(BpSort{m})*abs(spin(nuclei{1}))*exp(1i*pulse_phase{m}); 
    eigen(m,:) = ap_controls{m}/(abs(spin(nuclei{1}))*Fmatrix(m,m)*mean(gFunction{m}(m,:)));
end

% cooperative excitation profile
coopExcite = inv(gainEst)*diag(diag(gainEst))*eigen;

% recalculate B+ field
I_cp = IcArray(coil.Z0, coil.SC, coil.SM, coopExcite);
I_rf = IcArray(coil.Z0, coil.SC, coil.SM, eigen);

% time * space control values
Bp.cp = cell(1,num); Bp.rf = cell(1,num);
for m = 1:num
    Bp.cp{m} = transpose(I_cp) * gFunction{m};
    Bp.rf{m} = transpose(I_rf) * gFunction{m};
end

% apply pulse
rho_oc = cell(num,numBW,sample.numVox);
rho_rf = cell(num,numBW,sample.numVox);
rho_cp = cell(num,numBW,sample.numVox); 

for m = 1:num           % sample loop
     
     
    pulse_oc = abs(spin(nuclei{1})) * transpose(BpSort{m}) * exp(1i*pulse_phase{m});
    pulse_rf = abs(spin(nuclei{1})) * transpose(Bp.rf{m}); 
    pulse_cp = abs(spin(nuclei{1})) * transpose(Bp.cp{m});  
    for s = 1:numBW
        OffsetAmp = 2*pi*OffsetSeq(s)* ones(1,numP);
        parfor k=1:sample.numVox   % voxel loop

            amp_oc = {real(pulse_oc(k,:)),imag(pulse_oc(k,:))};
            amp_rf = {real(pulse_rf(k,:)),imag(pulse_rf(k,:))};
            amp_cp = {real(pulse_cp(k,:)),imag(pulse_cp(k,:))};

             % apply oc pulse
            rho_oc{m,s,k}=shaped_pulse_xy(spin_system,H{m,k},{opts.Lx{m},opts.Ly{m},opts.Lz{m}},...
                [amp_oc,{OffsetAmp}],control.pulse_dt,rho.z{m});

            % apply rf pulse
            rho_rf{m,s,k}=shaped_pulse_xy(spin_system,H{m,k},{opts.Lx{m},opts.Ly{m},opts.Lz{m}},...
                [amp_rf,{OffsetAmp}],control.pulse_dt,rho.z{m});
 
            % apply cp pulse
            rho_cp{m,s,k}=shaped_pulse_xy(spin_system,H{m,k},{opts.Lx{m},opts.Ly{m},opts.Lz{m}},...
                [amp_cp,{OffsetAmp}],control.pulse_dt,rho.z{m});
        end
    end
end

%% calculate transfer efficiency
fid_oc = cell(1,num); 
fid_rf = cell(1,num);
fid_cp = cell(1,num);
for m = 1:num   % sample loop 
    for s = 1:numBW
        for k = 1:sample.numVox     % voxel loop

            fid_oc{m}(s,k) = trace(rho.x{m}'* rho_oc{m,s,k});

            fid_rf{m}(s,k) = trace(rho.x{m}'* rho_rf{m,s,k});

            fid_cp{m}(s,k) = trace(rho.x{m}'* rho_cp{m,s,k});
        end
    end
end


%% plot fidelity
x_axis = OffsetSeq;
y_axis = abs(spin('1H'))*abs(BpSort{m})/(2*pi);

% plot fidelity with OC pulse
fig = figure('Name','fidelity with OC pulse');
plotFidelity(fig,x_axis,y_axis,fid_oc);

% plot fidelity with RF pulse
fig = figure('Name','fidelity with RF pulse');
plotFidelity(fig,x_axis,y_axis,fid_rf);

% plot fidelity with CP pulse
fig = figure('Name','fidelity with CP pulse');
plotFidelity(fig,x_axis,y_axis,fid_cp);
