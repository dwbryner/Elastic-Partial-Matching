clear; 
close all;
clc;

% Add all subfolders to path
addpath(genpath(pwd))

%% Sim Data - L2

filenames={'sim_data_analysis_L2.mat'};

[sep,fin,fout,s]=compute_cluster_separability(filenames);

disp(['Separability: ' num2str(sep)])

figure(1); clf; hold on;
plot(s,fin,'b','LineWidth',3);
plot(s,fout,'r','LineWidth',3);
xlabel('Pairwise Similarity Measurement')
ylabel('Probability Density')
xlim([0,1]); 
box;
legend('Within Clusters','Across Clusters','Location','NorthWest')
title('Sim Data: L2 Metric')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','FontName'),'FontName','times')

%% Sim Data - Elastic

filenames={'sim_data_analysis_elastic.mat'};

[sep,fin,fout,s]=compute_cluster_separability(filenames);

disp(['Separability: ' num2str(sep)])

figure(2); clf; hold on;
plot(s,fin,'b','LineWidth',3);
plot(s,fout,'r','LineWidth',3);
xlabel('Pairwise Similarity Measurement')
ylabel('Probability Density')
xlim([0,1]);
box;
legend('Within Clusters','Across Clusters','Location','NorthWest')
title('Sim Data: Elastic Metric')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','FontName'),'FontName','times')

%% Sim Data - Partial Elastic

filenames={'sim_data_analysis_lambda0p01_partialElastic.mat'};

[sep,fin,fout,s]=compute_cluster_separability(filenames);

disp(['Separability: ' num2str(sep)])

figure(3); clf; hold on;
plot(s,fin,'b','LineWidth',3);
plot(s,fout,'r','LineWidth',3);
xlabel('Pairwise Similarity Measurement')
ylabel('Probability Density')
xlim([0,1]);
box;
legend('Within Clusters','Across Clusters','Location','NorthWest')
title('Sim Data: Elastic Metric with Partial Matching')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','FontName'),'FontName','times')

%% Covid Data - L2

filenames={'USA_Euro_July31_analysisFinal_L2.mat',...
    'USA_Euro_Sept30_analysisFinal_L2.mat',...
    'USA_Euro_Nov30_analysisFinal_L2.mat'};

[sep,fin,fout,s]=compute_cluster_separability(filenames);

disp(['Separability: ' num2str(sep)])

figure(4); clf; hold on;
plot(s,fin,'b','LineWidth',3);
plot(s,fout,'r','LineWidth',3);
xlabel('Pairwise Similarity Measurement')
ylabel('Probability Density')
xlim([0,1]);
box;
legend('Within Clusters','Across Clusters','Location','NorthWest')
title('Covid Data: L2 Metric')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','FontName'),'FontName','times')

%% Covid Data - Elastic

filenames={'USA_Euro_July31_analysisFinal_elastic.mat',...
    'USA_Euro_Sept30_analysisFinal_elastic.mat',...
    'USA_Euro_Nov30_analysisFinal_elastic.mat'};

[sep,fin,fout,s]=compute_cluster_separability(filenames);

disp(['Separability: ' num2str(sep)])

figure(5); clf; hold on;
plot(s,fin,'b','LineWidth',3);
plot(s,fout,'r','LineWidth',3);
xlabel('Pairwise Similarity Measurement')
ylabel('Probability Density')
xlim([0,1]);
box;
legend('Within Clusters','Across Clusters','Location','NorthWest')
title('Covid Data: Elastic Metric')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','FontName'),'FontName','times')

%% Covid Data - Partial Elastic

filenames={'USA_Euro_July31_analysisFinal_partialElastic.mat',...
    'USA_Euro_Sept30_analysisFinal_partialElastic.mat',...
    'USA_Euro_Nov30_analysisFinal_partialElastic.mat'};

[sep,fin,fout,s]=compute_cluster_separability(filenames);

disp(['Separability: ' num2str(sep)])

figure(6); clf; hold on;
plot(s,fin,'b','LineWidth',3);
plot(s,fout,'r','LineWidth',3);
xlabel('Pairwise Similarity Measurement')
ylabel('Probability Density')
xlim([0,1]);
box;
legend('Within Clusters','Across Clusters','Location','NorthWest')
title('Covid Data: Elastic Metric with Partial Matching')
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','FontName'),'FontName','times')

    