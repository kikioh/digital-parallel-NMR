% remove the mean B1 phase for optimal control. Syntax:
%
%             Bp_shim = zeroPhaseShim(Bp)
%
% Parameters:
%       Bp     - B1 field, cell array or struct
%
% Outputs:
%
%       Bp_shim     - zero shimmed B1 field, cell array or struct
%
% Mengjia He, 2022.11.21

function Bp_shim = zeroPhaseShim(Bp)

if iscell(Bp)

    num = numel(Bp);
    Bp_shim = cell(size(Bp));
    for m = 1:num
        phase_temp = mean(angle(Bp{m}));
        Bp_shim{m} = Bp{m} * exp(-1i*phase_temp);
    end

elseif isstruct(Bp)
    Bp_shim = struct;
    nucleiField = fieldnames(Bp);
    for q = 1:numel(nucleiField)    % isotope loop

        num = numel(Bp.(nucleiField{q}));
        Bp_shim.(nucleiField{q}) = cell(size(Bp.(nucleiField{q})));
        for m = 1:num

            phase_temp = mean(angle(Bp.(nucleiField{q}){m}));
            Bp_shim.(nucleiField{q}){m} = Bp.(nucleiField{q}){m} * exp(-1i*phase_temp);

        end
    end

else
    error('Bp should be cell array or struct');
end

end