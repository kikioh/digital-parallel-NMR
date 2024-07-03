% Create Spin system of N channels
% Syntax:
%
%                    [sys,inter]=createSpin_Nchn(num,nuclei,options)
% Parameters:
%
%   nuclei              - 1*N cell, give isotopes, like{'1H','13C'}, each
%                         channel include these nuclei
%
%   N                   - channel number
%
%   spinAssign          - spin assign method, 
%                         Use 'fixed' to assign one spin in one channel with the H_CS = channelNumber,
%						  C_CS = 10*channelNumber, N_CS = 50*channelNumber,
%						  Use 'random' to randomly assign random spins with random
%						  chemical shift on each channel, and use follow parameters to limit
%						  the random number, 
%                         Use 'optCon' to generate spin for optimal
%                         control, i.e., each channel has one spin with
%                         zero chemical shift for each nuclei
%
%   options.numSpin  	- maxmium number of spin in one channel
%
%   options.H_CS    	- maxmium 1H chemical shift of the spin
%
%   options.C_CS    	- maxmium 13C chemical shift of the spin
%
% Outputs:
%
%    sys   - Spinach spin system description structure
%
%    inter - Spinach interaction description structure
%
%
% Mengjia He, 2024.01.01

function [sys,inter,iso]=createSpin_Nchn(num,nuclei,spinAssign,options)

% set up default options
if ~exist('spinAssign','var') spinAssign='fixed'; end

% set up default options
if ~exist('options','var') options=struct; end

% set up default maxmium number of spin in one channel
if ~isfield(options,'numSpin') options.numSpin = 8; end

% set up default maxmium 1H chemical shift
if ~isfield(options,'H_CS') options.H_CS = 10; end

% set up default maxmium 13C chemical shift
if ~isfield(options,'C_CS') options.C_CS = 100; end

% set up default maxmium 15N chemical shift
if ~isfield(options,'N_CS') options.N_CS = 500; end

numIsotope = numel(nuclei);		% number of experiment nuclei

if num < 10
	CS_scale = 1;				% chemical shift scale coefficient to limit the bandwidth
else
	CS_scale = 10/num;	
end

% Isotopes
iso_ind = cell(1,num); channel = cell(1,num); CS = cell(1,num); 

switch spinAssign

    case	'fixed'
        for m = 1:num
            % generate isotope and assign index
            channel{m} = nuclei;
            iso_ind{m} = (1:numIsotope) + (m-1)*numIsotope;

            % generate chemical shift
            CS{m} = [];
            for q =1:numIsotope
                switch nuclei{q}
                    case '1H',  CS{m} = [CS{m},m];

                    case '13C', CS{m} = [CS{m},10*m];

                    case '15N', CS{m} = [CS{m},50*m];
                end
            end
			CS{m} = CS{m} * CS_scale;
        end

    case	'optCon'
        for m = 1:num
            % generate isotope and assign index
            channel{m} = nuclei;
            iso_ind{m} = (1:numIsotope) + (m-1)*numIsotope;

            % generate chemical shift
            CS{m} = zeros(1,numIsotope);
        end

    case	'random'

        numSpin = cell(1,num);
        for m = 1:num
            numSpin{m} = randi(options.numSpin,1,numIsotope);

            % assign isotope index
            if m == 1
                iso_ind{m} = 1:sum(numSpin{1});
            else
                iso_ind{m} = iso_ind{m-1}(end)+1 : iso_ind{m-1}(end)+sum(numSpin{m});
            end

            % generate isotope and chemical shift
            channel{m} ={};
            for q =1:numIsotope
                channel{m} = [channel{m},repmat(nuclei(q), 1, numSpin{m}(q))];
                switch nuclei{q}
                    case '1H',  CS{m} = [CS{m},round(rand(1, numSpin{m}(q)) * options.H_CS, 2)];

                    case '13C', CS{m} = [CS{m},round(rand(1, numSpin{m}(q)) * options.C_CS, 2)];

                    case '15N', CS{m} = [CS{m},round(rand(1, numSpin{m}(q)) * options.N_CS, 2)];
                end

            end
        end

end

isotopes  = {}; CSppm  = [];
for m = 1:num
    isotopes = [isotopes,channel{m}];
    CSppm = [CSppm,CS{m}];
end

iso.numIsotope = numIsotope;
iso.CS = num2cell(CSppm);
iso.channel = channel;
iso.isotopes = isotopes;
iso.iso_ind = iso_ind;

% Combine isotope arrays
sys.isotopes=iso.isotopes;

% Combine chemical shift arrays
inter.zeeman.scalar=iso.CS;

end


