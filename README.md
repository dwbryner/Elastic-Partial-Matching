# Elastic-Partial-Matching
This is a Matlab code package for the methodology and results presented in the following journal paper: 

D. Bryner and A. Srivastava. "Shape analysis of functional data with elastic partial matching." IEEE Transactions on Pattern Analysis and Machine Intelligence. 2021.

Data: 

The package comes with four processed datasets: a simulated dataset entitled 'sim_data.mat' and three real COVID-19 datasets entitled 'USA_Euro_covid_data_31JULY2020.mat', 'USA_Euro_covid_data_30SEPT2020.mat', and 'USA_Euro_covid_data_30NOV2020.mat'. Each dataset mat file has the following variables:

K - Number of functions in the dataset
T - Number of sample points per function
tk - K x T array with the kth row representing the time sample points for the kth function.
fk - K x T array with the kth row representing the kth function evaluated at its respective time points given in tk.
qk - K x T array with the kth row representing the kth SRVF evaluated at its respective time points given in tk. 
labels_true (simulated data only) - K x 1 array of true class labels. 
statenames (COVID data only) - K x 1 cell array with the kth cell consisting of the state or country name (string) associated with the kth function (infection rate curve). 

The COVID datasets consist of normalized infection rate curves for 52 US states (including DC and Puerto Rico) and 47 European countries truncated at three different time points - July 31, September 30, and November 30 of the year 2020 (see Section 4 of our paper for more details). We also include the raw data files 'CONVENIENT_global_confirmed_cases.xlsx' and 'CONVENIENT_us_confirmed_cases.xlsx' that we used to process the COVID datasets, which are current up to Dec 7, 2020. Use the script entitled 'process_covid_data.m' to preprocess the raw COVID data into the format accepted by the code package. In order to create a merged dataset of US states and global countries, it is necessary to run the script twice - once for each raw data file - selecting the state/country indices to keep or discard each time, and merge the results according to the code in the script. However, since the package already comes with processed data, it is not required to run this script. 

Main scripts for data analysis:

'test_partial_alignment.m' - Loads a dataset, selects an index pair, and computes the preshape distance (Definition 1), standard elastic distance with fixed endpoints, and shape distance (Eq 3) using elastic partial matching. Generates plots of the optimal diffeomorphisms required for alignment as well as the original and aligned functions themselves (see Fig 6). Use this script to test algorithm parameters on a single pairwise alignment before running the full data analysis script. 

'run_data_analysis.m' - This script sets up and runs the 'analyze_data.m' function, which computes the following from a functional dataset: (1) Pairwise similarity matrix, (2) unsupervised Bayesian clustering, (3) within-cluster mutual alignment (elastic methods only), and (4) cross-sectional mean and variance for each cluster. There is an option to select either the standard L2 metric, the elastic metric with fixed endpoints, or our novel elastic partial matching methodology for generating the pairwise similarity matrix. We used this script to generate and save results that we published in Section 4.3 of our paper. 

'plot_covid_data_analysis.m' - This script sets up and executes the plotting function 'plot_covid_data.m' to generate the images seen in Figs. 9, 10, and 11. There is a similar script for plotting simulated data, 'plot_sim_data_analysis.m', which does not generate a plot of the colorized country/state map resulting from the COVID analysis.   

'run_cluster_separability.m' - This script runs the cluster separability analysis as shown in Fig. 12. 

Scripts for algorithm performance experiments (1) - (4) in Section 4.2: 
(1) test_comptime.m
(2) test_gridpoints.m
(3) test_gradient_init.m
(4) test_lambda_values.m



