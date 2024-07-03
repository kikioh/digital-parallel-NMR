% calculate the Hamiltonian of parallel spin system
%
% Syntax:
%
%           H = paraH(num,sample,spin_system,B0,coil)
%
% Parameters:
%
%           num             - channel number
%
%           sample          - sample struct created by createSample.m
%
%           spin_system     - spin_system created by Spinach housekeeping
%
%           coil            - coil struct created by createCoil.m
%
%           B0              - cell array, B0 for N samples, calculated by
%                             B0Array.m
%
%           option          - 'inhomo' (default), or 'ideal' which ignore the B0
%                             inhomogeneity
% Outputs:
%
%            H              - cell array, hamiltonian for N samples
%
% Mengjia He, 2024.01.04

function H = paraH(num,sample,spin_system,B0,coil,option)

% default coil setting
if ~exist('option','var') option = 'inhomo'; end

% default coil setting
if ~exist('coil','var') coil = struct; end

% default reference magnet
if ~isfield(coil,'B0') coil.B0 = 11.74; end

% number of voxels for each sample
numVox = numel(B0{1});

% fix the B0 array if ignore B0 inhomogeneity
if strcmp(option,'ideal')
    for m = 1:num
        B0{m} = coil.B0 * ones(size(B0{m}));
    end
end

% number of nuclei
numIsotope = numel(sample.nuclei);

% Calculate the Hamiltonian
Hz = hamiltonian(assume(spin_system,'labframe','zeeman')); % Zeeman part
Hc = hamiltonian(assume(spin_system,'labframe','couplings')); % coupling part

% Drift Hamiltonian for the ensemble
H=cell(num,numVox);

if numIsotope == 1

    LzH = operator(spin_system,'Lz',sample.nuclei{1});
    for m=1:num % sample loop
        for k = 1:numVox % voxel loop

            % Sum coupling part and zeeman part, transfer to rotating frame
            H{m,k} = Hc + Hz*B0{m}(k) - (-spin(sample.nuclei{1})*coil.B0*LzH);
        end
    end

else

    HtoMinus = sparse(size(Hc,1),size(Hc,2));
    for q = 1:numIsotope   % nuclei loop
        Lz_temp = operator(spin_system,'Lz',sample.nuclei{q});
        HtoMinus = HtoMinus  + (-spin(sample.nuclei{q})*coil.B0*Lz_temp);
    end

    for m=1:num % sample loop
        for k = 1:numVox % voxel loop

            % Sum coupling part and zeeman part, transfer to rotating frame
            H{m,k} = Hc + Hz*B0{m}(k) - HtoMinus;
        end
    end

end
end