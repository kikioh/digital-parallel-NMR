# digital-parallel-NMR
A digital twin for parallel liquid-state NMR Spectroscopy


## Description
This package offers a comprehensive suite for multiple physics simulations aimed at running parallel NMR experiments in a digital twin. We've set up a way to blend electromagnetic simulations with spin dynamics calculations. These simulations help to measure how radio waves affect different NMR detectors, which allows us to understand the signals we get.

We also have a method to sort out the mixed-up signals. This not only gives us clean signals for each detector but also tells us how they're combined.

While the optimal control pulses designed for one channel fail in the parallel operation, by doing tests all at once, we check how good certain control pulses are. We use the coupling information we obtained to fix these control pulses, making them work together nicely and cancel out unwanted connections.

## Execution 
The code was developed and tested with the following packages:
- Matlab 2023a, check Spinach for the required toolboxes
- COMSOL Multiphysics 6.1, require 'mfnc' and 'emw' module
- [Spinach v2.8](https://spindynamics.org/group/?page_id=12)

After the installation, 
- open the COMSOL file, you can choose channel numbers of 1,2,4,8, click compute, then save and close. The RF and DC files are both needed.
- start COMSOL Livelink with Matlab
- add the folder 'kernels'(including subfolders), 'examples', and 'COMSOL' to the Matlab path (Menu/File/Set Path)
- open the Cn_solenoid.m in the examples folder and run.

## Paper
The paper was published in [Communications Engineering](https://www.nature.com/articles/s44172-024-00233-0)
He, M., Faderl, D., MacKinnon, N. et al. A digital twin for parallel liquid-state nuclear magnetic resonance spectroscopy. Commun. Eng. 3, 90 (2024).
