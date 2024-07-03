% Script to rotate a vector in 3D space with a given axis
% Syntax:
%                 RotMat = rotateAxis(axis,theta)
%
% Parameters:
%
%    axis         -  axis name, can be x, y, or z;
% 					 or 1*3 vector, represent the direction of rotate axis, 
%					 set (0,0,0) as the original point of ratate axis.
%
%    theta        -  rotate angle, rad
%
% Outputs:
%
%    RotMat        -  Rotate matrix, which can be multiplifed by a vector
%                        
function RotMat = rotateAxis(axis,theta)

if numel(axis) == 1
	switch axis
		case 'x'
			vec = [1,0,0];
		case 'y'
			vec = [0,1,0];
		case 'z'
			vec = [0,0,1];
	end
elseif numel(axis) == 3
	vec = axis/norm(axis);
		
else
	error('axis should be a 1*3 vector');
		
end


generator = theta*[0,      -vec(3),  vec(2);        % Rotate phi along z axis
				   vec(3),       0, -vec(1);
                   -vec(2), vec(1),       0];

RotMat = expm(generator);

end

