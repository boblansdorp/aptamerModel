# aptamerModel
Physical electrochemistry model of aptamer sensor

#### Goals: 
1. Reproduce experimental data from different applied voltages using a single theoretical framework
2. Test different types of noise on signal results
3. Provide suggestions for experiments to run
4. Improve on existing aptamer biosensors using insights obtained!


## Remaining items to do

- Make the solutions for current i[t] also be a function of applied \
voltage VApplied[t], so we can solve for different square wave,\
AC voltage, or arbitrary voltage application patterns
- get the gain vs concentration curve for SWV and AC
- add noise to simulate drift in various parameters

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
