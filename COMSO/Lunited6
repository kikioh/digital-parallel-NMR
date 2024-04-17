% Spin system
sys.isotopes={'1H'};

% Interactions
sys.magnet=11.74;
inter.zeeman.scalar={-1.00};

% Basis set
bas.formalism='zeeman-hilb';
bas.approximation='none';

% Spinach housekeeping
spin_system=create(sys,inter);
spin_system=basis(spin_system,bas);

% initial state
rho0 = state(spin_system,'L+','1H')+state(spin_system,'L-','1H');
rho0 = rho0/norm(rho0,'fro');

% coil state
coil = state(spin_system,'L+','1H');
coil = coil/norm(coil,'fro');

% spin operator
Lz = operator(spin_system,'Lz','1H');

% hamiltonian
H = hamiltonian(assume(spin_system,'nmr'));
% H2 = -spin('1H')*1*sys.magnet*1e-6*Lz;

H = frqoffset(spin_system,H,parameters);

% Hoff2 = H2+2*pi*500*Lz;

% Sequence parameters
parameters.rho0 = rho0;
parameters.coil = coil;
parameters.offset=500;
parameters.sweep=4000;
parameters.npoints=512;
parameters.zerofill=1024;
parameters.spins={'1H'};

% Simulation
fid=liquid(spin_system,@acquire,parameters,'nmr');

% Apodization
fid=apodization(fid,'exp-1d',6);

% Fourier transform
spectrum=fftshift(fft(fid,parameters.zerofill));

%Plotting
figure();
plot_1d(spin_system,real(spectrum),parameters);
