clear
close all
clc

% Add all subfolders to path
addpath(genpath(pwd))

% Load state/country name file
load('USA_Euro_covid_data_31JULY2020.mat','statenames')

i=0;

% Uncomment any number of filenames to plot their results all at once.

% % L2

% i=i+1;
% filenames{i}='USA_Euro_July31_analysisFinal_L2.mat';
% i=i+1;
% filenames{i}='USA_Euro_Sept30_analysisFinal_L2.mat';
i=i+1;
filenames{i}='USA_Euro_Nov30_analysisFinal_L2.mat';

% % Elastic

% i=i+1;
% filenames{i}='USA_Euro_July31_analysisFinal_elastic.mat';
% i=i+1;
% filenames{i}='USA_Euro_Sept30_analysisFinal_elastic.mat';
i=i+1;
filenames{i}='USA_Euro_Nov30_analysisFinal_elastic.mat';

% % Partial Elastic

% i=i+1;
% filenames{i}='USA_Euro_July31_analysisFinal_partialElastic.mat';
% i=i+1;
% filenames{i}='USA_Euro_Sept30_analysisFinal_partialElastic.mat';
i=i+1;
filenames{i}='USA_Euro_Nov30_analysisFinal_partialElastic.mat';

% Plot Results
plot_covid_results(filenames,statenames)