% given a string, put the letters in front, and digit in the back
% Syntax:
%
%           strNew=strExchange(str)
%
% Parameters:
%
%            str  - 1*N cell, each element is a string
%
% Outputs:
%
%            strNew  - 1*N cell, each element is a string
%
% Mengjia He, 2022.11.11

function strNew=strExchange(str)

num = numel(str);
strNew = cell(1,num);

for m = 1:num

    % select pattern
    patdig = digitsPattern;
    patletter = lettersPattern;

    dig = extract(str{m},patdig);
    letter = extract(str{m},patletter);

    % put letters in front
    strNew{m} = strcat(letter,dig);
    strNew{m} = strNew{m}{1};
end

end