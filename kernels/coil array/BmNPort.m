% calculate the B- field inside the sample，for N coil array
% Syntax:
%
%             Bm = BmNPort(coil,sampleCoord,modelName)
%
% Parameters: 
%          coil - structure, include flowing elements             
%  				I_simu		- coil current from COMSOL
% 				num			- coil number
%
%          sampleCoord  - coordinate of the smaple points
%          modelName    - COMSOL model
%
% Outputs:
%
%     	   Bm     - n_pos*N matrix, B- field vector
%
% Ref:2000-D. I. HOULT-Concepts in Magnetic Resonance-The Principle 
% of Reciprocity in Signal Strength Calculationsᎏ A Mathematical Guide-Eq.(27)
%
% Mengjia He, 2022.06.230

function Bm = BmNPort(coil,sampleCoord,model,comsol)

% extract coil parameters

I_simu = coil.current;
coil_num = coil.num; 

% select solution number, i.e., frequency
if isfield(coil,'freqIndex')
	solNum = coil.freqIndex;
else
	solNum = 1;
end

% extract B field in sample points
Bx = mphinterp(model,'emw.Bx','dataset',comsol.dset,'coord',sampleCoord,'outersolnum','all','solnum',solNum);
By = mphinterp(model,'emw.By','dataset',comsol.dset,'coord',sampleCoord,'outersolnum','all','solnum',solNum);
Bx = squeeze(Bx); By = squeeze(By);

if coil.num == 1
	Bx = transpose(Bx);
	By = transpose(By);
end

% loop the sample points to calculate B+ field
n = size(sampleCoord,2);	% number of sample points
Bm = zeros(n,coil_num);   	% prelocate the B- field at sample points

for m = 1:n

	B_simu = Bx(m,:) - 1i*By(m,:);
	Bm(m,:)  = lsqminnorm(I_simu,transpose(B_simu));
	

end

end


