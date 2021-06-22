# Master_Thesis_NOx_Emissions
The Data file regroups all the excel files recorded by the datalogger

The code file regroups all the codes used for the purpose of this master thesis. There are matlab function and the arduino code from the datalogger. 

Herebelow is a description of each matlab function:
- histo.m allows to plot all the histograms to create the decision tree, it reads data from the datalogger and from the Testo using both read_Datalogger.m and read_Testo.m
- redressement.m will rectify the signal of the accelerations in the y and z directions by continuously computing the road slope angle with the altitude
- wltp_fun.m and wltp_analysis.m allow to compute the different characteristics of the WLTP cycle performed for each part: Low, Medium, High, Extra High. 
- read_Datalogger.m is a function that reads the raw data from the datalogger in argument and returns different parameters: the filtered and rectified acceleration y, the mass flow rate of air, the speed, RPM, Theta (the road slope angle) filtered. 
- read_Testo.m is a function that reads the raw data from the Testo and datalogger in argument and computes the NOx in g/km. It uses only the speed and the mass flow rate of air from the datalogger, while it uses the ppm_NO and ppm_NO2 from the Testo. 
- datalogger_filtering.m is a script that analyses the different filtering methods for the acceleration signals from the datalogger and it rectifies these signals. 
- NOx_Reader.m is a script that analyses the different parameters obtainable from the testo. It is similar to read_Testo.m. 
