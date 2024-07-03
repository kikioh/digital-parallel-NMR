% calculate the operators of parallel spin system
%
% Syntax:
%
%           opts = paraOpts(num,sample,spin_system,iso)
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
%           opts             - calculated control operators for each sub
%                              spin system, include Lx, Ly and Lz
%
% Mengjia He, 2024.01.04

function opts = paraOpts(num,sample,spin_system,iso)

if numel(sample.nuclei) == 1

    opts.Lx = cell(num,1); opts.Ly = cell(num,1); opts.Lz = cell(num,1);
    for m = 1:num
        Lp = operator(spin_system,'L+',iso.iso_ind{m});
        opts.Lx{m} =(Lp+Lp')/2;
        opts.Ly{m} =(Lp-Lp')/2i;
        opts.Lz{m} = operator(spin_system,'Lz',iso.iso_ind{m});
    end

else

    opts.Lx = struct; opts.Ly = struct; opts.Lz = struct;
    for q = 1:numel(sample.nuclei)    % nuclei loop

        opts.Lx.(sample.nucleiField{q}) = cell(1,num);
        opts.Ly.(sample.nucleiField{q}) = cell(1,num);
        opts.Lz.(sample.nucleiField{q}) = cell(1,num);

        for m = 1:num   % sample loop
            ind_temp = strcmp(iso.channel{m},sample.nuclei{q});

            Lp = operator(spin_system,'L+',iso.iso_ind{m}(ind_temp));
            opts.Lx.(sample.nucleiField{q}){m} =(Lp+Lp')/2;
            opts.Ly.(sample.nucleiField{q}){m} =(Lp-Lp')/2i;

            opts.Lz.(sample.nucleiField{q}){m} = operator(spin_system,'Lz',iso.iso_ind{m}(ind_temp));
        end

    end
    
end

end