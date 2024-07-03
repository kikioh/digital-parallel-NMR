% read FID from a JCAMP format. Syntax:
%
%      [complexFid,time] = readDXFile(fileName)
%
% Parameters:
%
%      fileName   - the complete file name, should include file path
%
% Outputs:
%
%      complexFid   - complex value FID data
%
%      time         - acquisition time sequence 
%
% Mengjia He, 2024.01.19



function [complexFid,time] = readDXFile(fileName)

% open file
fid = fopen(fileName, 'r');

% Check consistency
if fid == -1
    error('无法打开文件');
end

% prelocate fid data
realData = [];
imagData = [];

% scan the file row
while ~feof(fid)

    % read one row
    line = fgetl(fid);

    % check if it's real data
    if contains(line, '$$ Real data points')

        % start record real value data
        while ~feof(fid)
            % read next row
            line = fgetl(fid);

            % check if the imag data start
            if contains(line, '$$ Imaginary data points')
                break;
            end

            % ignore the rows start with ##
            if ~startsWith(line, '##')

                % extract time-data and save to real array
                data = str2double(strsplit(line));
                realData = [realData; data];
            end
        end
    end

    % start record real value data
    if contains(line, '$$ Imaginary data points')
        while ~feof(fid)
            % read next row
            line = fgetl(fid);

            % ignore the rows start with ##
            if ~startsWith(line, '##')

                % extract time-data and save to imag array
                data = str2double(strsplit(line));
                imagData = [imagData; data];
            end
        end
    end


    % find acqisition time
    if startsWith(line, '##LAST=')
        
        lastValues = str2double(strsplit(line(8:end), ','));

        % acqisition time
        AQ = lastValues(1);

    end
 
end

% complex fid
complexFid = complex(realData(:,2),imagData(:,2));
complexFid = transpose(complexFid);

% number of points
TD = numel(complexFid);

% time sequence
time = linspace(0,AQ,TD);

% close file
fclose(fid);

end
