# Autonomous Anomaly Detection for Streaming Data (AADS)

AADSonlineV2.m is the main file that run the algorithm

This code need
https://www.mathworks.com/matlabcentral/fileexchange/64303-mqtt-in-matlab 
Please install it to run

We use topic 'Incoming/Data/Random', you can change it as desired

1) Run AADSonlineV2.m
2) Run AADS_Streaming_Data_Supplier.ipynb in google colab (inside Dataset folder).
   - This will be according to type of data file. We provide .csv and .mat.
   - For .mat run cell 1,2 & 3
   - For .csv run cell 1, 4, 5 and 6 (Please change the name of .csv file in cell 5 (Currently 'SPECTxNewAADS.csv')
   - Please edit cell 6 as well because the label (column) name may differ for other dataset
   - It is not mandotory to run the .ipynb. You can create your own code to publish data to the desired topic.
3) We provide three dataset
   - breastw.mat (breast cancer wisconsin [1]
   - ionosphere.mat (ionosphere) [1]
   - SPECTxNewAADS.csv (SPECT) [2]

Reference
1) S. Rayana, “ODDS Library,” 2016. http://odds.cs.stonybrook.edu/
2) A. Asuncion and D. Newman, “UCI machine learning repository,” 2007
 
