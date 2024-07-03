% sobi() - Second Order Blind Identification (SOBI) by joint diagonalization of
%          correlation  matrices. THIS CODE ASSUMES TEMPORALLY CORRELATED SIGNALS,
%          and uses correlations across times in performing the signal separation.
%          Thus, estimated time delayed covariance matrices must be nonsingular
%          for at least some time delays.
% Usage:
%         >> winv = sobi(data);
%         >> [winv,act] = sobi(data,n,p);
% Inputs:
%   data - data matrix of size [m,N] ELSE of size [m,N,t] where
%                m is the number of sensors,
%                N is the  number of samples,
%                t is the  number of trials (here, correlations avoid epoch boundaries)
%      n - number of sources {Default: n=m}
%      p - number of correlation matrices to be diagonalized {Default: min(100, N/3)}
%          Note that for noisy data, the authors strongly recommend using at least 100
%          time delays.
%
% Outputs:
%   winv - Matrix of size [m,n], an estimate of the *mixing* matrix. Its
%          columns are the component scalp maps. NOTE: This is the inverse
%          of the usual ICA unmixing weight matrix. Sphering (pre-whitening),
%          used in the algorithm, is incorporated into winv. i.e.,
%             >> icaweights = pinv(winv); icasphere = eye(m);
%   act  - matrix of dimension [n,N] an estimate of the source activities
%             >> data            = winv            * act;
%                [size m,N]        [size m,n]        [size n,N]
%             >> act = pinv(winv) * data;
%
% Authors:  A. Belouchrani and A. Cichocki (papers listed in function source)
%
% Note: Adapted by Arnaud Delorme and Scott Makeig to process data epochs

% REFERENCES:
% A. Belouchrani, K. Abed-Meraim, J.-F. Cardoso, and E. Moulines, ``Second-order
%  blind separation of temporally correlated sources,'' in Proc. Int. Conf. on
%  Digital Sig. Proc., (Cyprus), pp. 346--351, 1993.
%
%  A. Belouchrani and K. Abed-Meraim, ``Separation aveugle au second ordre de
%  sources correlees,'' in  Proc. Gretsi, (Juan-les-pins),
%  pp. 309--312, 1993.
%
%  A. Belouchrani, and A. Cichocki,
%  Robust whitening procedure in blind source separation context,
%  Electronics Letters, Vol. 36, No. 24, 2000, pp. 2050-2053.
%
%  A. Cichocki and S. Amari,
%  Adaptive Blind Signal and Image Processing, Wiley,  2003.

function [Y,W,Ae]=sobi(X,p)

[m,N,ntrials]=size(X);
if nargin<1 || nargin > 3
    help sobi
elseif nargin==1
    % Source detection (hum...)
    p=min(100,ceil(N/3)); % Number of time delayed correlation matrices to be diagonalized
    % Authors note: For noisy data, use at least p=100 the time-delayed covariance matrices.
elseif nargin==2
    p=min(100,ceil(N/3)); % Default number of correlation matrices to be diagonalized
    % Use < 100 delays if necessary for short data epochs
end


