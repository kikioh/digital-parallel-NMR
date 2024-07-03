% read txt file for processing topspin spectrum
%
% Mengjia He, 2024.01.26

function spectrum = readTopSpinTxt(fileName)

% Open the file for reading
fileID = fopen(fileName, 'r');

% Read the data from the file
data = textscan(fileID, '%f', 'CommentStyle', '#');

% Close the file
fclose(fileID);

% Extract the column of data
spectrum = transpose(data{1});

end

