% extract SC matrix from comsol model with multiple frequency, design tuning and matching. 
% Syntax:
%
% 		SC = extractS_Multifreq(nuclei,coil,model,comsol)
%
% Parameters:
%
%       nuclei          - cell array of nuclei, like {'1H','13C'}
%
%		coil.num        - coil number
%
%       model	        - COMSOL solution model
%
%		comsol.dset	    - string, solution daset
%
%		format	        - 'struct' or 'cell' (default), give SC in cell array or struct
%
% Outputs:
%
%       SC              - cell array or struct, each element is coil array S matrix at one
%                         frequency with ascend sequence
%
%       SM              - cell array or struct, each element is TM network S matrix at one
%                         frequency with ascend sequence
%
% Mengjia He, 2024.01.05

function [SC,SM,coil_tm] = extractS_Multifreq(coil,sample,model,comsol,format)

% set the default format as cell
if ~exist('format','var') format = 'cell'; end

% frequency number
numIsotope = numel(sample.nuclei);
freqUnique = zeros(1,numIsotope);
for m = 1:numIsotope

    freqUnique(m) = abs(spin(sample.nuclei{m}))*coil.B0/(2*pi);
end

% the frequency sweep in comsol is ascend
freqUnique = sort(freqUnique,'ascend');

switch format
    case 'cell'

        % cell array of S matrix with frequency ascend sequence
        SC = cell(1,numIsotope); SM = cell(1,numIsotope);
        for m = 1:numIsotope
            % import S matrix
            if coil.num == 1
                SC{m} = mphglobal(model,'emw.S11','dataset',comsol.dset,'outersolnum','all','solnum',m);
            else
                SC{m} = mphevalglobalmatrix(model,'emw.S','dataset',comsol.dset,'solnum',m);
                SC{m} = SC(:,2:coil.num+1);
            end

            SM{m} = SMArray(freqUnique(m),coil.Z0, SC{m});
        end

    case 'struct'

        % nuclei loop
        SC = struct;  SM = struct;
        for m = 1:numIsotope
            freq_temp = abs(spin(sample.nuclei{m}))*coil.B0/(2*pi);
            solNum = find(abs(freqUnique-freq_temp)/freq_temp<1e-4);

            % extract S matrix
            if coil.num == 1
                SC_temp = mphglobal(model,'emw.S11','dataset',comsol.dset,'solnum',solNum);
            else
                SC_temp = mphevalglobalmatrix(model,'emw.S','dataset',comsol.dset,'solnum',solNum);
                SC_temp = SC_temp(:,2:coil.num+1);
            end
            SC.(sample.nucleiField{m}) = SC_temp;
            SM.(sample.nucleiField{m}) = SMArray(freq_temp,coil.Z0,SC_temp);

        end
end

% package coil results
coil_tm = coil;
coil_tm.SC = SC;
coil_tm.SM = SM;

end

% % Consistency enforcement
% function grumble(format)
% if ~ismember(format,{'cell','struct'})
%     error('result member should be cell or struct.');
% end
% % if strcmp(format,'cell')
% %     if ~iscell(sample)
% %         error('sample is nuclei if the format is cell');
% %     end
% % end
% % if strcmp(format,'struct')
% %     if ~isstruct(sample)
% %         error('sample is complete struct if the format is struct');
% %     end
% % end
% end