function [B0,B1x,B1y] = ImportData(mphname, sample)

model=mphopen(mphname);

% import sample geometry
r_sample = mphevaluate(model,'r_sample');

value = mphevaluate(model,{'r_sample','l_sample'});

% import S parameters
S = mphevalglobalmatrix(model,'emw.S','dataset','dset2');

% import port current
I1 = mphglobal(model,'emw.Iport_1','solnum','all');

if nargout == 1
    B0 = mphinterp(mphname,'mfnc.Bz','coord',sample)';
    return
elseif nargout == 2
    B1x = mphinterp(mphname,'emw.Bx','coord',sample)';
    B1y = mphinterp(mphname,'emw.By','coord',sample)';
    return
else
    % Import the B0 field
    B0 = mphinterp(mphname,'mfnc.Bz','dataset','dset2','coord',sample)';

    % Import the B1 field
    B1x = mphinterp(model,'emw.Bx','dataset','dset1','coord',sample)';
    B1y = mphinterp(model,'emw.By','dataset','dset1','coord',sample)';
	
	
end
end