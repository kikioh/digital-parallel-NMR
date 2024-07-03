% Select a color from colour library. Syntax:
%
%                      cmap=lineColor()
%
% Parameters:
%
%	 name  - a character string or index number, represent the colormap name
%
%	Ref: https://ww2.mathworks.cn/help/matlab/ref/matlab.graphics.chart.primitive.line-properties.html?searchHighlight=line%20color&s_tid=srchtitle_line%2520color_2
%
% Outputs:
%
%    cmap - 1x3 RGB matrix, colour map in Matlab format
%
function cmap=lineColor(name)

% Check consistency
grumble(name);


switch name
    case {'1','lightblue'}
        cmap =[0.3555 0.6055 0.8320];

    case {'2','lightorange'}
        cmap =[0.9258 0.4883 0.1914];

	case {'3','lightgreen'}
        cmap =[0.6314 0.8510 0.6039];
		
    case {'4','rose'}
        cmap =[0.9059 0.5922 0.6118];

    case {'5','lightpurple'}
        cmap =[0.7843 0.5176 0.8392];
			
	case {'6','cyan'}
        cmap =[0.3010 0.7450 0.9330];
		
	case {'7','red'}
        cmap =[0.6350 0.0780 0.1840];
		
	case {'8','grey'}
        cmap =[0.5 0.5 0.5];
	
	case {'matlab1'}
        cmap =[0 0.4470 0.7410];

	case {'matlab2'}
        cmap =[0.8500 0.3250 0.0980];
		
	case {'matlab3'}
        cmap =[0.9290 0.6940 0.1250];
		
	case {'matlab4'}
        cmap =[0.4940 0.1840 0.5560];

	case {'matlab5'}
        cmap =[0.4660 0.6740 0.1880];

	case {'matlab6'}
        cmap =[0.3010 0.7450 0.9330];

	case {'matlab7'}
        cmap =[0.6350 0.0780 0.1840];		

	case {'green1'}
        cmap =[27 140 60]/255;

	case {'green2'}
        cmap =[2 135 90]/255;

	case {'green3'}
        cmap =[7 128 127]/255;

	case {'green4'}
        cmap =[0 106 173]/255;
		
	
    otherwise
        error([name ' - unknown color name.']);
end
end


function grumble(name)

if ~ischar(name)
    error('color name must be a character string.');
end
end