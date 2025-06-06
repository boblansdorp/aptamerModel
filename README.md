# aptamerModel
Physical electrochemistry model of aptamer sensor
## Introduction
These simulations are written in Mathematica (run version 13.1).
The main goal of the simulations are to be able to reproduce Square Wave Voltammetry with different cell parameters.

In addition, radialConductivity.m explores electrostatics to generate an effective resistance between two electrodes in a cylindrical geometry.


#### Goals: 
1. Reproduce experimental data from different applied voltages using a single theoretical framework
2. Test different types of noise on signal results
3. Provide suggestions for experiments to run
4. Improve on existing aptamer biosensors using insights obtained!


## Remaining items to do

- get the gain vs concentration curve for ACV
- add noise to simulate drift in various parameters
- simulate EIS

## Insights and thoughts

- because applied voltage is known, we are not in overdamped condition. \
 Fitting the noise spectrum alone is underutilizing the data - we must use \
both the Applied Voltage and measured current to derive system parameters

- should measure drift in peak redox potential vs time
- if each aptamer can only undergo N redox cycles before bleaching \
irreversibly, what is optimal signal profile V(t) and signal \
extraction technique?
- Square Wave Voltammetry where only 1 current is used and the rest \
of the data is thrown away is extremely wasteful towards electrons 
- gain is a strange metric. we should be optimizing SNR
- Is capacitance of the gold with monolayer a function of applied \
potential? Mott Schottky plot of gold suggests that: no it's \
not!!
- if the effective impedance contribution of the aptamers is small, \
then most ions are related to nonspecific capacitance double layer \
charge, and so the voltage that the aptamer experiences is equal to \
the voltage over the capacitor
- we are using Butler Volmer kinetics with n=2 for Methylene blue. What happens if we use Marcus theory instead?