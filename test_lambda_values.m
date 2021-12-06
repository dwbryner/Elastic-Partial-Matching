clear; 
close all;
clc;

% Add all subfolders to path
addpath(genpath(pwd))

% load sim_data

load USA_Euro_covid_data_30NOV2020

tid=linspace(0,1,T);
nlam=10;
lambda=10.^linspace(-2,1,nlam);

% Set grid
num_a=50;
min_ovl=1/2;
agrid=exp(linspace(log(min_ovl),-log(min_ovl),num_a));

% Set gradient descent parameters
stepsize=1e-4;
tol=1e-3;
maxit=300;
plotevol=false;


%% Compute average overlap ratio for each lambda value

npairs=100;
idx=zeros(npairs,2);
A=false(K);
count=1;
while count<=npairs
    idx(count,1)=randsample(1:K-1,1);
    idx(count,2)=randsample(idx(count,1)+1:K,1);
    if ~A(idx(count,1),idx(count,2))
        A(idx(count,1),idx(count,2))=true;
        count=count+1;
    end
end

ovl_ratio=zeros(npairs,nlam);
for i=1:npairs
    t1=tk(idx(i,1),:);
    t2=tk(idx(i,2),:);
    f1=fk(idx(i,1),:);
    f2=fk(idx(i,2),:);
    q1=qk(idx(i,1),:);
    q2=qk(idx(i,2),:);
    disp(['Pair number: ' num2str(i)])
    for j=1:nlam
        disp(['  lambda = ' num2str(lambda(j))]);
        [~,~,~,t2best,~]=shape_distance(q1,t1,q2,t2,f2,lambda(j),tid,...
            agrid,stepsize,tol,maxit,plotevol);
        ovl_ratio(i,j)=min([t1(end),t2best(end)])/max([t1(end),t2best(end)]);
    end
end
avg_ovl_ratio=mean(ovl_ratio);

clr=summer(nlam+1);
figure(4); clf; hold on; 
plot(lambda,avg_ovl_ratio,'k','LineWidth',2);
set(gca,'XScale','log');
for i=1:nlam
    plot(lambda(i),avg_ovl_ratio(i),'.','color',clr(i,:),'MarkerSize',30);
end
box;
xlabel('\lambda')
ylabel('Avg Overlap Ratio')
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(findall(gcf,'-property','FontName'),'FontName','times');


% figure(5); clf; hold on;
% nx=1000;
% x=linspace(agrid(1),1,nx);
% mode_ovl_ratio=zeros(1,nlam);
% for i=1:nlam
%     fx=ksdensity(ovl_ratio(:,i),x);
%     [~,ix]=max(fx);
%     mode_ovl_ratio(i)=x(ix);
%     plot(x,fx,'color',clr(i,:),'LineWidth',2);
% end
% box;
% xlim([agrid(1) 1])
% ylim([0 6])
% xlabel('Overlap Ratio')
% ylabel('Density Value')
% set(findall(gcf,'-property','FontSize'),'FontSize',16);
% set(findall(gcf,'-property','FontName'),'FontName','times');
% 
% figure(6); clf; hold on; 
% plot(lambda,mode_ovl_ratio,'k','LineWidth',2);
% set(gca,'XScale','log');
% for i=1:nlam
%     plot(lambda(i),mode_ovl_ratio(i),'.','color',clr(i,:),'MarkerSize',30);
% end
% box;
% xlabel('\lambda')
% ylabel('Most Likely Overlap Ratio')
% set(findall(gcf,'-property','FontSize'),'FontSize',16);
% set(findall(gcf,'-property','FontName'),'FontName','times');

% save('overlap_ratio_v_lambda_covid.mat','lambda','ovl_ratio')
