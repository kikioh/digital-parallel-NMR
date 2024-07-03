% calculate the total B field inside the sample, with N port excitation
% Syntax:
%
%             Bp = BpNPort(coil,sampleCoord,model,comsol)
%
% Parameters: 
%         coil  	- struct                 
%          		freq - frequency
%          		Z0   - charactertic impedance
%          		S 	 - coil array S parameters
%		   		excite	- incident voltage in free port
%		   		current	- simulated current prototype
%		   		freqIndex - frequency Index in comsol model
%
%         sampleCoord  - coordinate of the smaple points
%
%         modelName    - COMSOL model
%
%         comsol  	- struct                 
%          		dset - string, dataset in comsol
%
% Outputs:
%
%     	   Bp     - B+ field vector in N excitation
%     	   Coeff  -  matrix, each colume represent one voxel's linear coefficient on coil current
%
% Mengjia He, 2022.06.27

function [Bp, Coeff] = BpNPort(coil,sampleCoord,model,comsol)

% extract coil parameters
Z0 = coil.Z0; 
SC = coil.SC; 
SM = coil.SM;
I_simu = coil.current; 
a_free = transpose(coil.excite);

% calculate actual coil current
I_coil = IcArray(Z0, SC, SM, a_free);
I_coil = transpose(I_coil);

% select solution number, i.e., frequency
if isfield(coil,'freqIndex')
	solNum = coil.freqIndex;
else
	solNum = 1;
end

% default B field calaulation: no approximation
if ~isfield(coil,'approximation') coil.approximation='none'; end

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
Bp = zeros(1,n);   			% prelocate the B+ field at sample points
Coeff = zeros(coil.num,n);
for m = 1:n					% voxel loop

	B_simu = Bx(m,:) + 1i*By(m,:);
	[~,Coeff(:,m)] = I2B(I_coil, B_simu,I_simu);
	
	if strcmp(coil.approximation,'none')
		Bp(m) = I_coil  * Coeff(:,m);
	else
		[~,Ind_Max] = max(abs(Coeff(:,m)));
		Bp(m) = I_coil(Ind_Max) * Coeff(Ind_Max,m);
		
	end

end

end