% Make the data zero mean
X_temp = X;
X(:,:)=X(:,:)-kron(mean(X(:,:)')',ones(1,N*ntrials));


% Pre-whiten the data based directly on SVD
[~,Y,VV]=svd(X(:,:)',0);
Q= pinv(Y)*VV';	% the whitening matrix
X(:,:)=Q*X(:,:);

% Alternate whitening code
% Rx=(X*X')/T;
% if m<n, % assumes white noise
%   [U,D]=eig(Rx);
%   [puiss,k]=sort(diag(D));
%   ibl= sqrt(puiss(n-m+1:n)-mean(puiss(1:n-m)));
%    bl = ones(m,1) ./ ibl ;
%   BL=diag(bl)*U(1:n,k(n-m+1:n))';
%   IBL=U(1:n,k(n-m+1:n))*diag(ibl);
% else    % assumes no noise
%    IBL=sqrtm(Rx);
%    Q=inv(IBL);
% end;
% X=Q*X;


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
    M(:,u:u+m-1)=norm(Rxp,'fro')*Rxp;  % Frobenius norm =
end                                  % sqrt(sum(diag(Rxp'*Rxp)))


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
          end%% if
        end%% q loop
    end%% p loop
end%% while

% Estimate the mixing matrix
Ae = pinv(Q)*V;

% Estimate the source activities
% Y=V'*X(:,:); % estimated source activities

% edited by Mengjia He, 2023.04.24

% % perform permutation
% Ae_temp = Ae;
% [~,index] = max(abs(Ae),[],2);
% for m = 1:size(Ae,1)
    % if index(m) ~= m
        % Ae(m,:) = Ae_temp(index(m),:);
    % end
% end


% Y_temp = inv(Ae) * X_temp;
% correlationMatrix = zeros(m);
% for i = 1:m
    % for j = 1:m
        % temp = corrcoef(Y_temp(i, :), X_temp(j, :));
        % correlationMatrix(i, j) = temp(1,2);
    % end
% end
% permutation = munkres(-abs(correlationMatrix));
% Ae_perm = Ae(permutation, :);

% Scaling
W = diag(diag(Ae))*inv(Ae);
if norm(W,'fro') < m*0.5
	W = eye(m)-W;
end

Y =  W * X_temp;

end


function [assignment,cost] = munkres(costMat)
% MUNKRES   Munkres (Hungarian) Algorithm for Linear Assignment Problem. 
%
% [ASSIGN,COST] = munkres(COSTMAT) returns the optimal column indices,
% ASSIGN assigned to each row and the minimum COST based on the assignment
% problem represented by the COSTMAT, where the (i,j)th element represents the cost to assign the jth
% job to the ith worker.
%
% Partial assignment: This code can identify a partial assignment is a full
% assignment is not feasible. For a partial assignment, there are some
% zero elements in the returning assignment vector, which indicate
% un-assigned tasks. The cost returned only contains the cost of partially
% assigned tasks.

% This is vectorized implementation of the algorithm. It is the fastest
% among all Matlab implementations of the algorithm.

% Examples
% Example 1: a 5 x 5 example
%{
[assignment,cost] = munkres(magic(5));
disp(assignment); % 3 2 1 5 4
disp(cost); %15
%}
% Example 2: 400 x 400 random data
%{
n=400;
A=rand(n);
tic
[a,b]=munkres(A);
toc                 % about 2 seconds 
%}
% Example 3: rectangular assignment with inf costs
%{
A=rand(10,7);
A(A>0.7)=Inf;
[a,b]=munkres(A);
%}
% Example 4: an example of partial assignment
%{
A = [1 3 Inf; Inf Inf 5; Inf Inf 0.5]; 
[a,b]=munkres(A)
%}
% a = [1 0 3]
% b = 1.5
% Reference:
% "Munkres' Assignment Algorithm, Modified for Rectangular Matrices", 
% http://csclab.murraystate.edu/bob.pilgrim/445/munkres.html

% version 2.3 by Yi Cao at Cranfield University on 11th September 2011

assignment = zeros(1,size(costMat,1));
cost = 0;

validMat = costMat == costMat & costMat < Inf;
bigM = 10^(ceil(log10(sum(costMat(validMat))))+1);
costMat(~validMat) = bigM;

% costMat(costMat~=costMat)=Inf;
% validMat = costMat<Inf;
validCol = any(validMat,1);
validRow = any(validMat,2);

nRows = sum(validRow);
nCols = sum(validCol);
n = max(nRows,nCols);
if ~n
    return
end

maxv=10*max(costMat(validMat));

dMat = zeros(n) + maxv;
dMat(1:nRows,1:nCols) = costMat(validRow,validCol);

%*************************************************
% Munkres' Assignment Algorithm starts here
%*************************************************

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   STEP 1: Subtract the row minimum from each row.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
minR = min(dMat,[],2);
minC = min(bsxfun(@minus, dMat, minR));

%**************************************************************************  
%   STEP 2: Find a zero of dMat. If there are no starred zeros in its
%           column or row start the zero. Repeat for each zero
%**************************************************************************
zP = dMat == bsxfun(@plus, minC, minR);

starZ = zeros(n,1);
while any(zP(:))
    [r,c]=find(zP,1);
    starZ(r)=c;
    zP(r,:)=false;
    zP(:,c)=false;
end

while 1
%**************************************************************************
%   STEP 3: Cover each column with a starred zero. If all the columns are
%           covered then the matching is maximum
%**************************************************************************
    if all(starZ>0)
        break
    end
    coverColumn = false(1,n);
    coverColumn(starZ(starZ>0))=true;
    coverRow = false(n,1);
    primeZ = zeros(n,1);
    [rIdx, cIdx] = find(dMat(~coverRow,~coverColumn)==bsxfun(@plus,minR(~coverRow),minC(~coverColumn)));
    while 1
        %**************************************************************************
        %   STEP 4: Find a noncovered zero and prime it.  If there is no starred
        %           zero in the row containing this primed zero, Go to Step 5.  
        %           Otherwise, cover this row and uncover the column containing 
        %           the starred zero. Continue in this manner until there are no 
        %           uncovered zeros left. Save the smallest uncovered value and 
        %           Go to Step 6.
        %**************************************************************************
        cR = find(~coverRow);
        cC = find(~coverColumn);
        rIdx = cR(rIdx);
        cIdx = cC(cIdx);
        Step = 6;
        while ~isempty(cIdx)
            uZr = rIdx(1);
            uZc = cIdx(1);
            primeZ(uZr) = uZc;
            stz = starZ(uZr);
            if ~stz
                Step = 5;
                break;
            end
            coverRow(uZr) = true;
            coverColumn(stz) = false;
            z = rIdx==uZr;
            rIdx(z) = [];
            cIdx(z) = [];
            cR = find(~coverRow);
            z = dMat(~coverRow,stz) == minR(~coverRow) + minC(stz);
            rIdx = [rIdx(:);cR(z)];
            cIdx = [cIdx(:);stz(ones(sum(z),1))];
        end
        if Step == 6
            % *************************************************************************
            % STEP 6: Add the minimum uncovered value to every element of each covered
            %         row, and subtract it from every element of each uncovered column.
            %         Return to Step 4 without altering any stars, primes, or covered lines.
            %**************************************************************************
            [minval,rIdx,cIdx]=outerplus(dMat(~coverRow,~coverColumn),minR(~coverRow),minC(~coverColumn));            
            minC(~coverColumn) = minC(~coverColumn) + minval;
            minR(coverRow) = minR(coverRow) - minval;
        else
            break
        end
    end
    %**************************************************************************
    % STEP 5:
    %  Construct a series of alternating primed and starred zeros as
    %  follows:
    %  Let Z0 represent the uncovered primed zero found in Step 4.
    %  Let Z1 denote the starred zero in the column of Z0 (if any).
    %  Let Z2 denote the primed zero in the row of Z1 (there will always
    %  be one).  Continue until the series terminates at a primed zero
    %  that has no starred zero in its column.  Unstar each starred
    %  zero of the series, star each primed zero of the series, erase
    %  all primes and uncover every line in the matrix.  Return to Step 3.
    %**************************************************************************
    rowZ1 = find(starZ==uZc);
    starZ(uZr)=uZc;
    while rowZ1>0
        starZ(rowZ1)=0;
        uZc = primeZ(rowZ1);
        uZr = rowZ1;
        rowZ1 = find(starZ==uZc);
        starZ(uZr)=uZc;
    end
end

% Cost of assignment
rowIdx = find(validRow);
colIdx = find(validCol);
starZ = starZ(1:nRows);
vIdx = starZ <= nCols;
assignment(rowIdx(vIdx)) = colIdx(starZ(vIdx));
pass = assignment(assignment>0);
pass(~diag(validMat(assignment>0,pass))) = 0;
assignment(assignment>0) = pass;
cost = trace(costMat(assignment>0,assignment(assignment>0)));

end

function [minval,rIdx,cIdx]=outerplus(M,x,y)
ny=size(M,2);
minval=inf;
for c=1:ny
    M(:,c)=M(:,c)-(x+y(c));
    minval = min(minval,min(M(:,c)));
end
[rIdx,cIdx]=find(M==minval);

end