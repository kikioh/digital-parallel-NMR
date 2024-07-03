% calculate the S parameters of tuning and matching network
%
% note: import SC matrix from comsol module
% Syntax:
%
%             [SM,SC] = SMcomsol(coil,model,comsol)
%
% Parameters:
%
%          coil     - struct, coil parameters
%          model    - comsol solution model
%          comsol 	- comsol solution index
%
% Outputs:
%
%     coil_tm     - struct, coil parameters, added SC and SM
%
% Ref: 2005-ITAP-Effects of Mutual Coupling on Interference Mitigation
%      With a Focal Plane Array
%
% Note:This function is usually called in combining transmission and reception of coil array
%
% Mengjia He, 2022.07.01

function  coil_tm = SMcomsol(coil,model,comsol)

num = coil.num;
freq = coil.freq; omega = 2*pi*freq;
Z0 = coil.Z0;

% extract S matrix
if num >1
	SC = mphevalglobalmatrix(model,'emw.S','dataset',comsol.dset);
	SC = SC(:,2:num+1);
else
	SC = mphglobal(model,'emw.S11','dataset',comsol.dset);
end

% constract SM by coil loop
SM = [];
for m = 1:num

    % tuning and matching for each coil and combine with orginal matrix successively
    [Ct1, Lt1, Cm1] = tm1Port(freq,Z0,SC(m,m));
    if Ct1 ~=0
        A1 = [1,1/(1i*omega*Cm1);0,1] * [1,0;1i*omega*Ct1,1];
    else
        A1 = [1,1/(1i*omega*Cm1);0,1] * [1,0;-1i/(omega*Lt1),1];
    end
    S1 = A2S(A1);
    SM = blkdiag(SM,S1);
end

% interconnect ports
SM = exchangeOrder(SM,[linspace(2,2*num,num),linspace(1,2*num-1,num)]);

% calculated SF with initial SM
S11 = SM(1:num,1:num);S12 = SM(1:num,num+1:num*2);
S21 = SM(num+1:num*2,1:num);S22 = SM(num+1:num*2,num+1:num*2);
SF = S22 + S21 * inv(eye(num)-SC*S11) * SC * S12;

% optimizing SM if any reflection >= 0.1
if max(abs(diag(SF))) >= 0.1
    SM = tmOptimize(freq,Z0,SC);
end

% package coil results
coil_tm = coil;
coil_tm.SC = SC;
coil_tm.SM = SM;

end
