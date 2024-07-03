% This code is just a front-end to source separation algorithms.
% Purpose:
% 1) generate synthetic data
% 2) call some source separation algorithm
% 3) display the results
% The data are CM (constant modulus signals and QAM4.
% The mixing matrix  is randomly generated.
% Comments, bug reports, info requests are appreciated
% and should be directed to cardoso@sig.enst.fr (Jean-Francois Cardoso)
% Author : Jean-Francois Cardoso CNRS URA 820 / GdR TdSI / Telecom Paris
clearvars;
close all;
clc;
%=======================================================================
num	= 3 	;  % M = number of sources
numP = 1000;
T = 10;
Fs = numP/T;
NdB	= -10 	;  % kind of noise level in dB


% the source signals
time_grad = linspace(0,T,numP);
S1 = 10*exp(2*2i*pi*time_grad);
S2 = 10*exp(10*2i*pi*time_grad);
S3 = 10*exp(7*2i*pi*time_grad);
S= [S1;S2;S3];

% random mixing matrix
A=randn(num)+1i*randn(num);
noiseamp = 10^(NdB/20)/sqrt(2) ; % (the sqrt(2) accounts for real+imaginary powers)
X= A*S + noiseamp*(randn(num,numP)+1i*randn(num,numP));

% visualize detected data
specX = zeros(size(X));
x_axis = linspace(-Fs/2,Fs/2-Fs/numP,numP);
fig1 = figure;
for m = 1:num
    specX(m,:)=fftshift(fft(X(m,:)));
    plot(x_axis,abs(specX(m,:))); hold on;
end
title('spectrum of detected signal');

% Separation

% amsue method
Ae=amuse(X);
% Ae = Ae/norm(Ae,'fro')*num;
Se = Ae*X;

% jade method
[Ae1,~]=jade(X,num);
Ae1 = Ae1/norm(Ae1,'fro')*2;
Se1 = Ae1\X;

% visualize splitted data
specS = zeros(size(Se));
fig2 = figure;
for m = 1:num
    specS(m,:)=fftshift(fft(Se(m,:)));
    plot(x_axis,abs(specS(m,:))); hold on;
end
title('spectrum of splited signal');

% visualize splitted data
specS1 = zeros(size(Se1));
fig2 = figure;
for m = 1:num
    specS1(m,:)=fftshift(fft(Se1(m,:)));
    plot(x_axis,abs(specS1(m,:))); hold on;
end
title('spectrum of splited signal');
