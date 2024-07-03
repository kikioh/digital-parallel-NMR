% calculate the signal at the output of matching network
%
% Syntax:
%
% 			[signal,interf,noise,total,SNR] = signalArray(fid,coil,gain,noise_level)
%
% Parameters:
%          fid          - N*N cell, fid voltage at coil terminal
%		   coil			- struct, include
%							- freq, frequency
%							- Z0, charactertic impandnece
%							- num, coil number
%							- excite, number array, incident voltage at match network
%          model	    - COMSOL model
%		   comsol		- struct
%							- ptindex, number string, index of mark point
%							- dset, string, solution daset
%
% Outputs:
%
%     	   signal     	- N*1 cell, useful NMR signal of N detector
%     	   interface  	- N*1 cell, interface signal of N detector
%     	   noise     	- N*1 cell, noise of N detector
%     	   total  		- N*1 cell, total signal,i.e., signal + interface + noise of N detector
%     	   SNR     		- N*1 cell, SNR in dB of N detector
%     	   Pmatrix     	- same size with gain, modified signal transfer gain matrix, see supplementary S4
%
% Mengjia He, 2022.08.30

function [signal,interf,noise,total,SNR,Pmatrix] = signalArray(fid,coil,gain,noise_level)

% set up default noise level
if ~exist('noise_level','var') noise_level=-50; end

num = coil.num;

% process one nuclei FID
if iscell(fid)
    % signal at matching output
    TD = length(fid{1,1});
    

    signal = cell(num,1);	            % signal at match network output
    interf = cell(num,1);	            % interface at match network output
    noise  = cell(num,1);	            % noise at match network output
	total  = cell(num,1);	            % noise at match network output
	SNR    = cell(num,1);	            % SNR at match network output
	
    % effective signal
    for m = 1:num
        % fid_temp(m,:) = transpose(fid{m,m});
        % signal_temp = gain * fid_temp;
        % signal{m} = signal_temp(m,:);
        % fid_temp = zeros(num,TD);	% fid vector at coil terminal
		signal{m} = gain(m,m) * transpose(fid{m,m});
    end
	
	fid_temp = zeros(num,TD);			% fid vector at coil terminal
    % interference signal
    for m = 1:num       % coil loop
        for n = 1:num   % sample loop
            fid_temp(m,:) = fid_temp(m,:) + transpose(fid{m,n});
        end
    end

    total_match = gain * fid_temp;
    for m = 1:num       % coil loop
        interf{m} = total_match(m,:) - signal{m};
    end

    % noise
    noiseamp = 10^(noise_level/20)/sqrt(2);
    noise_coil = zeros(num,TD);
    for m = 1:num
        noise_coil(m,:) = noiseamp*(randn(1,TD)+1i*randn(1,TD));
    end

    noise_TM =  gain * noise_coil;
    for m = 1:num
        noise{m} = noise_TM(m,:);
    end
	
	% calculate total signals
    for m = 1:num
        total{m} = signal{m} + interf{m} + noise{m};
    end

	% calculate SNR in dB
	VsCovar = conj(gain) * conj(cell2mat(signal)) * transpose(cell2mat(signal)) * transpose(gain);
	VnCovar = conj(gain) * conj(noise_coil) * transpose(noise_coil) * transpose(gain);
    for m = 1:num
        SNR{m} = VsCovar(m,m) / VnCovar(m,m);
		SNR{m} = 10*log10(abs(SNR{m}));
    end
	
	% calculate Pmatrix
	Pmatrix = zeros(size(gain));
    for m = 1:num
		for n = 1:num
			if n == m
				Pmatrix(m,n) = gain(m,n);
			else
				R2_temp = transpose(fid{m,n})*conj(fid{m,n}) / (transpose(fid{n,n})*conj(fid{n,n}));
				Pmatrix(m,n) = gain(m,n) + gain(m,m) * sqrt(R2_temp);
			end
		end
	end
	
% process multiple nuclei FID
elseif isstruct(fid)

    nucleiField = fieldnames(fid);
    numIsotope = numel(nucleiField);

    signal = struct; interf = struct; noise = struct; total = struct; SNR = struct; Pmatrix = struct;
    for q = 1:numIsotope

        fidQ = fid.(nucleiField{q});
		gainQ = gain.(nucleiField{q});
        TD = length(fidQ{1,1});
        

        signal.(nucleiField{q}) = cell(num,1);	     % signal at match network output
        interf.(nucleiField{q}) = cell(num,1);	     % interface at match network output
        noise.(nucleiField{q})  = cell(num,1);	     % noise at match network output
		total.(nucleiField{q})  = cell(num,1);	     % total signal at match network output
		SNR.(nucleiField{q})  = cell(num,1);	     % total signal at match network output
		
        % effective signal
        for m = 1:num

        	signal.(nucleiField{q}){m} = gain.(nucleiField{q})(m,m) * transpose(fidQ{m,m});
        end

        % interference signal
		fid_temp = zeros(num,TD);			         % fid vector at coil terminal
        for m = 1:num       % coil loop
            for n = 1:num   % sample loop
        	    fid_temp(m,:) = fid_temp(m,:) + transpose(fidQ{m,n});
            end
        end

        total_match = gain.(nucleiField{q}) * fid_temp;
        for m = 1:num       % coil loop
            interf.(nucleiField{q}){m} = total_match(m,:) - signal.(nucleiField{q}){m};
        end

        % noise
        noiseamp = 10^(noise_level/20)/sqrt(2);
        noise_coil = zeros(num,TD);
        for m = 1:num
        	noise_coil(m,:) = noiseamp*(randn(1,TD)+1i*randn(1,TD));
        end

        noise_TM =  gain.(nucleiField{q}) * noise_coil;
        for m = 1:num
        	noise.(nucleiField{q}){m} = noise_TM(m,:);
        end
		
		% total signal
        for m = 1:num
        	total.(nucleiField{q}){m} = signal.(nucleiField{q}){m} +...
				interf.(nucleiField{q}){m} +noise.(nucleiField{q}){m};
        end
		
		% calculate SNR in dB
		VsCovar = conj(gain.(nucleiField{q})) * conj(cell2mat(signal.(nucleiField{q})))...
		* transpose(cell2mat(signal.(nucleiField{q}))) * transpose(gain.(nucleiField{q}));
		
		VnCovar = conj(gain.(nucleiField{q})) * conj(noise_coil) * transpose(noise_coil) *...
		transpose(gain.(nucleiField{q}));
		for m = 1:num
			SNR.(nucleiField{q}){m} = VsCovar(m,m) / VnCovar(m,m);
			SNR.(nucleiField{q}){m} = 10*log10(abs(SNR.(nucleiField{q}){m}));
		end
		
		% calculate Pmatrix
		Pmatrix_temp = zeros(num,num);
		for m = 1:num
			for n = 1:num
				if n == m
					Pmatrix_temp(m,n) = gainQ(m,n);
				else
					R2_temp = transpose(fidQ{m,n})*conj(fidQ{m,n}) / (transpose(fidQ{n,n})*conj(fidQ{n,n}));
					Pmatrix_temp(m,n) = gainQ(m,n) + gainQ(m,m) * sqrt(R2_temp);
				end
			end
		end
		Pmatrix.(nucleiField{q}) = Pmatrix_temp;
    end

else

    error('fid should be cell array or struct');

end

end

