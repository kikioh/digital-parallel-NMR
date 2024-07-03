% variables manual for coil array code

% port variables

	% a_coil 	- coil port, incident wave

	% b_coil 	- coil port, reflect wave

	% a_connect - connect port, incident wave

	% b_connect - connect port, reflect wave

	% a_connect - connect port, incident wave

	% b_connect - connect port, reflect wave

	% a_free 	- free port, incident wave

	% b_free 	- free port, reflect wave

% S matrix

	% SC		- S matrix, coil array

	% SM		- S matrix, tuning and matching network

	% SF        - S matrix, free port

	% SCM   	- S matrix, coil port + network port, order: coil port - connect port - free port
	
	% SA		- S matrix, lower noise amplifer, order: input port - output port
	
% current, voltage and power

	% I_simu	- simulated current in coil port
	
	% I_free	- current in free port
	
	% V_free	- voltage in free port
	
	% P_free	- power in free port
	
% B field

	% Bp	 	- B field in transmission phase
	
	% Bm	 	- B field in reception phase, used in calculating FID strength
	
% index

	% m	 	- coil loop
	
	% n	 	- sample loop

	% k	 	- voxel loop
	
	% q	 	- nuclei loop