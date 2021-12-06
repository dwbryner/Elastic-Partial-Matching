clear
close all
clc

% Add all subfolders to path
addpath(genpath(pwd))

% Load simulated data
filenames{1}='sim_data_analysis_L2.mat';
filenames{2}='sim_data_analysis_elastic.mat';
filenames{3}='sim_data_analysis_lambda0p01_partialElastic.mat';

% Plot Results
plot_sim_results(filenames);