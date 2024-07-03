% move the sample coordinate to a different center given by user 
% Syntax 
% sample_moved = xyzMove(sample,center)
% Arguments
% sample:     3*n array, sample coordinate
% center: 1*3 vector,like [x0,y0,z0], the center to be moved to
% Outputs
% sample:       3*n array, new coordinate of the sampling points


% Mengjia He 2022.02.14

function sample_moved = xyzMove(sample,center)
n_pos= size(sample,2);
move_vector = [center(1)*ones(1,n_pos);center(2)*ones(1,n_pos);...
    center(3)*ones(1,n_pos)];
sample_moved = sample + move_vector;

end