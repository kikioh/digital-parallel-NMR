% sort the x and y variables in a 2D plane and correspond to Z variable
% unsorted z = f(x,y) to sorted z = f(x,y)
%
% Mengjia He, 2022.05.23

clearvars;
clc;
% imput x and y data
x = [linspace(0,3,30),linspace(0,-3,30)];
y = [linspace(0,2,20),linspace(0,-2,20)];

% generate z data
[X,Y] = meshgrid(x,y);
Z = X.^2+Y.^2;

% sort x and y, correspond to z
[X,Index1] = sort(X,2);
[Y,Index2] = sort(Y,1);
Z = Z(Index2(:,1),Index1(1,:));

% plot z = f(x,y)
surf(X,Y,Z);
xlabel('x');
ylabel('y');
