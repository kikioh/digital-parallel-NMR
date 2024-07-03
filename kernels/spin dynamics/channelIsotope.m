% deal with isotropes with multiple channels
% Syntax:
% 
%           [isotopes,iso_ind]=channelIsotope(channel)
%
% Parameters:
%
%    channel               1*N cell, give isotropes in each channel
%
% Outputs:
%
%    isotopes,iso_ind   - free induction decay
%    ,iso_ind   - free induction decay
%
% Mengjia He, 2022.11.10
 
function [isotopes,iso_ind,isoUnique]=channelIsotope(channel)

num = numel(channel);
 
% combine isotopes
isotopes = {};              % collect all nuclei
iso_ind = cell(1,num);      % the isotope index of each channel in isotopes
isoUnique = {};             % collect unique nuclei

for m = 1:num
    if m == 1
        iso_ind{m} = 1:length(channel{m});
    else
        iso_ind{m} = iso_ind{m-1}(end)+1 : iso_ind{m-1}(end) + length(channel{m});
    end
    isotopes = [isotopes,channel{m}];

    isoUnique = unique([isoUnique,channel{m}],'stable');
end
                                       
end