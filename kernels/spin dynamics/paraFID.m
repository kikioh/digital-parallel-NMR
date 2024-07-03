% hard pulse and acquication flow for parallel NMR simulation
%
% Syntax:
%
%          FID = paraFID(num,compSample,spin_system,Bp,Bm,parameters)
%
% Parameters:
%
%           num             - channel number
%
%           compsample      - sample struct created by createComposite.m
%
%           Bp              - cell array, transmitt B field, created by
%                             Bparray.m
%           Bm              - cell array, transmitt B field, created by
%                             Bmarray.m
%
%           spin_system     - spin_system created by Spinach housekeeping
%
%           parameters      - acqisition parameters struct
% Outputs:
%
%           FID             - calculated FID from multiple sample to
%                             multiple coils
%
% Mengjia He, 2024.01.04

function FID = paraFID(num,compSample,spin_system,Bp,Bm,parameters)

[sample,H,opts,rho,iso] = disComposite(compSample);

% experiment nuclei
nuclei = sample.nuclei;
nucleiField = sample.nucleiField;
numIsotope = numel(sample.nuclei);

% spin state
rho_init = rho.z; rho_detec = rho.detec;

% channels
channel = iso.channel; isotopes = iso.isotopes; 

% controls
Lx = opts.Lx; Ly = opts.Ly;

% volume factors
volFactor = sample.volFactor; numVox = sample.numVox;


if numIsotope == 1

    % prelocate FID
    FID = cell(num,num);
    time_step = 1/parameters.sweep;
    npoints = parameters.npoints;

    % sample and coil array loop
    for m = 1:num % coil loop
        for n = 1:num % sample loop

            % select sample and B1- field
            rho_init_temp = rho_init{n}; Lx_temp = Lx{n}; Ly_temp = Ly{n};

            % prepare hard pulse
            B1r = Bm{m,n}; B1t = Bp{n}; pulse = BpToPulse(B1t);

            % eliminate the influence of matrix dimension in inner product
            iso_coeff = sqrt(sum(count(isotopes,sample.nuclei{1}))/sum(count(channel{n},sample.nuclei{1})));

            % prelocate fid
            fid_temp = zeros([parameters.npoints 1],'like',1i);

            parfor k=1:numVox % voxel loop
                % pulse parameters
                Cx = pulse{k}(1); Cy = pulse{k}(2); time_grid = pulse{k}(3);

                % Pulse execution
                rho=shaped_pulse_xy(spin_system,H{n,k},{Lx_temp,Ly_temp},{Cx,Cy},...
                    time_grid,rho_init_temp);

                % evolution execution
                fid_temp = fid_temp + volFactor(k) * B1r(k) * iso_coeff * evolution(...
                    spin_system,H{n,k},rho_detec,rho,time_step,npoints-1,'observable');
            end

            FID{m,n} = fid_temp;
        end
    end

else

    % apply pulse sequence
    rho = cell(num,sample.numVox);
    operator = cell(1,2*numIsotope);
    pulse = struct;
    for n = 1:num               % sample loop

        for q = 1:numIsotope    % isotope loop

            % select sample and operators
            rho_init_temp = rho_init{n};
            operator{2*q-1} = opts.Lx.(nucleiField{q}){n};        % x control
            operator{2*q} = opts.Ly.(nucleiField{q}){n};          % y control

            % calculate pulse
            pulse.(nucleiField{q}) = BpToPulse(Bp.(nucleiField{q}){n},nuclei{q});
        end

        % re-arrange pulse data
        pulse.nucleiField = nucleiField;
        [pulse_amp,pulse_dt] = pulseArrange(pulse);

        % apply pulse
        parfor k=1:numVox % voxel loop

            % Pulse execution
            rho{n,k}=shaped_pulse_xy(spin_system,H{n,k},operator,pulse_amp{k},...
                pulse_dt{k},rho_init_temp);
        end
    end
    
  
    npoints = parameters.npoints;
    time_step = 1/parameters.sweep; 

    % detect signal
    FID = struct;
    for q = 1:numIsotope % nuclei (frequency) loop

        fid_cell = cell(num,num);
        for m = 1:num % coil loop
            for n = 1:num % sample loop

                % select coil and B- field
                coil_temp = rho_detec.(sample.nucleiField{q}).p;
                B1r = Bm.(nucleiField{q}){m,n};

                % eliminate the influence of matrix dimension in inner product
                iso_coeff = sqrt(sum(count(isotopes,nuclei{q}))/sum(count(channel{n},nuclei{q})));

                % prelocate fid
                fid_temp = zeros([parameters.npoints 1]);

                % acquisition parameters for nuclei q
                step_temp = time_step/ sweepFreq(nuclei{q});
                parfor k=1:sample.numVox % voxel loop

                    % evolution execution
                    fid_temp = fid_temp + volFactor(k) * B1r(k) * iso_coeff * evolution(...
                        spin_system,H{n,k},coil_temp,rho{n,k},step_temp,npoints-1,'observable');
                end

                fid_cell{m,n} = fid_temp;
            end
        end
        FID.(nucleiField{q}) = fid_cell;
    end

end