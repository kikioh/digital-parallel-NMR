% calculate the spin state of parallel spin system
%
% Syntax:
%
%           rho = paraRho(num,sample,spin_system,iso)
%
% Parameters:
%
%           num             - channel number
%
%           sample          - sample struct created by createSample.m
%
%           spin_system     - spin_system created by Spinach housekeeping
%
%           iso             - isotope struct created by createSpin_Nchn.m
% Outputs:
%
%           rho             - calculated spin state for each sample
%                              include Ix, Iy and Iz and I+
%
% Mengjia He, 2024.01.04

function rho = paraRho(num,sample,spin_system,iso)

% Set up and normalise the initial state
rho.z = cell(num,1); rho.x = cell(num,1); rho.y = cell(num,1);
for m = 1:num

    rho.z{m}=state(spin_system,'Lz',iso.iso_ind{m});
    rho.z{m}=rho.z{m}/norm(full(rho.z{m}),'fro');

    rho.x{m}=(state(spin_system,'L+',iso.iso_ind{m})+...
        state(spin_system,'L-',iso.iso_ind{m}))/2;
    rho.x{m}=rho.x{m}/norm(full(rho.x{m}),'fro');

    rho.y{m}=(state(spin_system,'L+',iso.iso_ind{m})-...
        state(spin_system,'L-',iso.iso_ind{m}))/2i;
    rho.y{m}=rho.y{m}/norm(full(rho.y{m}),'fro');

end

% Set up and normalise the coil state
if numel(sample.nuclei) == 1
   
    rho.detec=state(spin_system,'L+',sample.nuclei{1});
    rho.detec=rho.detec/norm(full(rho.detec),'fro');

else

    rho.detec = struct;
    for q = 1:numel(sample.nuclei)

        coil_temp_x= (state(spin_system,'L+',sample.nuclei{q}) +...
            state(spin_system,'L-',sample.nuclei{q}))/2;
        coil_temp_x = coil_temp_x/norm(coil_temp_x,'fro');
        rho.detec.(sample.nucleiField{q}).x = coil_temp_x;

        coil_temp_y= ((state(spin_system,'L+',sample.nuclei{q}) -...
            state(spin_system,'L-',sample.nuclei{q})))/2i;
        coil_temp_y = coil_temp_y/norm(coil_temp_y,'fro');
        rho.detec.(sample.nucleiField{q}).y = coil_temp_y;

        coil_temp_p = state(spin_system,'L+',sample.nuclei{q});
        coil_temp_p = coil_temp_p/norm(coil_temp_p,'fro');
        rho.detec.(sample.nucleiField{q}).p = coil_temp_p;
    end

end

end