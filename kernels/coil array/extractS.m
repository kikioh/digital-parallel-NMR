% extract S parameter form COMSOL export txt file. Syntax:
%
% 		S = extractS(filename,num)
%
% Parameters:
%
% 	    filename - txt file name
%
% 	    num - coil number
%
% Outputs:
%
%       SC  - coil array S matrix
%
% Mengjia He 2024.01.04

function SC = extractS(filename,num)

fileID = fopen(filename);
data = textscan(fileID,repmat('%f ',1,num),'CollectOutput',1,'CommentStyle','%');
SC = data{1,1};
% SC = SC(:,2:num+1);
fclose(fileID);

end