# Autonomous Anomaly Detection for Streaming Data (AADS)

The paper can be accessed at https://doi.org/10.1016/j.knosys.2023.111235

To execute the algorithm, you'll need the main file, AADSonlineV2.m. This code relies on the MQTT communication protocol implemented in MATLAB, which can be installed from https://www.mathworks.com/matlabcentral/fileexchange/64303-mqtt-in-matlab. Ensure you have this installed before running the code.

The algorithm subscribes to the topic 'Incoming/Data/Random', though you have the flexibility to modify it to your preference.

Additionally, to test the algorithm, you can run AADS_Streaming_Data_Supplier.ipynb in Google Colab from the Dataset folder. Depending on the type of data file you have (either .csv or .mat), follow different steps:

1) For .mat files, execute cells 1, 2, and 3.
2) For .csv files, run cells 1, 4, 5, and 6. Make sure to adjust the filename in cell 5 (currently set as 'SPECTxNewAADS.csv'). Also, edit cell 6 to match the label (column) name of your dataset, as it might differ.

You're not obligated to run the .ipynb file; you can create your own code to publish data to the desired topic.

The provided datasets are:
- breastw.mat (Breast Cancer Wisconsin) [1]
- ionosphere.mat (Ionosphere) [1]
- SPECTxNewAADS.csv (SPECT) [2]

You can identify anomaly data within the clustMember variable based on the indices stored in the anomalyclustIDX variable.

The ultimate result will be the anomalyCluster, which represents the center of the anomaly cluster.

Reference
1) S. Rayana, “ODDS Library,” 2016. http://odds.cs.stonybrook.edu/
2) A. Asuncion and D. Newman, “UCI machine learning repository,” 2007
 
