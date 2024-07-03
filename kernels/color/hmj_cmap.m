% Select a color map from colour library with 255 points and
% white colour corresponding to zero. Syntax:
%
%                      cmap=hmj_cmap(name)
%
% Parameters:
%
%	 name  - a character string, represent the colormap name
%
% Outputs:
%
%    cmap - 255x3 RGB matrix, colour map in Matlab format
%
function cmap=hmj_cmap(name)
% Check consistency
grumble(name);
% set the color data path
% colorPath = 'Q:\OneDrive\Digital NMR\Matlab\kernels\color';

switch name
    case 'RdBu'
        cmap =load('RdBu.mat').RdBu;

    case 'BrBG'
        cmap =load('BrBG.mat')).BrBG;

    case 'coolwarm'
        cmap =load('coolwarm.mat').coolwarm;

    case 'viridis'
        cmap =load('viridis.mat').viridis;

    case 'bwr'
        cmap =load('bwr.mat').bwr;

    case 'JupAuro'
        cmap =load('JupAuro.mat').JupAuro;

    case 'JupAuro2'
        cmap =load('JupAuro2.mat').JupAuro2;
		
	case 'Blues'
    cmap =load('Blues.mat').Blues;

    otherwise
        error([name ' - unknown color name.']);
end
end

function grumble(name)
if ~ischar(name)
    error('color name must be a character string.');
end
end