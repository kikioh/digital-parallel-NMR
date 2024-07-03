% calculate the signal at the output of matching network
%
% Syntax:
%
% 			signal= signalDecouple(total,coil,Bm,gain)
%
% Parameters: 
%          	total      - N*1 cell, total signal detected from matching network output
%		   	Bm          - N*N cell, recieve B field
%			gain		- N*N matrix, gain of coil and matching network
%
% Outputs:
%
%     	   signal     - 	N*1 cell, useful NMR signal after decoupling
%
% Mengjia He, 2022.09.09

function signal = signalDecouple(total,coil,Bm,gain)

num = coil.num;
gain_temp = zeros(num);
for m = 1:num	% coil loop
	for n = 1:num	% sample loop
		if n ~= m
			gain_temp(m,n) = gain(m,n) + gain(m,m)* sum(Bm{m,n}) / sum(Bm{n,n});
        else
            gain_temp(m,n) = gain(m,n);
		end
	end
end

% transform cell to matrix
total_temp = zeros(num,length(total{1}));
for m = 1:num
	total_temp(m,:) = total{m};
end

fid_temp = pinv(gain_temp) * total_temp;

% transform matrix to cell
fid = cell(num,1); signal = cell(num,1);
for m = 1:num
	fid{m} = fid_temp(m,:);
	signal{m} = gain(m,m)*fid{m};
end

end

