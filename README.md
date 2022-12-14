# QTN Project
Using a Convolutional Neural Network to predict the plasma frequency, electron density, and electron temperature using QTN noise from various experiments: Wind/Waves.

# Files
## CNNS
cnn_wind.ipynb: contains Convolutional Neural Network with training, testing, and generating various graphs

cnn_wind_data_processing.ipynb: organize and save all necessary training and testing data from WIND/WAVES using pickle

wind_generate_data.ipynb: create synthetic data that sweeps all parameter spaces including electron temperatures, electron densities, plasma frequencies, solar wind speeds for a given antenna length, not currently producing useful training data

## Understanding CNNs
understanding_cnn_backpropogation.ipynb: Traces weight by weight to see what neurons are most important

understanding_cnn_gradient_ascent.ipynb: Uses a common cnn approach of gradient ascent to understand the ideal inputs for a cnn

## Other Files
wind.ipynb: Yugong's code modified in order to get it running and change precision levels in theoretical code

Martinović Algorithm.ipynb: Alternative peakfininding algorithm(in progress)

Finding_best_huber_value.ipynb: Alternative activation function, trying to optimize and find the best huber parameters

testing_importing_data.ipynb: Random testing file for trying to import packages and files into python
