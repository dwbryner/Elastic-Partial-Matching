clear; 
close all;
clc;

% Add all subfolders to path
addpath(genpath(pwd))

% Select method. If elastic partial matching is selected, set algorithm
% parameters.
In.metrictype='partial'; % 'L2', 'elastic', or 'partial
if strcmp(In.metrictype,'partial')
    In.lambda=0.25; % Metric parameter
    In.agrid=exp(linspace(-log(2),log(2),50)); % Time-scaling grid for grid-search algorithm
    In.stepsize=1e-4; % Gradient descent stepsize
    In.tol=1e-3; % Gradient descent convergence tolerance
    In.maxit=300; % Max iterations for gradient descent
    In.maxit_align=10; % Max iterations for within-cluster alignment
end

% Select Bayesian clustering parameters
In.numIter_cluster=10000; % Total number of MCMC iterations
In.Minit=10; % Initial number of clusters 
In.xi_CRP=0.2; % Parameter for Chinese Restaurant Process
In.theta_vect = 0.2:0.2:1; % Prior of theta


% Select dataset, and set file name to save results. Naming convention will
% automatically append the metric type to the end of the savefile name.

% In.datafile='sim_data.mat';
% In.savefile='sim_data_analysis';
%
% In.datafile='USA_Euro_covid_data_31JULY2020.mat';
% In.savefile='USA_Euro_July31_analysisFinal';
% 
% In.datafile='USA_Euro_covid_data_30SEPT2020.mat';
% In.savefile='USA_Euro_Sept30_analysisFinal';

In.datafile='USA_Euro_covid_data_30NOV2020.mat';
In.savefile='USA_Euro_Nov30_analysisFinal';


% Run the analysis - (1) Compute similarity matrix, (2) Clustering, (3)
% Within-cluster alignment for elastic methods, (4) Cluster means and variances 
tic
analyze_data(In);
toc

