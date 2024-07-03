% calculate the S parameters of tuning and matching network 
%
% the tuning and matching of n ports are performed independently.
% Syntax:
%
%             [SM, SF] = tmArray(freq,Z0,SC)
%
% Parameters:
%
%          freq - frequency
%          Z0   - charactertic impedance
%          SC 	- coil array S paraneters
%
% Outputs:
%
%     SM     - S matrix of tuning and matching network
%			      [b1_vec;b1_vec] = [SM11,SM12;SM21,SM22] * [a1_vec;a1_vec]
%
%     SF  	-  S matrix of free port 
%
% Ref: 2005-ITAP-Effects of Mutual Coupling on Interference Mitigation
%      With a Focal Plane Array
%
% Note:This function is usually called in combining transmission and reception of coil array
%
% Mengjia He, 2022.07.01

function  [SM,SF] = tmArray(freq,Z0,SC)

% set the default charactertic impedance as 50 Ohm
if ~exist('Z0','var') Z0=50; end

% set the default frequency as 500 MHz
if ~exist('freq','var') freq=500e6; end

omega0 = 2*pi*freq;
num = size(SC,1);

% prelocate SM matrix
SM = [];

for m = 1:num

    % tuning and matching for each coil and combine with orginal matrix successively
    [Ct1, Lt1, Cm1] = tm1Port(freq,Z0,SC(m,m));
    if Ct1 ~=0
        A1 = [1,1/(1i*omega0*Cm1);0,1] * [1,0;1i*omega0*Ct1,1];
    else
        A1 = [1,1/(1i*omega0*Cm1);0,1] * [1,0;-1i/(omega0*Lt1),1];
    end
    S1 = A2S(A1);
    SM = blkdiag(SM,S1);
end

% interconnect ports: 2,4,6,...,2*n
% free ports: 1,3,5,...,2*n-1
% put the interconnect ports in front, and free ports behind
SM = exchangeOrder(SM,[linspace(2,2*num,num),linspace(1,2*num-1,num)]);

% calculated SF with initial SM
S11 = SM(1:num,1:num);S12 = SM(1:num,num+1:num*2);
S21 = SM(num+1:num*2,1:num);S22 = SM(num+1:num*2,num+1:num*2);
SF = S22 + S21 * inv(eye(num)-SC*S11) * SC * S12;

end
