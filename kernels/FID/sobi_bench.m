% second order blind identification by joint diagonalization of
% correlation  matrices. This code assumes temporally correlated signals,
% and uses correlations across times in performing the signal separation.
% Thus, estimated time delayed covariance matrices must be nonsingular
% for at least some time delays.
%
% Syntax:
%
%         [We,Ae,permutation]=sobi_bench(X,p)
%
% Parameters:
%
%   X 	- 	data matrix of size [m,N] ELSE of size [m,N,t], where
%       	m is the number of sensors,
%       	n is the  number of samples,
%       	t is the  number of trials (correlations avoid epoch boundaries)
%
%   p 	- 	number of correlation matrices to be diagonalized, default is min(100, N/3),
%			use at least p=100 time-delayed covariance matrices for noisy data.
%
% Outputs:
%
%  	We 	- 	matrix of size [m,n], estimate of the unmixing matrix. Its
%        	columns are the component scalp maps.
%
%   Ae  - 	estimate of the mixing matrix, i.e., Ae = pinv(We)
%
%   permutation - permutation index to realign the matrix
%
% Authors:
%
%   A. Belouchrani and A. Cichocki
%
% Adapted: 
%
%   Arnaud Delorme and Scott Makeig, to process data epochs
%
%   Menghjia He, 2023.10.09, to remove the scale and permutation indeterminacies
%
% References:
%
%  A. Belouchrani, K. Abed-Meraim, J.-F. Cardoso, and E. Moulines, Second-order
%  blind separation of temporally correlated sources, Proc. Int. Conf. on
%  Digital Sig. Proc., (Cyprus), pp. 346--351, 1993.
%
%  A. Belouchrani and K. Abed-Meraim, Separation aveugle au second ordre de
%  sources correlees, Proc. Gretsi, (Juan-les-pins), pp. 309--312, 1993.
%
%  A. Belouchrani, and A. Cichocki, Robust whitening procedure in blind source separation
%  context, Electronics Letters, Vol. 36, No. 24, 2000, pp. 2050-2053.
%
%  A. Cichocki and S. Amari, Adaptive Blind Signal and Image Processing, Wiley, 2003.

function [We,Ae,permutation]=sobi_bench(X,p)

[m,N,ntrials]=size(X);

% Default number of correlation matrices to be diagonalized
if exist('p','var') p=min(100,ceil(N/3)); end

% Make the data zero mean
X_temp = X;
X(:,:)=X(:,:)-kron(mean(X(:,:)')',ones(1,N*ntrials));

% Alternate whitening code
Rx=(X*X')/N;
IBL=sqrtm(Rx);
X = IBL\X;

% Estimate the correlation matrices
k=1;
pm=p*m; % for convenience
for u=1:m:pm
    k=k+1;
    for t = 1:ntrials
        if t == 1
            Rxp=X(:,k:N,t)*X(:,1:N-k+1,t)'/(N-k+1)/ntrials;
        else
            Rxp=Rxp+X(:,k:N,t)*X(:,1:N-k+1,t)'/(N-k+1)/ntrials;
        end
    end

    % Frobenius norm = sqrt(sum(diag(Rxp'*Rxp)))
    M(:,u:u+m-1)=norm(Rxp,'fro')*Rxp;  

end

% Perform joint diagonalization
epsil=1/sqrt(N)/100;
encore=1;
V=eye(m);
while encore
    encore=0;
    for p=1:m-1
        for q=p+1:m

            % Perform Givens rotation
            g=[   M(p,p:m:pm)-M(q,q:m:pm)  ;
                M(p,q:m:pm)+M(q,p:m:pm)  ;
                1i*(M(q,p:m:pm)-M(p,q:m:pm)) ];
        	  [vcp,D] = eig(real(g*g'));
              [~,K]=sort(diag(D));
              angles=vcp(:,K(3));
              angles=sign(angles(1))*angles;
              c=sqrt(0.5+angles(1)/2);
              sr=0.5*(angles(2)-1i*angles(3))/c;
              sc=conj(sr);
              oui = abs(sr)>epsil ;
              encore=encore | oui ;
              if oui  % Update the M and V matrices
                  colp=M(:,p:m:pm);
                  colq=M(:,q:m:pm);
                  M(:,p:m:pm)=c*colp+sr*colq;
                  M(:,q:m:pm)=c*colq-sc*colp;
                  rowp=M(p,:);
                  rowq=M(q,:);
                  M(p,:)=c*rowp+sc*rowq;
                  M(q,:)=c*rowq-sr*rowp;
                  temp=V(:,p);
                  V(:,p)=c*V(:,p)+sr*V(:,q);
                  V(:,q)=c*V(:,q)-sc*temp;
              end	% if
        end	% q loop
    end	% p loop
end	% while

% Estimate the mixing matrix
Ae = pinv(Q)*V;

% calculate permutation index
Y_temp = Ae \ X_temp;
correlationMatrix = zeros(m);
for i = 1:m
    for j = 1:m
        temp = corrcoef(Y_temp(i, :), X_temp(j, :));
        correlationMatrix(i, j) = temp(1,2);
    end
end
permutation = munkres(-abs(correlationMatrix));

% permutation alignment
W = diag(diag(Ae)) / Ae;
[~, indices] = ismember(linspace(1, m, m), permutation);
W = W(indices, :);

% Scaling correction
We = diag(diag(inv(W))) * W;
Ae = inv(We);

end


