# digital-parallel-NMR
A digital twin for liquid state parallel NMR Spectroscopy


## Description
This package offers a comprehensive suite for multiple physics simulations aimed at running parallel NMR experiments in a digital twin. We've set up a way to blend electromagnetic simulations with spin dynamics calculations. These simulations help to measure how radio waves affect different NMR detectors, which allows us understand the signals we get.

We also have a method to sort out the mixed-up signals. This not only gives us clean signals for each detector but also tells us how they're connected, like making a puzzle.

When doing tests all at once, we check how good certain control pulses are. We use the map we made to fix these control pulses, making them work together nicely and cancel out unwanted connections.

## Execution 
The code was developed and tested with the following packages:
- Matlab 2023a
- COMSOL Multiphysics 6.1
- Spinach v2.8 [Website](https://spindynamics.org/group/?page_id=12)

After the installation, 
- open the COMSOL file, you can choose channel numbers of 1,2,4,8, click, save and close. The RF and DC files are both needed.
- start COMSOL Livelink with Matlab
- add the folder 'kernels', 'examples', and 'COMSOL' to the Matlab path (Menu/File/Set Path)
- open the Cn_solenoid.m in the examples folder and run.
