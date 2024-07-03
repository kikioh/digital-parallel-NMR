% manual first-order phse correction, use zero- and first-order phase input
% Parameters:
%
%           spec - 1*N complex vector
%           ph0  - number belong to (-pi,pi), zero-order term
%           ph1  - number belong to (-pi,pi), first-order term
% Mengjia He, 2023.05.11


function spec_ph = manualPHC(spec, ph0, ph1)

np = size(spec,2);
ph = (ph0+ph1.*(1:np)/np); % linear phase
spec_ph= spec .* exp(1i*ph);

end


