% Create sample for extract B field
% Syntax:
%
%            sweepScale=sweepFreq(nuclei)
%
% Parameters:
%
%   nuclei      - string, like '1H'
%
% Outputs:
%
%   sweepFreq   - relative sampling frequency to '1H', determined by
%                 the easmiated isotope bandwidth
%
% Mengjia He, 2024.01.01

function sweepScale=sweepFreq(nuclei)

% default options
if ~exist('nuclei','var') nuclei = '1H'; end

switch nuclei
    case '1H'
        sweepScale = 1;
    case '13C'
        sweepScale = abs(spin(nuclei))/spin('1H')*10;
    case '15N'
        sweepScale = abs(spin(nuclei))/spin('1H')*50;
end
sweepScale = roundn(sweepScale,-1);
end
