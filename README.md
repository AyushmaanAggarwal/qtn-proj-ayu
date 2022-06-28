# QTN Project
Using a Convolutional Neural Network to predict the plasma frequency, electron density, and electron temperature using QTN noise from various experiments: Wind/Waves.

# Files
cnn_wind.ipynb: contains Convolutional Neural Network with training, testing, and generating various graphs

cnn_wind_data_processing.ipynb: organize and save all necessary training and testing data from WIND/WAVES using pickle

wind_generate_data.ipynb: create synthetic data that sweeps all parameter spaces including electron temperatures, electron densities, plasma frequencies, solar wind speeds for a given antenna length

wind.ipynb: Yugong's code modified in order to get it running and change precision levels in theoretical code