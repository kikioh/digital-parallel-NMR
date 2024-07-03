% combine the n port S parameters with tuning and matching capacitance
% to generate new n port S parameters, % the tuning and matching of n ports
% are performed independently. Syntax:
%
%             [SCM,Atrans,SF] = SCMA(freq,Z0,S)
%
% Parameters:
%
%          freq - frequency
%          Z0   - charactertic impedance
%          SC 	- coil array S paraneters
%
% Outputs:
%
%     SF	    - S matrix of free port, i.e., b_vec_free = S_new * a_vec_free
%
%     SCM     	- S matrix of all considered port, i.e., b_vec_all = S_new * a_vec_all
%
%     Atrans    - a matrix relate all ports a_vec_all with the free port a_free
%				  i.e., a_vec_all = a_mat*a_vec_free
%
% Note: avoid using this function. This function is usually called by IcArray function
%
% Mengjia He, 2022.06.21

function [SCM,Atrans,SF] = SCMA(freq,Z0,SC)

% set the default frequency as 500 MHz
if ~exist('freq','var') freq=500e6; end

% set the default charactertic impedance as 50 Ohm
if ~exist('Z0','var') Z0=50; end

% Check consistency
grumble(freq,Z0,SC);

% angular frequency
omega = 2*pi*freq;

% number of port
num = size(SC,1);

% matching network
SM = SMArray(freq,Z0,SC);
S11 = SM(1:num,1:num);S12 = SM(1:num,num+1:num*2);
S21 = SM(num+1:num*2,1:num);S22 = SM(num+1:num*2,num+1:num*2);
SF = S22 + S21 * inv(eye(num)-SC*S11) * SC * S12;

% optimizing TM if any reflection >= 0.1
SCM = SC;
if max(abs(diag(SF))) >= 0.1
    [~,C_opt] = tmOptimize(freq,Z0,SC);
    for m = 1:num
        A1 = [1,1/(1i*omega*C_opt(2));0,1] * [1,0;1i*omega*C_opt(1),1];
        S1 = A2S(A1);
        % expand the orginal S matrix with tunning and matching S matrix
        SCM = blkdiag(SCM,S1);
    end
else
    for m = 1:num

        % tuning and matching for each coil and combine with orginal matrix successively
        [Ct1, Lt1, Cm1] = tm1Port(freq,Z0,SC(m,m));
        if Ct1 ~=0
            A1 = [1,1/(1i*omega0*Cm1);0,1] * [1,0;1i*omega0*Ct1,1];
        else
            A1 = [1,1/(1i*omega0*Cm1);0,1] * [1,0;-1i/(omega0*Lt1),1];
        end
        S1 = A2S(A1);
        % expand the orginal S matrix with tunning and matching S matrix
        SCM = blkdiag(SCM,S1);
    end
end

% interconnect certain ports of S_exp
% connect 1 with n+2, 2 with n+4,..., n with 3n,
% n+1,n+3,...,3n-1 are free ports
% put the interconnect ports in front, and free ports behind
SCM = exchangeOrder(SCM,[linspace(1,num,num),linspace(num+2,3*num,num),linspace(num+1,3*num-1,num)]);

% substitute [b1,b2,...,bn,bn+2,bn+4,...,b3n] = [an+2,an+4,...a3n,a1,a2,...,an]
sub_matrix = [zeros(num),eye(num);eye(num),zeros(num)];
sub_matrix = cat(2,sub_matrix,zeros(2*num,num));

% linear equations: S_reduced * a_vector = 0
S_reduced = SCM(1:2*num,:)-sub_matrix;

% Gauss-Jordan elimination
R = rref(S_reduced);
R1 = -R(:,2*num+1:3*num);

% express a vector with reduced free ports a element [an+1,an+3,...a3n-1]
% a_vec_all = a_mat * [an+1,an+3,...a3n-1]'
Atrans = [R1;eye(num)];

% % combined S martrix
SF = SCM(2*num+1:3*num,:) * Atrans;

end


function grumble(freq,Z0,S)

if (~isnumeric(S))||(~allfinite(S))
    error('S matrix must be an array of finite numbers.');
end

if (~isnumeric(freq))||(~isreal(freq))||(freq<=0)
    error('frequency must be a real posotive number.');
end

if (~isnumeric(Z0))||(~isreal(Z0))||(Z0<=0)
    error('Z0 must be a real posotive number.');
end

end