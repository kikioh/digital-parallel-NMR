% use msbackadj.m to do baseline correction for NMR spectrum
% note: the baseline correction should be done after phase correction
%
% Mengjia He, 2023.05.11

function spec_bc = baseCorr(freq_axis,spec)

num = size(spec,1);
N = size(spec,2);
spec_bc = zeros(num,N);

for m = 1:num
    spec_bc_real = transpose(msbackadj(transpose(freq_axis),transpose(real(spec(m,:))),'WindowSize',300,'StepSize',150));
    spec_bc_imag = transpose(msbackadj(transpose(freq_axis),transpose(imag(spec(m,:))),'WindowSize',300,'StepSize',150));
    spec_bc(m,:) = spec_bc_real + 1i * spec_bc_imag;

end

end