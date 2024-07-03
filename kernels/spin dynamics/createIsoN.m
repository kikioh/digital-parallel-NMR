% create N group of isotopes for N-channel NMR
% number of spin in each channel is reandmly generated, also for its
% chemical shift
% Syntax:
%
%           iso = createIsoN(num,nuclei)
%
% Parameters:
%
%           num         - channel number
%
%           nuclei      - string, giving the nuclei, like '1H' or '13C'
%
%           numSpinMax  - maxmium number of spin in one channel
%
%           numCSMax    - maxmium chemical shift of the spin
%
% Outputs:
%
%            iso  - struct
%                   
% Mengjia He, 2023.12.20
function iso = createIsoN(num,nuclei,numSpinMax, numCSMax)

% Isotopes
channel = cell(1,num); CS = cell(1,num); numIso = cell(1,num);
for m = 1:num
    numIso{m} = randi(numSpinMax,1,1);
    CS{m} = round(rand(1, numIso{m}) * numCSMax, 2);
    channel{m} = repmat({nuclei}, 1, numIso{m});
end

iso_ind = cell(1,num); isotopes  = {}; CSppm  = [];
for m = 1:num
    if m == 1
        iso_ind{m} = 1:numIso{1};
    else
        iso_ind{m} = iso_ind{m-1}(end)+1 : iso_ind{m-1}(end)+numIso{m};
    end
    isotopes = [isotopes,channel{m}];
    CSppm = [CSppm,CS{m}];
end

iso.CS = num2cell(CSppm);
iso.channel = channel;
iso.isotopes = isotopes;
iso.iso_ind = iso_ind;
end