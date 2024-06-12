# AADS
Autonomous Anomaly Detection for Streaming Data

AADSonlineV2.m is the main file that run the algorithm

This code need
https://www.mathworks.com/matlabcentral/fileexchange/64303-mqtt-in-matlab 
Please install it to run

We use topic 'Incoming/Data/Random', you can change it as desired

1) Run AADSonlineV2.m
2) Run AADS_Streaming_Data_Supplier.ipynb in google colab.
   - This will be according to type of data file. We provide .csv and .mat.
   - For .mat run cell 1,2 & 3
   - For .csv run cell 1, 4, 5 and 6 (Please change the name of .csv file in cell 5 (Currently 'SPECTxNewAADS.csv')
3) We provide three dataset
   - breastw.mat (breast cancer wisconsin
   - ionosphere.mat (ionosphere)
   - SPECT.csv (SPECT)
 
