clear
close all
clc

load('overlap_ratio_v_lambda_sim.mat')
ovl_ratio_sim=ovl_ratio;
load('overlap_ratio_v_lambda_covid.mat')
ovl_ratio_covid=ovl_ratio;
clear ovl_ratio
avg_ovl_ratio_sim=mean(ovl_ratio_sim);
avg_ovl_ratio_covid=mean(ovl_ratio_covid);

figure(1); clf; hold on; 
plot(lambda,avg_ovl_ratio_sim,'b.-','LineWidth',3,'MarkerSize',30);
plot(lambda,avg_ovl_ratio_covid,'r.-','LineWidth',3,'MarkerSize',30);
set(gca,'XScale','log');
box;
xlabel('\lambda')
ylabel('Avg. Overlap Ratio')
legend('Simulated Data','COVID Data','Location','NorthWest')
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(findall(gcf,'-property','FontName'),'FontName','times');