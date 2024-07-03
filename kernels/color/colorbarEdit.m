% edit colorbar data and test, the cmap varible can be saved to
% Digital NMR\matlab\kernels\color library
%
% Mengjia He, 2023.06.24

clearvars;
close all;
clc;

%% edit RGB value
% data for JupiterAuroraBorealis from COMCOL colorbar library
% Preallocate the map
N = 129;
cmap=zeros(N*6-5,3);

% 1st section
cmap(1:N,1)=0;                                % reds
cmap(1:N,2)=linspace(0,0.471,N);              % greens
cmap(1:N,3)=linspace(0.043,0.906,N);          % blues

% 2nd section
cmap(N:N*2-1,1)=linspace(0,0.145,N);          % reds
cmap(N:N*2-1,2)=linspace(0.471,0.663,N);      % greens
cmap(N:N*2-1,3)=linspace(0.906,1,N);          % blues

% 3th section
cmap(N*2-1:N*3-2,1)=linspace(0.145,0.42,N);   % reds
cmap(N*2-1:N*3-2,2)=linspace(0.663,0.773,N);  % greens
cmap(N*2-1:N*3-2,3)=1;                        % blues

% 4th section
cmap(N*3-2:N*4-3,1)=linspace(0.42,0.6,N);     % reds
cmap(N*3-2:N*4-3,2)=linspace(0.773,0.843,N);  % greens
cmap(N*3-2:N*4-3,3)=1;                        % blues

% 5th section
cmap(N*4-3:N*5-4,1)=linspace(0.6,0.761,N);    % reds
cmap(N*4-3:N*5-4,2)=linspace(0.843,0.906,N);  % greens
cmap(N*4-3:N*5-4,3)=1;                        % blues

% 6th section
cmap(N*5-4:N*6-5,1)=linspace(0.761,0.863,N);  % reds
cmap(N*5-4:N*6-5,2)=linspace(0.906,0.949,N);      % greens
cmap(N*5-4:N*6-5,3)=1;                        % blues

% % 7th section
% cmap(N*6-5:N*7-6,1)=linspace(0.863,0.996,N);      % reds
% cmap(N*6-5:N*7-6,2)=linspace(0.949,1,N);         % greens
% cmap(N*6-5:N*7-6,3)=1;                        % blues

% % 8th section
% cmap(N*7-6:N*8-7,1)=linspace(0.996,1,N);      % reds
% cmap(N*7-6:N*8-7,2)=1;                        % greens
% cmap(N*7-6:N*8-7,3)=1;                        % blues

% [0 0 0.043];
% [0 0.471 0.906]; 1
% [0.145 0.663 1]; 2
% [0.42 0.773 1]; 3
% [0.6 0.843 1]; 4
% [0.761 0.906 1]; 5
% [0.863 0.949 1]; 6
% [0.996 1 1]; 7
% [1 1 1]; 8

%% plot colorbar

% hf = figure('Units','normalized'); 
% colormap(hmj_cmap('JupAuro'));
% 
% hCB = colorbar('east');
% set(gca,'Visible',false)
% hCB.Position = [0.4 0.1 0.1 0.74];
% % hf.Position(4) = 0.1000;
% clearvars;

Z = 10 + peaks;
surf(Z);
hold on
imagesc(Z);
colormap(flipud(hmj_cmap('JupAuro')));
colorbar;
% h = colorbar;
% set( h, 'YDir', 'reverse' );






